import { defineConfig } from "eslint/config";
import html from "@html-eslint/eslint-plugin";

export default defineConfig([
    {
        files: [
          "**/*.html",
          "**/*.js", "*/*.mjs", "*/*.cjs", "**/*.ts",
        ],
        extends: ["html/recommended"],
        plugins: {
            html,
        },
        // When using the recommended rules (or "html/all" for all rules)
        language: "html/all",
    },
]);
