import { defineConfig } from "eslint/config";
import html from "@html-eslint/eslint-plugin";

export default defineConfig([
    {
        files: [
          "**/*.html"
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
]);
