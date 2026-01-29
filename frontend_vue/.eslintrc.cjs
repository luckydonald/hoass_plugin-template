module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
    // Use an eslint-specific tsconfig that includes tests and config files
    project: './tsconfig.eslint.json',
    // Quiet the unsupported TypeScript version warning for now
    warnOnUnsupportedTypeScriptVersion: false,
  },
  env: {
    browser: true,
    node: true,
    es6: true,
  },
  extends: [
    'airbnb-base',
    'airbnb-typescript/base',
    'plugin:vue/vue3-recommended'
  ],
  plugins: ['@typescript-eslint', 'vue'],
  rules: {
    // Arrays: force elements on separate lines
    'array-bracket-newline': ['error', { multiline: true, minItems: 1 }],
    'array-element-newline': ['error', 'always'],

    // Objects
    'object-curly-newline': ['error', { multiline: true, consistent: true }],
    // Allow short object properties on same line to avoid noisy errors for small inline objects
    'object-property-newline': ['error', { allowAllPropertiesOnSameLine: true }],

    // Functions
    'function-call-argument-newline': ['error', 'consistent'],
    'function-paren-newline': ['error', 'multiline'],

    // Imports and commas
    'comma-dangle': ['error', 'always-multiline'],
    // Don't enforce maximum line length in this project
    'max-len': 'off',

    // Vue template rules
    'vue/max-attributes-per-line': ['error', { singleline: 1, multiline: { max: 1 } }],
    'vue/html-closing-bracket-newline': ['error', { singleline: 'never', multiline: 'always' }],
    'vue/multiline-html-element-content-newline': ['error', { ignoreWhenEmpty: true, allowEmptyLines: false }],
    'vue/singleline-html-element-content-newline': 'off',
    'vue/html-indent': ['error', 2],
    // Prefer self-closing form for void elements like <input />, <img />, <br /> to match HTML XML-style preferences
    'vue/html-self-closing': ['error', {
      'html': {
        'void': 'always',
        // Allow normal HTML elements to be self-closing (preserve `<div class="line" />`)
        'normal': 'always',
        'component': 'always'
      },
      'svg': 'always',
      'math': 'always'
    }],
    // Disable rules that auto-convert legacy `slot` attributes to `v-slot` templates
    // for custom web components (Home Assistant `ha-*` elements). These are not
    // Vue components and should keep their native `slot="..."` attribute.
    'vue/no-deprecated-slot-attribute': 'off',
    'vue/v-slot-style': 'off',

    // Project-specific relaxations to match existing code style
    // Allow underscore usage in properties and members (Home Assistant style)
    'no-underscore-dangle': 'off',
    '@typescript-eslint/naming-convention': [
      'error',
      {
        selector: 'default',
        format: ['camelCase', 'PascalCase', 'UPPER_CASE'],
        leadingUnderscore: 'forbid'
      },
      {
        // Allow object properties (including interface/type properties) to use snake_case
        selector: 'property',
        format: ['camelCase', 'snake_case', 'PascalCase', 'UPPER_CASE'],
        leadingUnderscore: 'allow'
      },
      {
        selector: 'typeProperty',
        format: ['camelCase', 'snake_case', 'PascalCase', 'UPPER_CASE'],
        leadingUnderscore: 'allow',
        filter: {
          regex: '^--[a-z0-9-]+$',
          match: true
        }
      },
      {
        // Allow object literal properties that are CSS custom properties (e.g. "--hour-background")
        selector: 'objectLiteralProperty',
        format: null,
        filter: {
          regex: '^--[a-z0-9-]+$',
          match: true
        }
      },
      // Allow leading underscore for class methods and functions (common internal helpers)
      {
        selector: 'method',
        format: ['camelCase', 'PascalCase'],
        leadingUnderscore: 'allow'
      },
      {
        selector: 'function',
        format: ['camelCase', 'PascalCase'],
        leadingUnderscore: 'allow'
      }
    ],
    'max-classes-per-file': ['error', 3],
    'class-methods-use-this': 'off',
    'no-console': 'warn',
    // Relax template-specific rules that cause noise in copied projects
    '@typescript-eslint/no-use-before-define': ['error', { 'functions': false, 'classes': true, 'variables': true }],
    'no-restricted-globals': ['error', { 'name': 'event', 'message': 'Do not use global event' }],
    'no-spaced-func': 'off', // deprecated, trouble with TS
    'default-case': 'off',

    // Allow unused vars that start with an underscore (common pattern in function args)
    '@typescript-eslint/no-unused-vars': ['error', { 'argsIgnorePattern': '^_', 'varsIgnorePattern': '^_' }]
  },
  overrides: [
    {
      files: ['*.vue'],
      parser: 'vue-eslint-parser',
      parserOptions: {
        parser: '@typescript-eslint/parser',
        extraFileExtensions: ['.vue']
      }
    },
    // Relax rules for test and config files
    {
      files: ['tests/**/*.ts', 'vite.config.ts', 'vitest.config.ts'],
      rules: {
        '@typescript-eslint/no-unused-vars': 'off',
        'import/extensions': 'off',
        'import/no-extraneous-dependencies': 'off',
        'array-bracket-newline': 'off',
        'array-element-newline': 'off',
        '@typescript-eslint/naming-convention': 'off',
        'no-multiple-empty-lines': 'off'
      }
    }
  ]
};
