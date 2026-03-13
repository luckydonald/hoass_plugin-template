# 1) FOLLOW EVERY SINGLE TIME:
Run `make commit` in the `run_in_terminal` tool after each file change (create, edit, cmds which will change files, etc...).
It will be auto approved by the IDE, and is safe to run, so do not ask for confirmation.
Really, after every single file operation!
Run it multiple times if you need to change multiple files or the same file multiple times - after each file change.
Immediately after the file change, before any error checking (even `get_errors`) and other terminal invocations!
Ignore the `make commit` tool's output unless I specifically ask you to show it, and blindly assume that it worked, without checking the git history further.
Briefly mention it when listing next steps or similar. 

Please prefer to use the `read_file` tool over `cat` etc. and `grep_search` tool instead of using the terminal there too.

# 2) Old instruction log for reference

Do something to make the deployment easier:
A single command which does:
- bump version (v0.0.0-pre11 -> v0.0.0-pre12)
- lint & format python & typescript
- build frontend (to test it builds)
- pushes to origin mane (including the tag)
Additionally:
- have a makefile with commands for the individual steps.
  - If I enter an invalid command in the makefile, I want the help, too.
- The "Warning: You have uncommitted changes" should follow gitignore
- Sync the version numbers with the tags
- it should only increment the version after it succeeded with the tests.
- Add the GH release url and the hacs install url to `View the release at:` in the script.
- Add a `make commit` script, which:
  - first commits changes to `ai/query.md` with the message `ai: updated query`
  - secondly commits changes to `ai/errors.md` with `ai: updated errors`
  - third commit all other changes with `ai: running... ($step-$substep)` (where $substep will be reset to 1 in the script, and $step incremented compared to the last commit matching that.
- So the order will be:
  - first check for all errors except formating nitpicks
  - run commit.sh
  - commit lockfiles `frontend(_vue)/{yarn.lock,package-lock.json}` and `uv.lock` (root folder, for backend) be commited separately. 
     - Commit message (use template script):  
       ```txt
       🔏 Updated package version lock for frontend.
       ```
       (or `backend`)
  - run the python formatter
  - commit those changes with `lint: ruff`
  - run the ts formatter
  - commit these changes with `lint: ts`
  - build it to confirm it working
  - only now that every test was successful:
    - increase the versions
    - add the version-changed file(s) to git
    - commit a message with "version: bumped `x` -> `y`"  (a proper unicode arrow)
    - tag the commit.
    - and finally push the commit and the tag to origin mane.
- Do not use `git add --all`. I prefer only updated over all.
- Also if there's anything staged to git, remove that, and restore it afterwards (before/for the commit rest step)
- release depends on successful lint, build.

Regarding formatting:
- I don't want prettier to ever move multiline stuff back to single line if "it fits better"! That needs to be DISABLED, or a different tool be used!
- use airbnb style for ts etc.
- Unlimited line width, but prefer one-element-per line for arrays, html attributes, function params etc.
- make sure it formats Vue files, too.
- reminder that the config key is called `"markup": { …` not `"markup_fmt"`.

——————————

bash script get own file dir

——————————

```
🔍 Step 1: Check for lint errors
Running ruff check...
… ruff error output …
Found 1 error. [*] 1 fixable with the `--fix` option. make: *** [release] Error 1
```

Also insert a step where the linter has only fixable errors, so it commits the file before, then does an "autofix" commit afterwards - similar to the format ones.

The interesting part is, the first step already fails if it has those fixable issues - they are at that point still considered issues.

——————————

fatal: tag 'v0.0.0-pre19' already exists
Ask to move the tag (delete the old one and recreate as intended)

——————————

➜ make commit
Script directory: /Users/user/Documents/programming/Python/HomeAssistant/hoass_calendar-alarm-clock/scripts
📝 Calendar Alarm Clock - Commit Script

Saving staged changes...
Saved working directory and index state On mane: commit-script-staged-backup
error: removal patch leaves file contents
error: ai/debugging-auto-discovery.md: patch does not apply
Cannot remove worktree changes
make: *** [commit] Error 1

But using `git reset HEAD` sounds like it could delete stuff we still need?
——————————

in the scripts/ folder, write me a script which would replace this template with a homeassistant plugin name.
Ask for a plugin name (e.g. "Calendar Alarm Clock") as input.
This is for names displayed in the UI.

calculate a lowercase-dash version, (i.e. "calendar-alarm-clock") which would be the default, but again ask the user.
This is for custom component names and filenames (i.e. `<calendar-alarm-clock-card>`, `calendar-alarm-clock-card.js` and `calendar-alarm-clock-editor.css`)

Then also convert that to real snake_case ("calendar_alarm_clock"); again as default and the possibility to change it for the user.
This will be for module names on the python side, integration domain and sensor names, etc.

Using the dashed-lowercase, construct the github repo `https://github.com/luckydonald/hoass_calendar-alarm-clock.git`, to input in plenty of files.

Then ask if we need a python backend, if not, remove the related files.

After that, ask for a frontend choice, either `vue` or `plain`, for which either the `frontend_vue` or `frontend_plain` folder is kept, and renamed as `frontend`.

Finally, (but do not add that yet!): 
the script shall replace all `template`, `Template` etc. with the given strings.
For that it shall go through a hardcoded list of files and replace the relevant parts. (this is because `template` might be a too common word in homeassistant.)

—————

please - in my local files - rename "template" to "plugin_template" (in all the cases needed. Also rename calendar_alarm_clock to plugin_template and all the other caseings similarly in the files directly, and adapt the script for that, so it's uniformly something which is easier to recognize.

Please additionally also remove code which might have been specific to the one I compied from - I only want a good starting point, so remove everything alarm-clock or calendar specific.

———————

Set up tests for the frontend and backend, with a few example tests.

————————

In `scripts/init.sh`, make sure everything is properly replaced, including in the test files.

The script also should be save to re-run, even with a later version with updated files.
It should not fail, but just adapt new files as needed.
This is extra important for the folder copy/rename parts, we can't just overwrite existing folders.
Instead, if that folder already exists, ask for each non-existing file if it should be copied over and adapted or skipped.

———————

Add `make init`.

———————

In the `scripts/init.sh`:
- Try to deduct the name from the current folder name as default.
  - obviously, strip common prefixes like `ha_`, `hacs_`, `hoass_`, `homeassistant_` if existing.
- after asking for the plugin name etc., also ask for a github username (defaulting to "luckydonald"), and use that in the constructed github repo url.

———————

I want to make the `commit.sh` script intelligent for the commit message ai-run-number increase:
- Go back the commit messages, and if you find one matching `ai: running... ($step-$substep)`, use that to determine the current $substep. If you however first find a ai: updated query or ai: updated errors, reset the substep counter to 1, and increase the step counter by one instead.
- If no previous ai: running... commit is found, start with (1-1).

Additionally, detect if the commit script is run in the template repository (root dir name is `hoass_{plugin-,plugin_,}template/`.
If that is the case, the commit syntax is different:
Instead of `$COMMIT_MSG_STEP`, resulting in `ai: running... (7-2)`, use "📄TEMPLATE | ✨ ai: [007] Message here… (2/X)", from the following:
```shell
COMMIT_MSG_STEP="✨ ai: running... ({step}-{substep})"
COMMIT_MSG_STEP_TEMPLATE="${COMMIT_PREFIX_TEMPLATE}✨ ai: [{padded_step}] {msg} ({substep}-{total_substeps})"
```
Notice, the first part is `${COMMIT_PREFIX_TEMPLATE}`, the $step is now named $padded_step and zero-padded to three digits, and the substep is 2. The total_substeps will initially be "X", as it is currently unknown what the total number of substeps will be.
If the template repo is detected, the search for the previous substep as above must be adapted to the new syntax as well.
Keep in mind, that the message is not always "running...", but will later be changed with an rebase to something more useful. The detection must work with that. Also I use `…`, not three separate dots.

——————

Write me a `scripts/fix-commits.sh` (incl. `make fix-commits`), which will rebase the last set of `📄TEMPLATE | ✨ ai: [013] running… (2/X)` or `✨ ai: running… (2-X)`.
In the case with the total, it should replace the X on that correct position with the total for that batch (here 013), and for both formats also ask what to change the message to, if it's still the default the script put down.

——————

Make sure `init.sh` cleans up template-specific stuff, like the `ai/plugin_template/` dir or unused `frontend_*` folders.

——————

Have the script first check for uncommited changes, and allow to commit before continuing, with a user specified message.

Make it add all new files (and deleted/moved ones) to git.
At the end, ask if it should do a commit with the changed files.
Template for the commit message header:
```txt
🛫 template | Applied plugin template with `init.sh`

{configuration details here}
```
In that, include the configuration summary from the beginning once more, and any other relevant information (e.g. if a backend was included or not, frontend type, etc.)

——————

Have `fix-commits` display the diff for the detected query/error change, before asking for the message. Also, remove the "you wanna continue", as one can just `^C` the message field.

——————

Do not have the diff it go to a pager, unless some kind of env var is set or something.

Also on start of the script make sure the head is not in a detached state or git already in a rebase, merge, whatever.

——————

In `init.sh`, Step 7: Frontend Framework:

```txt
Choose your frontend framework:
  vue   - Vue.js framework (from frontend_vue/)
```
Please prepare a commented-out 
```
plain - Plain Typescript (from frontend_plain/)
```
text and code,
also add a "none" option to skip frontend setup entirely.

————

While already editing the commit messages in `fix-commits.sh`, edit the query/error message too, appending a colon, space, and the user entered message there as well.
Make sure to not drop commits in-between.

————

Update `fix-commits.sh` to further detect commit steps which do not touch the same lines and could be squashed to one, present those findings to the users, and ask him if we should squash.
The sub-numbering should be adapted while merging commits.
Note, actually check that the lines in the files do not overlap, but if they don't they can be merged. The files themselves can be merged into a single commit, if it's at different places.

————

Update `init.sh` to, in the summary, write:
```diff
- Python Backend:   true
+ Python Backend:   yes
- Frontend:         vue
+ Frontend:         yes, vue
```

————

When rebasing, tag the current HEAD with a tag to allow easy recovery. (something containing the $step?) Use a templating var so I can easily change the tag name. After being successful check for tags no longer in the main branch but NOT the current one, and clean those up (with confirmation)

————

`Delete the recovery tag for this rebase? (y/n) [y]: y` should default to no/`n`.

———

Actually, I like the format of the template commits.
Use that for the end-user commits as well.
Put the TEMPLATE prefix to the echo statement, instead of the template-string itself. Can be a replacer or string concat, whichever is easier.

———

I've added `.github` (from `../../../hoass_calendar-alarm-clock/.github`) to the template repo.
Make sure `init.sh` copies that over as well, and that plugin names are replaced with our placeholders, "plugin-template" or similar.

———

Do not make merging commits the default option.

———

In `init.sh`, combine the sed commands which are shared between `$REPLACE_AUTHORS` and not, to reduce code duplication.

———

In `scripts/fix-commits.sh`, make sure to only rename and/or squash connected blocks of commits, i.e. those with the same $step number. If an query/error update or a different $step number is found in-between, stop there.
Also make sure that it is also displaying only those correctly in `print_info "Updated commits:"`

———

Also make sure the `init.sh` script handles `README_PROJECT_TEMPLATE.md`. For that the current `README.md` shall be renamed to  `README_REPO_TEMPLATE.md`, and the `README_PROJECT_TEMPLATE.md` shall take its place, with the necessary string replacements.
Make sure it's re-run-safe.
That means not overwriting a already replaced `README.md`
You shall name it to `README_GENERATED.md` instead of overwriting.
It should:
- check if there's `README_PROJECT_TEMPLATE.md`
- and check if `README.md` mentions `init.sh` (then it's the template one)
- and check if `README.md` does not contain any replacements calculated (e.g. the new plugin name; just to be extra safe)
If all those conditions are met:
- rename `README.md` to `README_REPO_TEMPLATE.md` (overwrite if already existing)
- copy `README_PROJECT_TEMPLATE.md` to `README.md`
- do the replacements in `README.md`
For readability, refactor the `Setting up README files...` in a function, and reorder the `if`s to have a early-return approch instead of nesting those `if`s.
No need to delete `scripts/README_PROJECT_TEMPLATE.md`.

———

Hacs and Hassfest recommends to have the workflow run on `push`, on `pull_request` and on a schedule (weekly is fine).

———

Have `init.sh` fix `2026` to the current year. Replace `2026-2\d{3}`, too. As always, whitelist files.

———

Have the `init.py` delete the `uv.lock` when it is also allowed to completely insert the backend code (but not on later runs)
Similar, for the choosen frontend, `frontend_*/`: both yarn and npm lock files.

———

Write me a new script, `[update-from-template.sh](../../scripts/update-from-template.sh)` which does 
- `git fetch ${TEMPLATE_REMOTE}`
  - TEMPLATE_REMOTE needs to be detected:
    - if the remote named `template`, `template-origin`, `template-local`, `template-online` or `template-github` exists, use that
    - else, check the url, if it matches `github.com/luckydonald/hoass_{plugin-,plugin_,}template.git` (with or without .git), and if so, use that remote
    - else, use any remote matching `\btemplate\b` in its name
    - else, ask the user to choose from the list of remotes, 
      - with an extra option to add new remote url, `template`, pointing to `https://github.com/luckydonald/hoass_plugin-template`.
- tag the current HEAD with a recovery tag
  - template variable again, use the template script.
  - use the name `template-rebase-backup_YYYY-MM-DD-HH-MM-SS`
- rebase current branch onto `mane`.
- if there are conflicts
  - but it can be auto-resolved, do so, and continue the rebase
  - else, if it is a conflict where the local version (ours) got just deleted, keep it deleted (accepting ours)
  - otherwise, stop and ask the user to resolve manually, displaying the important commands. Also hint about jetbrains IDEs having a git rebase conflict resolver.
  - Note, the script should be able to continue after manual resolution of that commit.
  - Automatically edit the commit message to replace the `#` at the beginning of lines (commented out) with an escaped `\#` so that that additional rebase information is preserved.
- at the end, display a summary of what files were changed during the rebase.
- add it to the makefile, too, `make rebase-template` (with `template-rebase` alias)
- When auto-accepting (and editing) rebase conflict commit messages, add a line at the with details about when the rebase happened, and from which commit to which commit.

———
Have `init.sh` write the project settings to `scripts/init.json`.
Then modify `release.sh` to read that file, and use the name instead of `plugin_template`.
Actually, write that to a separate script, `get_project_settings.py`, which can be used in any of those scripts to get the json data as variables.
So basically, read the file, if it is missing, error out, with a hint to run `init.sh` / `make init` first.
Additionally, `init.sh` shall read the file at the beginning, and if existing, pre-fill the prompts with the existing values, instead of the computed folder-based defaults.
———
I want to add the airbnb style for my typescript and in the TS in the vue components.
Also HTML attributes should be on separate lines, in witch case also and tag start and end would be on their own line. Also the content would be on it's own line too.

Make sure that the formatter DOES NOT colapse multiline stuff back into a single line once it's deemed short enough, both for ts arrays, imports, argument lists, ... and vue html stuff.
The idea is to have as minimal diffs as possible when changing stuff. It may expand stuff to multiple lines, but never collapse it back.

Please configure `eslint` with the required plugins and settings. Check on NPM for the latest version of each. I do not desire to use prettier.
Please do integrate it into `Makefile` and the [`release.sh`](../../scripts/release.sh)` deploy script.
Running `make format-ts` should contain the `--fix` one as well, just like `format-py` also builds upon `lint-py` with `--fix`.

Edit my linting/formatting of TS/Vue to be:
- Pragmatic (my recommended default): keep Airbnb as the baseline and keep the targeted, minimal exceptions you already have (no-underscore-dangle allowAfterThis/allowAfterSuper, property/typeProperty snake_case).
- Simply ignore the TS version conflict for now.
- I want husky commit, but it should keep the previous commit too. 
  1. So do normal commit,
  2. see if we would need to reformat,
  3. if yes continue like this
  4. tag that `format-backup_YYYY-DD-MM_NNN` (NNN = padded counter)
  5. auto-format
  6. amend the last commit with the result (hence the tag earlier, as now we branched that off)

This should for now (to test) be an extra script, accessible with `make commit-format`

———

Duplicate and adapt the `make template-rebase` to a `make template-merge` command, which instead of rebasing merges the template's mane branch into the current branch. It should have the same conflict resolution strategies and automatics as the rebase one.
———
Okay, we need to work on the `eslint --fix` rules:
1. `<ha-button slot="secondaryAction">`
   - this gets replaced with `<ha-button><template #secondaryAction">`
   - I believe this is incorrect for `ha-*` as they are not vue, but web components.
2. `ha-entity-picker`: `:includeDomains="['sensor']"`
   - this gets replaced with
   - `:includeDomains="['sensor']"`
   - would that work with `ha-*` web components?
3. I prefer `<input />` instead of unclosed `<input>`.
4. similarly for `<img />` and `<br />`, if that's a thing in the rulesets.
   - Make sure that It will not convert `<div class="line" />` back to `<div class="line"></div>`, I want the self-closing syntax for those.
5. the line  
    ```ts
    const emit = defineEmits<{
      (e: 'update:modelValue', v: string): void;
    }>();
    ```
    becomes
    ```ts
    const emit = defineEmits<{ (e: 'update:modelValue', v: string): void;
    }>();
    ```
    - it should not collapse it to a single-ish line, but keep each element on its own line.
    - can we make that specific to only be off for `ha-*`?
    - Also merge that `check-slots` into the lint, fix and release scripts accordingly.
6. Object Literal Property name `--hour-background` must match one of the following formats: camelCase, snake_case, PascalCase, UPPER_CASE
  - `@typescript-eslint/naming-convention`
  - This is for CSS variable names, so we need to allow `kebab-case` with that `--` prefix
7. Do not enforce a max line length (`max-len`).
- For running those tests you must navigate to `../hoass_calendar-alarm-clock` first, that's the actual templated plugin where I am facing the issues in.
  - I merged the newest version of this template into that directory- So you can test now. I only meant you to run the tests there, then edit here, and then let me merge it, I will talk to you again afterwards.
  - In most regards that dir should be our templated result, so `frontend_vue` became `frontend`, otherwise it's pretty much having our tooling.
———
  - For the fix commit script which renames the commits, add a startup parameter `--start-commit <commit>` which will only consider commits after that commit (including that commit).
  - Add a `--end-commit <commit>` which will only consider commits up to that commit (including that commit).
  - Also add `--ignore-blocks` where it will consider commits separated by other commit messages, and also renames those, if they match the criteria.
  - And add a `--number-search` which will search for the step number in the commit message, and only consider those with the same step number as the valid commit, ignoring other step numbers, but per default still adhering to blocks. This can be a list `10, 11, 23`. Allow to enter ranges like `55, 58-69`, too.
    - This needs to work without `--ignore-blocks` as well, so that one can e.g. fix step 10 to step 12 commits in one go, even with the numbers being different (but listed in the `--number-search` list)
  - Finally `--number-override <number>` which will use that number when editing the commit messages, instead of the detected one.
  - Have the Makefile append the arguments when `make commit-fix`.
  - Add `--dry-run`.
  - Delay the dry run until after the message input (which will be headlined with a red dry run reminder), so that the messages can be properly calculated, and the real rebase operations are displayed.
  - Add `--interactive` which will ask for user input for each of those flags/params. The default for those is `n`/omit upon pressing enter without input.
    - After the `--interactive` mode prompts, display a calculated command for the user input.
  - Add a `--message` / `-m` parameter to have a default message.
    - Before the _"Checking for old recovery tags to clean up..."_ message, print the "final" command as well (regardless of interactive mode), including the detected number and the typed message, to give the user a way to repeat it.
  - Make the final "Updated commits:" output strictly limited to the commits we modified (rather than grepping by ai step)
  - `make fix-commits -- --number-search 81` shall also be possible via 
    - `make fix-commits -- 81`
    - `make fix-commits -- -n 81`
    - `make fix-commits 81`
    - (`make commit-fix`)
  - Repeated edits with `make fix-commits` should not repeatedly append to error/query.md. Instead replace the previous message (after the `:` colon).
  - Make the dry run actually also show that command summary.

———
Regarding [env.d.ts](../../frontend_vue/src/env.d.ts): Also export those `ha-*`  things from `HTMLElementTagNameMap` (e.g. ha-select) as HASelectElement etc. Probably define them first (there or types.ts, or a file on it's own, what's better), and use them in HTMLElementTagNameMap
———
Write/ modify a github pipeline, which would keep a compatibility table in the README.md.

The table shall be added at the end, if not found. Regex:
```py
r"^\s*\|?\s*Min\.\sHomeassistant\s*\|\s*Max.\s*`\w+`\s*$"
```
Basically, adding (duplicating) a new table row on top once the homeassistant version in hacs.json is bumped,
And upgrading the card_mod version of the first row on normal releases.
For the first release, assume current versions.


Min. Homeassistant | Max. `plugin_template`
-- | --
[2026.2.0](https://www.home-assistant.io/blog/2026/02/04/release-20262/) | [4.2.0](https://github.com/luckydonald/hoass_plugin_template/releases/tag/v4.2.0)
[2026.1.0](https://www.home-assistant.io/blog/2026/01/07/release-20261/) | [4.1.0](https://github.com/luckydonald/hoass_plugin_templat/releases/tag/v4.1.0)
———
/init
———
❯ having a claude.md in root is problematic for the actual project merging this in. Any ideas   
  how to best solve this - having claude pick this up here but not in projects where I merge    
  this into?
❯ Implement option A, having a replacer like the `README.md`. For option B, `.gitattributes`,   
  this would mean that changes (improvements) to the template would no longer merge into the    
  created project?
———
❯ Fix the ai commit script currently picking up template repo commits when it also finds non-template commits/config. Also it must abort going     
deeper when it encounters a merge commit, to make sure to not accidentially rebase a merge, which will be a headache.
———
