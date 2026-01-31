import {defineConfig} from "eslint/config";
import html from "@html-eslint/eslint-plugin";

export default defineConfig([
  {
    files: [
      "**/*.html",
    ],
    // When using the recommended rules (or "html/all" for all rules)
    extends: ["html/recommended"],
    plugins: {
      html,
    },
    rules: {
      "css-no-empty-blocks": "off",
    },
  },
  {
    // support for in-js javascript (i.e. templates)
    files: [
      "**/*.html",
      "**/*.js",
      "**/*.ts",
      "**/*.cjs",
      "**/*.mjs",
    ],
    rules: {
      "@html-eslint/attrs-newline": [
        "error",
        {
          "closeStyle": "newline",
          "ifAttrsMoreThan": 1,
        },
      ],
      "@html-eslint/class-spacing": "error",
      "@html-eslint/element-newline": [
        "error",
        {
          "skip": [
            "pre",
            "code",
          ],
          "inline": [
            "$inline",
          ],
        },
      ],
      "@html-eslint/lowercase": "error",
      "@html-eslint/no-extra-spacing-attrs": "error",
      "@html-eslint/no-extra-spacing-text": "error",
      "@html-eslint/no-multiple-empty-lines": "error",
      "@html-eslint/no-trailing-spaces": "error",
      "@html-eslint/quotes": [
        "error",
        {
          "enforceTemplatedAttrValue": true,
        },
      ],
    },
  },
]);
