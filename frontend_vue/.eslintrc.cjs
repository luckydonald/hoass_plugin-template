module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
    // Use an eslint-specific tsconfig that includes tests and config files
    project: './tsconfig.eslint.json',
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
    'object-property-newline': ['error', { allowAllPropertiesOnSameLine: false }],

    // Functions
    'function-call-argument-newline': ['error', 'consistent'],
    'function-paren-newline': ['error', 'multiline'],

    // Imports and commas
    'comma-dangle': ['error', 'always-multiline'],

    // Vue template rules
    'vue/max-attributes-per-line': ['error', { singleline: 1, multiline: { max: 1 } }],
    'vue/html-closing-bracket-newline': ['error', { singleline: 'never', multiline: 'always' }],
    'vue/multiline-html-element-content-newline': ['error', { ignoreWhenEmpty: true, allowEmptyLines: false }],
    'vue/singleline-html-element-content-newline': 'off',
    'vue/html-indent': ['error', 2],

    // Project-specific relaxations to match existing code style
    // Allow underscores in identifiers (we use _private style in this project)
    'no-underscore-dangle': 'off',
    '@typescript-eslint/naming-convention': [
      'error',
      {
        'selector': 'default',
        'format': ['camelCase', 'PascalCase', 'UPPER_CASE'],
        'leadingUnderscore': 'allow'
      }
    ],
    'max-classes-per-file': ['error', 3],
    'class-methods-use-this': 'off',
    'no-console': 'warn',

    // Allow unused vars that start with an underscore (common pattern)
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
