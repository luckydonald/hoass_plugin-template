import path from 'node:path';
import { fileURLToPath } from 'node:url';
import tsParser from '@typescript-eslint/parser';
import vueParser from 'vue-eslint-parser';

// Resolve __dirname for this ESM module
const __dirname = path.dirname(fileURLToPath(import.meta.url));

const tsParserOptions = {
  project: [path.resolve(__dirname, 'tsconfig.eslint.json')],
  tsconfigRootDir: path.resolve(__dirname),
};

export default [
  // Ensure TypeScript files are parsed with type information
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser: tsParser,
      parserOptions: tsParserOptions,
    },
  },
  // Ensure Vue SFC script blocks are parsed by the TypeScript parser
  {
    files: ['**/*.vue'],
    languageOptions: {
      parser: vueParser,
      parserOptions: {
        parser: tsParser,
        ...tsParserOptions,
      },
    },
  },
];
