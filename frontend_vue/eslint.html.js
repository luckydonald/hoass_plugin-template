import { defineConfig } from "eslint/config";
import html from "@html-eslint/eslint-plugin";

export default defineConfig([
    {
        files: [
          "**/*.html",
          "**/*.js", "*/*.mjs", "*/*.cjs", "**/*.ts",
        ],
        // When using the recommended rules (or "html/all" for all rules)
        extends: ["html/recommended"],
        language: "html/html",
        plugins: {
            html,
        },
    },
]);
