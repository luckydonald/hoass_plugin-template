#!/usr/bin/env node
import fs from 'fs';
import path from 'path';
import os from 'os';
import child_process from 'child_process';

function findFiles(root) {
  const exts = ['.ts', '.tsx', '.js', '.jsx', '.vue'];
  const out = [];
  function walk(dir) {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const e of entries) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) {
        if (e.name === 'node_modules' || e.name === 'dist' || e.name === '.git') continue;
        walk(p);
      } else if (e.isFile()) {
        if (exts.includes(path.extname(e.name))) out.push(p);
      }
    }
  }
  walk(root);
  return out;
}

function runDprintOnHtml(html, cwd) {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'embedded-html-'));
  const tmpFile = path.join(tmpDir, 'snippet.html');
  fs.writeFileSync(tmpFile, html, 'utf8');
  const localDprint = path.join(cwd, 'node_modules', '.bin', 'dprint');
  const cmd = fs.existsSync(localDprint) ? localDprint : 'dprint';
  const res = child_process.spawnSync(cmd, ['fmt', tmpFile], { encoding: 'utf8', cwd });
  if (res.error) {
    try { fs.unlinkSync(tmpFile); fs.rmdirSync(tmpDir); } catch (e) {}
    throw res.error;
  }
  if (res.status !== 0) {
    const err = res.stderr || 'dprint failed';
    try { fs.unlinkSync(tmpFile); fs.rmdirSync(tmpDir); } catch (e) {}
    throw new Error(err);
  }
  const out = fs.readFileSync(tmpFile, 'utf8');
  try { fs.unlinkSync(tmpFile); fs.rmdirSync(tmpDir); } catch (e) {}
  return out;
}

function formatEmbeddedInSource(src, filePath, frontendRoot) {
  // We'll search for occurrences of `.innerHTML = ` and then parse the template literal
  let idx = 0;
  let changed = false;
  let out = '';
  while (idx < src.length) {
    const pos = src.indexOf('.innerHTML', idx);
    if (pos === -1) { out += src.slice(idx); break; }
    // copy up to pos
    out += src.slice(idx, pos);
    // from pos find the '=' and following backtick
    const assignMatch = src.slice(pos).match(/\.innerHTML\s*=\s*/);
    if (!assignMatch) {
      // shouldn't happen, but copy one char and continue
      out += src[pos];
      idx = pos + 1;
      continue;
    }
    const assignStart = pos + assignMatch.index + assignMatch[0].lastIndexOf('=');
    // find first backtick after assignStart
    const bt = src.indexOf('`', assignStart);
    if (bt === -1) {
      // no template literal; copy and continue
      out += src.slice(pos, pos + assignMatch.index + assignMatch[0].length);
      idx = pos + assignMatch.index + assignMatch[0].length;
      continue;
    }
    // find closing backtick, taking escaping into account
    let i = bt + 1;
    let end = -1;
    while (i < src.length) {
      if (src[i] === '`') {
        // count backslashes before
        let bs = 0; let j = i - 1; while (j >= 0 && src[j] === '\\') { bs++; j--; }
        if (bs % 2 === 0) { end = i; break; }
      }
      i++;
    }
    if (end === -1) {
      // unterminated template, copy rest and break
      out += src.slice(pos);
      break;
    }
    const fullExpr = src.slice(pos, end + 1);
    // content between backticks
    const content = src.slice(bt + 1, end);
    // if content contains ${} skip
    if (content.includes('${')) {
      // copy the original and continue
      out += fullExpr;
      idx = end + 1;
      continue;
    }
    // Determine indentation: line start before backtick
    const lineStart = src.lastIndexOf('\n', bt) + 1;
    const indentMatch = src.slice(lineStart, bt).match(/^[ \t]*/);
    const indent = indentMatch ? indentMatch[0] : '';

    // Trim leading/trailing blank lines like typical usage
    let inner = content.replace(/^[\n\r]+/, '').replace(/[\n\r]+$/, '\n');
    // Format with dprint using frontendRoot
    let formattedHtml;
    try { formattedHtml = runDprintOnHtml(inner, frontendRoot); }
    catch (e) { console.error('dprint failed for', filePath, e.message || e); out += fullExpr; idx = end + 1; continue; }
    // Trim trailing newlines
    formattedHtml = formattedHtml.replace(/[\n\r]+$/, '\n');
    // Indent each line with indent + two spaces
    const lines = formattedHtml.split(/\r?\n/);
    const indented = lines.map(l => (l.length === 0 ? '' : indent + '  ' + l)).join('\n');
    // build new template literal: backtick + newline + indented + newline + indent + closing backtick
    const newLiteral = '`\n' + indented + '\n' + indent + '`';
    // construct the prefix from pos up to bt (so includes .innerHTML = ... up to backtick)
    const prefixUpToBacktick = src.slice(pos, bt);
    out += prefixUpToBacktick + newLiteral;
    changed = true;
    idx = end + 1;
  }
  return { changed, out };
}

function formatFile(filePath, frontendRoot) {
  const src = fs.readFileSync(filePath, 'utf8');
  const { changed, out } = formatEmbeddedInSource(src, filePath, frontendRoot);
  if (changed) { fs.writeFileSync(filePath, out, 'utf8'); console.log('Formatted embedded HTML in', filePath); }
}

function main() {
  if (process.argv.length < 3) { console.error('Usage: format-embedded-html.js <frontend_dir>'); process.exit(2); }
  const frontendDir = process.argv[2];
  if (!fs.existsSync(frontendDir) || !fs.statSync(frontendDir).isDirectory()) { console.error('Invalid frontend dir:', frontendDir); process.exit(3); }
  const files = findFiles(frontendDir);
  for (const f of files) try { formatFile(f, frontendDir); } catch (e) { console.error('Error formatting', f, e); }
}

main();
