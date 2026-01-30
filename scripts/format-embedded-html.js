#!/usr/bin/env node
/*
 Format HTML inside template literals assigned to `.innerHTML` using dprint.
 Usage: node scripts/format-embedded-html.js <file...>

 Behavior:
 - Looks for patterns like: something.innerHTML = `...`;
 - Skips template literals that contain `${` (interpolations).
 - Extracts inner HTML, writes to a temp .html file, runs dprint on it (using frontend_vue/dprint.json when formatting frontend files), reads back formatted HTML and replaces the template literal content, preserving indentation.
*/

import fs from 'fs';
import path from 'path';
import os from 'os';
import child_process from 'child_process';

function run(cmd, args, opts={}){
  return child_process.spawnSync(cmd, args, { encoding: 'utf8', stdio: 'inherit', ...opts });
}

function formatHtmlWithDprint(html, cwd){
  // write to temp file
  const tmpdir = fs.mkdtempSync(path.join(os.tmpdir(), 'dprint-'));
  const tmpfile = path.join(tmpdir, 'snippet.html');
  fs.writeFileSync(tmpfile, html, 'utf8');
  // run dprint fmt --apply --config if exists
  const dprintBin = path.join(cwd, 'node_modules', '.bin', 'dprint');
  if (!fs.existsSync(dprintBin)) {
    throw new Error('dprint not found at ' + dprintBin + '. Run yarn install in ' + cwd);
  }
  const res = child_process.spawnSync(dprintBin, ['fmt', tmpfile], { encoding: 'utf8', cwd });
  if (res.error) throw res.error;
  if (res.status !== 0) {
    throw new Error('dprint failed: ' + res.stderr);
  }
  const out = fs.readFileSync(tmpfile, 'utf8');
  // cleanup
  try { fs.unlinkSync(tmpfile); fs.rmdirSync(tmpdir); } catch(e){}
  return out;
}

function processFile(file){
  const abs = path.resolve(file);
  const src = fs.readFileSync(abs, 'utf8');
  // Regex to find .innerHTML = `...` including multiline; lazy match
  const re = /(\.innerHTML\s*=\s*)`([\s\S]*?)`/g;
  let m; let changed = false;
  let out = src;
  while ((m = re.exec(src)) !== null){
    const fullMatch = m[0];
    const prefix = m[1];
    const content = m[2];
    if (content.includes('${')){
      // skip interpolated templates
      continue;
    }
    // Determine indentation: look backwards from match.index for line start
    const matchIndex = m.index;
    const before = src.slice(0, matchIndex);
    const lastLineBreak = before.lastIndexOf('\n');
    const indent = lastLineBreak === -1 ? '' : before.slice(lastLineBreak+1).match(/^[ \t]*/)[0];
    // Trim leading/trailing blank lines
    let inner = content;
    // remove a leading newline if present (common pattern)
    if (inner.startsWith('\n')) inner = inner.replace(/^\n+/, '');
    if (inner.endsWith('\n')) inner = inner.replace(/\n+$/, '\n');

    // Format using dprint; choose cwd based on whether file is in frontend_vue
    const cwd = abs.includes(path.join('frontend_vue', '')) || abs.includes(path.sep + 'frontend_vue' + path.sep)
      ? path.resolve('frontend_vue')
      : process.cwd();
    let formatted;
    try {
      formatted = formatHtmlWithDprint(inner, cwd);
    } catch (e){
      console.error('dprint formatting failed for', file, e.message);
      continue;
    }
    // Ensure formatted has trailing newline trimmed similarly
    if (formatted.startsWith('\n')) formatted = formatted.replace(/^\n+/, '');
    if (formatted.endsWith('\n')) formatted = formatted.replace(/\n+$/, '\n');

    // Re-indent formatted lines with indent + two spaces (template literal indentation)
    const formattedLines = formatted.split('\n');
    const indented = formattedLines.map((line, idx) => (idx===0 ? '      ' + line : '      ' + line)).join('\n');
    // Build replacement template literal content with same backticks
    const replacement = `${prefix}
\
\\`${indented}\n      \``; // this is messy; we'll instead compute replacement from original

    // Simpler: replace the original content between backticks preserving surrounding.
    const beforeMatch = out.slice(0, m.index);
    const afterMatch = out.slice(m.index + fullMatch.length);
    const newTemplate = `${prefix}
${indent}\\`${formatted}\n${indent}      \``; // we'll reconstruct with backticks but need proper escaping

    // Construct a safe replacement using backticks directly
    const newLiteral = `${prefix}\
${indent}\\`${formatted}\n${indent}      \``;

    // But direct backticks in JS string are fine; we'll do simple replacement on out using indices
    const start = m.index;
    const end = m.index + fullMatch.length;
    const newBlock = `${prefix}
${indent}
\\`${formatted}\n${indent}      \``.replace(/\\\\/g, '\\');

    // Instead of complicated escapes, do straightforward: find the exact substring and replace content between first ` and the closing `
    const startBacktickIndex = out.indexOf('`', m.index);
    if (startBacktickIndex === -1) continue;
    // find matching closing backtick after startBacktickIndex; naive approach: search for ` not preceded by \`
    let i = startBacktickIndex + 1; let found = -1;
    while (i < out.length){
      if (out[i] === '`'){
        // count backslashes before
        let bs = 0; let j = i-1; while (j>=0 && out[j] === '\\'){ bs++; j--; }
        if (bs % 2 === 0){ found = i; break; }
      }
      i++;
    }
    if (found === -1) continue;
    const beforePart = out.slice(0, startBacktickIndex+1);
    const afterPart = out.slice(found);
    // Prepare insertion: ensure formatted is indented like surrounding template
    // We'll compute minimal indent (existing code used 6 spaces); preserve 6 spaces indentation
    const indentedFormatted = formatted.split('\n').map((line,idx)=> idx===0? '\n      '+line : '\n      '+line).join('') + '\n    ';
    out = beforePart + indentedFormatted + afterPart;
    changed = true;
  }
  if (changed){
    fs.writeFileSync(abs, out, 'utf8');
    console.log('Formatted embedded HTML in', file);
  } else {
    console.log('No embedded HTML formatted in', file);
  }
}

if (process.argv.length <= 2){
  console.error('Usage: node scripts/format-embedded-html.js <file...>');
  process.exit(1);
}
for (let i=2;i<process.argv.length;i++){
  processFile(process.argv[i]);
}
