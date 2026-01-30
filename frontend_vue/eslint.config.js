import airbnb from './eslint.airbnb.mjs';
import base from './eslint.base.js';
import ts from './eslint.ts.js';
import fs from 'fs';
import path from 'path';

/** @type { string[] } */
const OPTIONAL_CONFIGS = [
  'vue',
];

const optionals = await Promise.allSettled(
  OPTIONAL_CONFIGS.map(
    async (configName) => {
      try {
        return await import((`./eslint.${configName}.js`)).then(m => m.default ?? []);
      } catch {
        return [];
      }
    }
  )
);

// Read the repository root .gitignore (frontend_vue is one level deeper)
const repoGitignore = path.resolve(process.cwd(), '..', '.gitignore');
let gitignoreEntries = [];
if (fs.existsSync(repoGitignore)) {
  gitignoreEntries = fs.readFileSync(repoGitignore, 'utf8')
    .split(/\r?\n/)
    .map(l => l.trim())
    .filter(Boolean)
    // Ignore comments and negations for the flat config; keep simple patterns
    .filter(l => !l.startsWith('#') && !l.startsWith('!'))
    // Remove leading slash which is repo-root relative, flat-config expects glob-like patterns
    .map(l => l.replace(/^\//, ''));
}

export default [
  // Provide an explicit `ignores` entry so ESLint won't try to use includeIgnoreFile
  {
    ignores: gitignoreEntries,
  },
  // JavaScript/TypeScript/Vue configs
  ...airbnb,
  ...base,
  ...ts,
  ...optionals.flatMap(r => r.status === 'fulfilled' ? (r.value ?? []) : []),
];
