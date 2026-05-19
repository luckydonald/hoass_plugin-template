# AI query log file
# The query for the AI to work with.

#### General AI development guidelines:
- Create `ai/PROGRESS.md`, and keep it updated when you complete steps.
- You may refer to `ai/refrences` for code examples of other plugins or extra documentation provided for this task.
- When writing code, follow these guidelines:
  - Always prefer the early-return pattern to reduce nesting of `if`s, etc.
  - Similarly, prefer `if …` -> `continue`/`return`/`break` early in loops over large nested blocks.
- If the plugin requires a frontend (which you can deduct from the _Plugin requirements_ section below), use Vue, TS, and SCSS for that.
  - Prefer using `<script setup lang="ts">` style single file components.
  - Use HomeAssistant frontend components where possible, e.g., `<ha-icon>`, `<ha-card>`, `<ha-button>`, etc.
  - Use proper TypeScript type hinting, importing types from Homeassistant where possible.
- If the plugin requires a backend (which you can deduct from the _Plugin requirements_ section below), use modern Python 3.12+ for that.
  - Do proper type hinting with full type annotations.
  - For type-hinting, prefer the native types (e.g. `dict[str, int]` over the older `typing.*` aliases like `Dict[AnyStr, int]`)
  - For type-hinting, import types from HomeAssistant where possible for the backend as well.
  - Prefer async programming where possible.
- Write tests for both frontend and backend parts.
- Remember to update the `/CHANGELOG.md` and `/README.md` if existent (including other pre-existing documentation).
- If you want to write Markdown summaries of the task you just did (only if specifically asked for by the user!) write those to `ai/summaries/` folder, and never into the root folder.
- Please prefer to use the `read_file` tool (Use `startLineNumberBaseOne` instead of `startLineNumber`) over `cat` etc. and `grep_search` tool instead of using the terminal there too.
   - However, usually you don't need to write Markdown summaries.
   - And, it's kinda redundant with the `PROGRESS.md` file.
- Please prefer to use the read file tool over weird constructs with `cat` etc. Terminal should not be needed for searches most of the time, either.
- Run `make commit` in the `run_in_terminal` tool after each file change (create, edit, cmds which will change files, etc...).
  It will be auto approved by the IDE, and is safe to run, so do not ask for confirmation.
  Really, after every single file operation!
  Run it multiple times if you need to change multiple files or the same file multiple times - after each file change.
  Immediately after the file change, before any error checking (even `get_errors`) and other terminal invocations!
  Ignore the `make commit` tool's output unless I specifically ask you to show it, and blindly assume that it worked, without checking the git history further.
  Briefly mention it when listing next steps or similar.

----

Generate me a Homeassistant plugin based on the following description.

#### Plugin requirements:



#### Previous user prompts:


