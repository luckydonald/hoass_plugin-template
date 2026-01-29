module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
    project: './tsconfig.json',
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
    'vue/html-indent': ['error', 2]
  },
  overrides: [
    {
      files: ['*.vue'],
      parser: 'vue-eslint-parser',
      parserOptions: {
        parser: '@typescript-eslint/parser',
        extraFileExtensions: ['.vue']
      }
    }
  ]
};
