It is missing the prefix, and also the detection of the query part (and hence the first number incrementing) failed.

```shell
➜ git log --pretty=format:"%s" -12
📄TEMPLATE | Did some cleanup and minor fixes.
✨ ai: [007] running... (3/X)
✨ ai: [007] running... (3/X)
✨ ai: [007] running... (3/X)
✨ ai: [007] running... (3/X)
📄TEMPLATE | 🤌 ai: updated query
📄TEMPLATE | Manually changed stuff after AI messed it up, lol.
📄TEMPLATE | ✨ ai: [007] Add `make init`… (2/2)
📄TEMPLATE | ✨ ai: [007] Add `make init`… (1/2)
📄TEMPLATE | 🤌 ai: updated query
📄TEMPLATE | ✨ ai: [006] Add `make init`… (6/6)
📄TEMPLATE | ✨ ai: [006] Add `make init`… (5/6)
…
```

——————

```shell
./scripts/commit.sh: line 192: syntax error near unexpected token `elif'
``` 

—————

./scripts/fix-commits.sh:
- It should ask only once for the same $step aka. $padded_step
- Also the total is not adapted, and the message is not changed, but prefixed with " Current commit: " now?!?

Full log:

```shell
➜ make fix-commits

===================================================
Fix AI Commit Messages
===================================================

ℹ Template repository detected
ℹ Scanning for AI commit batches...
ℹ Found AI commits for step [014]
✓ Found 5 commit(s) in this batch

Commits to fix:
7d92793 📄TEMPLATE | ✨ ai: [014] running… (1/X)
9e55091 📄TEMPLATE | ✨ ai: [014] running… (2/X)
0fa2f84 📄TEMPLATE | ✨ ai: [014] running… (3/X)
c534083 (origin/mane) 📄TEMPLATE | ✨ ai: [014] running… (4/X)
d03fafa (HEAD -> mane) 📄TEMPLATE | ✨ ai: [014] running… (5/X)

Proceed with fixing these commits? (y/n) [y]: y
ℹ Starting interactive rebase...
⚠ You'll be prompted for each commit with a default message

Executing: /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.r9ZqiAtjfo '📄TEMPLATE | ✨ ai: [014] running… (1/X)' > /tmp/new_msg_52894.txt
Enter new message (or press Enter to keep 'running…'): Write `fix-commits.sh` to fix message and total…
Executing: git commit --amend -m "$(cat /tmp/new_msg_52894.txt)" && rm /tmp/new_msg_52894.txt
Warning: commit message did not conform to UTF-8.
You may want to amend it after fixing the message, or set the config
variable i18n.commitEncoding to the encoding your project uses.
[detached HEAD 61de79e] Current commit: 📄TEMPLATE | ✨ ai: [014] running… (1/X)
 Date: Sat Jan 17 23:42:31 2026 +0100
 1 file changed, 289 insertions(+)
 create mode 100644 scripts/fix-commits.sh
Executing: /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.r9ZqiAtjfo '📄TEMPLATE | ✨ ai: [014] running… (2/X)' > /tmp/new_msg_52894.txt
Enter new message (or press Enter to keep 'running…'): Write `fix-commits.sh` to fix message and total…
Executing: git commit --amend -m "$(cat /tmp/new_msg_52894.txt)" && rm /tmp/new_msg_52894.txt
[detached HEAD f86103f] Current commit: 📄TEMPLATE | ✨ ai: [014] running… (2/X)
 Date: Sat Jan 17 23:42:39 2026 +0100
 1 file changed, 6 insertions(+), 1 deletion(-)
Executing: /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.r9ZqiAtjfo '📄TEMPLATE | ✨ ai: [014] running… (3/X)' > /tmp/new_msg_52894.txt
Enter new message (or press Enter to keep 'running…'): Write `fix-commits.sh` to fix message and total…
Executing: git commit --amend -m "$(cat /tmp/new_msg_52894.txt)" && rm /tmp/new_msg_52894.txt
[detached HEAD 66c602e] Current commit: 📄TEMPLATE | ✨ ai: [014] running… (3/X)
 Date: Sat Jan 17 23:43:28 2026 +0100
 1 file changed, 423 insertions(+)
 create mode 100644 FIX_COMMITS_GUIDE.md
Executing: /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.r9ZqiAtjfo '📄TEMPLATE | ✨ ai: [014] running… (4/X)' > /tmp/new_msg_52894.txt
Enter new message (or press Enter to keep 'running…'): Write `fix-commits.sh` to fix message and total…
Executing: git commit --amend -m "$(cat /tmp/new_msg_52894.txt)" && rm /tmp/new_msg_52894.txt
[detached HEAD dac07f4] Current commit: 📄TEMPLATE | ✨ ai: [014] running… (4/X)
 Date: Sat Jan 17 23:44:04 2026 +0100
 1 file changed, 247 insertions(+)
 create mode 100644 FIX_COMMITS_COMPLETE.md
Executing: /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.r9ZqiAtjfo '📄TEMPLATE | ✨ ai: [014] running… (5/X)' > /tmp/new_msg_52894.txt
Enter new message (or press Enter to keep 'running…'): Write `fix-commits.sh` to fix message and total…
Executing: git commit --amend -m "$(cat /tmp/new_msg_52894.txt)" && rm /tmp/new_msg_52894.txt
[detached HEAD 9637af9] Current commit: 📄TEMPLATE | ✨ ai: [014] running… (5/X)
 Date: Sat Jan 17 23:49:02 2026 +0100
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 scripts/fix-commits.sh
Successfully rebased and updated refs/heads/mane.
✓ Rebase completed successfully!

ℹ Updated commits:
61de79e Current commit: 📄TEMPLATE | ✨ ai: [014] running… (1/X)
f86103f Current commit: 📄TEMPLATE | ✨ ai: [014] running… (2/X)
66c602e Current commit: 📄TEMPLATE | ✨ ai: [014] running… (3/X)
dac07f4 Current commit: 📄TEMPLATE | ✨ ai: [014] running… (4/X)
9637af9 (HEAD -> mane) Current commit: 📄TEMPLATE | ✨ ai: [014] running… (5/X)

✓ All done! Commits have been fixed.
```

—————

init.sh:

```txt
ℹ The following replacements will be made:
  'template'        → 'state_cycler'
  'Template'        → 'StateCycler'
  'TEMPLATE'        → 'STATE_CYCLER'
  'plugin-template' → 'state-cycler'
  'Plugin template' → 'State Cycler'
```
Replacing just the word "template" is way to dangerous! It can appear in so many places unrelated to the plugin name, i.e. sensor templates. Where is that needed? Fix the original files to use "plugin_template" instead of "template" where needed, and only replace that.

————

I entered:
```txt
Have `init.sh` work with git…
```

However, that seem to have broken something, as I got the commits
```txt
📄TEMPLATE | ✨ ai: [017] Have  work with git… (2/2)
```

They still are no longer in the commit message.

—————

The rebase drops other commits after/inbetween the changed ones!

—————

The
```txt
 ℹ Changes in that commit:
commit 93a763ea9f55c82483c6761a3c06c7475617f2ab
Author: luckydonald <m1-mac-2024._.code@luckydonald.de>
Date:   Sun Jan 18 00:32:15 2026 +0100

    📄TEMPLATE | 🐞 ai: updated errors

```
Is very nice, but I still want a proper diff display!
Attempt to use `bat` to have it colorised, but don't fail if it is not installed and show it uncolorized instead.

—————

ℹ Enter a message for all commits in this batch
⚠ Leave empty to keep individual 'running…' messages
⚠ Press Ctrl+C to cancel

Message for step [022]: Fix `init.sh` to have a proper diff…

ℹ Starting interactive rebase...

Executing: BATCH_MSG_ENV="$BATCH_MSG_ENV" /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.tUJxvKj2SJ '📄TEMPLATE | ✨ ai: [022] running… (1/X)' > /tmp/new_msg_$$.txt
Executing: git commit --amend -m "$(cat /tmp/new_msg_$$.txt)" && rm /tmp/new_msg_$$.txt
cat: /tmp/new_msg_3316.txt: No such file or directory
Aborting commit due to empty commit message.
warning: execution failed: git commit --amend -m "$(cat /tmp/new_msg_$$.txt)" && rm /tmp/new_msg_$$.txt
You can fix the problem, and then run

  git rebase --continue


✗ Rebase failed or was aborted
ℹ You can continue with: git rebase --continue
ℹ Or abort with: git rebase --abort
make: *** [fix-commits] Error 1

————

./scripts/fix-commits.sh: line 233: syntax error near unexpected token `fi'
make: *** [fix-commits] Error 2

———

`fix-commits.sh` seem be broken:
I got an editor to change the commit message? please do that automatically.
```COMMIT_EDITMSG
# This is a combination of 2 commits.
# This is the 1st commit message:

📄TEMPLATE | ✨  ai: [029] Squash non-conflicting commits… (1/1)

# This is the commit message #2:

📄TEMPLATE | ✨  ai: [029] running… (2/X)

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Sun Jan 18 01:28:45 2026 +0100
#
# interactive rebase in progress; onto a2c58f6
# Last commands done (8 commands done):
#    exec BATCH_MSG_ENV="$BATCH_MSG_ENV" SUBSTEP_OVERRIDE=2 /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.WODCiwO84Q '📄TEMPLATE | ✨  ai: [029] running… (2/X)' > /tmp/new_msg_1113bf0.txt
#    squash 1113bf0 📄TEMPLATE | ✨  ai: [029] running… (2/X)
# Next command to do (1 remaining command):
#    exec rm -f /tmp/new_msg_1113bf0.txt
# You are currently rebasing branch 'mane' on 'a2c58f6'.
#
# Changes to be committed:
#       new file:   FIX_COMMITS_SQUASHING.md
#       modified:   scripts/fix-commits.sh
#

"~/Documents/programming/Python/HomeAssistant/hoass_template/.git/COMMIT_EDITMSG" 26L, 1008B
```

The script output looks like this:

```txt
ℹ Starting interactive rebase...

Executing: BATCH_MSG_ENV="$BATCH_MSG_ENV" /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.e0dT9QW5U8 '📄TEMPLATE | 🤌 ai: updated query' > /tmp/new_msg_ed45d1d.txt
Executing: git commit --amend -m "$(cat /tmp/new_msg_ed45d1d.txt)" && rm -f /tmp/new_msg_ed45d1d.txt
[detached HEAD 99e60f2] 📄TEMPLATE | 🤌 ai: updated query: Squash non-conflicting commits…
 Date: Sun Jan 18 01:26:35 2026 +0100
 1 file changed, 5 insertions(+)
Executing: BATCH_MSG_ENV="$BATCH_MSG_ENV" SUBSTEP_OVERRIDE=1 /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.WODCiwO84Q '📄TEMPLATE | ✨ ai: [029] running… (1/X)' > /tmp/new_msg_37e2a10.txt
Executing: git commit --amend -m "$(cat /tmp/new_msg_37e2a10.txt)" && rm -f /tmp/new_msg_37e2a10.txt
[detached HEAD fdba3fe] 📄TEMPLATE | ✨ ai: [029] Squash non-conflicting commits… (1/1)
 Date: Sun Jan 18 01:28:45 2026 +0100
 1 file changed, 142 insertions(+), 8 deletions(-)
Executing: BATCH_MSG_ENV="$BATCH_MSG_ENV" SUBSTEP_OVERRIDE=2 /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.WODCiwO84Q '📄TEMPLATE | ✨ ai: [029] running… (2/X)' > /tmp/new_msg_1113bf0.txt
[detached HEAD f1545c9] 📄TEMPLATE | ✨ ai: [029] Squash non-conflicting commits… (1/1)
 Date: Sun Jan 18 01:28:45 2026 +0100
 2 files changed, 508 insertions(+), 8 deletions(-)
 create mode 100644 FIX_COMMITS_SQUASHING.md
Executing: rm -f /tmp/new_msg_1113bf0.txt
error: cannot rebase: You have unstaged changes.
warning: execution succeeded: rm -f /tmp/new_msg_1113bf0.txt
but left changes to the index and/or the working tree
Commit or stash your changes, and then run

  git rebase --continue


✗ Rebase failed or was aborted
ℹ You can continue with: git rebase --continue
ℹ Or abort with: git rebase --abort
make: *** [fix-commits] Error 1
```

———

After running `init.sh`, it still says `📝 Plugin Template - Commit Script`

———

When in the post-init project, running `commit.sh` does report `Error: Must be run from the repository root`   - fix that for `release.sh` as well.

———

On the second run with the `init.sh` I can't select the vue folder- just the none one, as the folder was renamed.
But that means that my vue specific files get deleted.

———

➜ make commit-fix

===================================================
Fix AI Commit Messages
===================================================

ℹ Scanning for AI commit batches...
ℹ Found AI commits for step [002]
✓ Found 8 commit(s) in this batch

Commits to fix:
53fd3ed 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (/5)
6b60837 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (2/5)
328da8a 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (3/5)
14970e1 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (4/5)
4d313cc 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (5/5)
d5e02a2 ✨ ai: [002] running… (1/X)
313db89 ✨ ai: [002] running… (2/X)
4e2a890 (HEAD -> mane) ✨ ai: [002] running… (3/X)


ℹ Enter a message for all commits in this batch
⚠ Leave empty to keep individual 'running…' messages
⚠ Press Ctrl+C to cancel

Message for step [002]: repair broken files…

ℹ Analyzing commits for potential squashing...

ℹ Found commits that could potentially be squashed:

  Commits 2 and 3:
    [2] 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (2/5)
    [3] 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (3/5)
    Files in [2]: custom_components/plugin_template/sensor.py
    Files in [3]: Makefile,custom_components/plugin_template/services.py,frontend_vue/src/AlarmClockCard.vue

  Commits 3 and 4:
    [3] 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (3/5)
    [4] 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (4/5)
    Files in [3]: Makefile,custom_components/plugin_template/services.py,frontend_vue/src/AlarmClockCard.vue
    Files in [4]: frontend_vue/package.json,frontend_vue/src/AlarmClockCard.vue,frontend_vue/src/main.ts

  Commits 4 and 5:
    [4] 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (4/5)
    [5] 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (5/5)
    Files in [4]: frontend_vue/package.json,frontend_vue/src/AlarmClockCard.vue,frontend_vue/src/main.ts
    Files in [5]: frontend_vue/src/main.ts

  Commits 5 and 6:
    [5] 📄TEMPLATE | ✨ ai: [002] Replace existing names with `plugin-template`… (5/5)
    [6] ✨ ai: [002] running… (1/X)
    Files in [5]: frontend_vue/src/main.ts
    Files in [6]: frontend/src/StateCyclerCard.vue

  Commits 6 and 7:
    [6] ✨ ai: [002] running… (1/X)
    [7] ✨ ai: [002] running… (2/X)
    Files in [6]: frontend/src/StateCyclerCard.vue
    Files in [7]: frontend/src/StateCyclerCard.vue

  Commits 7 and 8:
    [7] ✨ ai: [002] running… (2/X)
    [8] ✨ ai: [002] running… (3/X)
    Files in [7]: frontend/src/StateCyclerCard.vue
    Files in [8]: frontend/src/main.ts

Would you like to squash these commits? (y/n) [y]: y
ℹ Will squash the identified commits and adjust sub-numbering

fatal: ambiguous argument '^': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
make: *** [fix-commits] Error 128

———

Now it results in `📄TEMPLATE | 📄TEMPLATE | 🐞 ai: updated errors: fix squash…`, a doubled prefix

———

03:07:06 with user in Python/HomeAssistant/hoass_template on  mane [⇡] via 🐍 3.12.4 on 🐳 v28.1.1 (middlepip-ssh) via hoass_template 
➜ make commit-fix

===================================================
Fix AI Commit Messages
===================================================

ℹ Template repository detected
ℹ Scanning for AI commit batches...
ℹ Found AI commits for step [042]
✓ Found 1 commit(s) in this batch

Commits to fix:
b685601 (HEAD -> mane) 📄TEMPLATE | ✨ ai: [042] running… (1/X)

ℹ This batch was preceded by: 📄TEMPLATE | 🐞 ai: updated errors

ℹ Changes in that commit:

commit 036ee05563f93684608ad472541a15816b6badd5
Author: luckydonald <m1-mac-2024._.code@luckydonald.de>
Date:   Sun Jan 18 03:06:38 2026 +0100

    📄TEMPLATE | 🐞 ai: updated errors

diff --git a/ai/plugin_template/errors.md b/ai/plugin_template/errors.md
index e4d8c39..874aa33 100644
--- a/ai/plugin_template/errors.md
+++ b/ai/plugin_template/errors.md
@@ -340,3 +340,9 @@ fatal: ambiguous argument '^': unknown revision or path not in the working tree.
 Use '--' to separate paths from revisions, like this:
 'git <command> [<revision>...] -- [<file>...]'
 make: *** [fix-commits] Error 128
+
+———
+
+Now it results in `📄TEMPLATE | 📄TEMPLATE | 🐞 ai: updated errors: fix squash…`, a doubled prefix
+
+———


ℹ Enter a message for all commits in this batch
⚠ Leave empty to keep individual 'running…' messages
⚠ Press Ctrl+C to cancel

Message for step [042]: Fix double template-prefix…

ℹ Analyzing commits for potential squashing...
ℹ No squashing opportunities found (commits modify overlapping lines)

ℹ Starting interactive rebase...

✓ Created recovery tag: fix-commits-backup-step-042-20260118
ℹ If something goes wrong, you can recover with: git reset --hard fix-commits-backup-step-042-20260118

Executing: BATCH_MSG_ENV="$BATCH_MSG_ENV" /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.A3KAlKYvx1 '📄TEMPLATE | 🐞 ai: updated errors' > /tmp/new_msg_036ee05.txt
/var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.A3KAlKYvx1: line 16: syntax error in conditional expression: unexpected token `|'
/var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.A3KAlKYvx1: line 16: syntax error near `|'
/var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.A3KAlKYvx1: line 16: `if [ -n "$📄TEMPLATE | " ] && [[ ! "$NEW_MSG" =~ ^$📄TEMPLATE |  ]]; then'
warning: execution failed: BATCH_MSG_ENV="$BATCH_MSG_ENV" /var/folders/jv/xthv_j4x7xx6rg_dgpyypqcr0000gn/T/tmp.A3KAlKYvx1 '📄TEMPLATE | 🐞 ai: updated errors' > /tmp/new_msg_036ee05.txt
You can fix the problem, and then run

  git rebase --continue


✗ Rebase failed or was aborted
ℹ You can continue with: git rebase --continue
ℹ Or abort with: git rebase --abort
ℹ To recover to the state before rebase: git reset --hard fix-commits-backup-step-042-20260118
make: *** [fix-commits] Error 1

———

Now it's having 0x the template prefix, when in template mode, instead of juuuust 1x the prefix.

The squash is missing the prefix, too.

I still end up with the squashed one being without prefix…
I checked, the one put into the squash had the `TEMPLATE |` (similar) prefix.

Nope, no prefix.
Nope, still not the prefix. What is going on?!?

———

✓ Created recovery tag: fix-commits-backup-step-048-20260118
ℹ If something goes wrong, you can recover with: git reset --hard fix-commits-backup-step-048-20260118

error: cannot rebase: You have unstaged changes.
error: Please commit or stash them.
✗ Rebase failed or was aborted
ℹ You can continue with: git rebase --continue
ℹ Or abort with: git rebase --abort
ℹ To recover to the state before rebase: git reset --hard fix-commits-backup-step-048-20260118
make: *** [fix-commits] Error 1

———

Fix `PLUGIN-TEMPLATE-CARD` not being replaced in `main.ts`.

———

ℹ README.md is not the template version or doesn't exist - skipping README setup 

If it does not exist, continue. We can surely "over"write a non-exisiting file.

———

The `release.sh` script fails with:

```txt
Current version: vfix-commits-backup-step-047_2026-01-18_17-32-56
Error: Cannot parse version 'fix-commits-backup-step-047_2026-01-18_17-32-56'
```
It should ignore non-version tags (version tags will always start with `^v\d+`).

———

Missing pathes to replace with `init.sh`:
- `release.sh` causes `sed: custom_components/template/manifest.json: No such file or directory` - template should be plugin_template, and replaced?

———
Issues with `update-from-template.sh`:
```txt
➜ make template-rebase
✓ Using template remote: ℹ Found preferred template remote: template
template
ℹ Fetching from ℹ Found preferred template remote: template
template...
hostname contains invalid characters
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
✗ Failed to fetch from ℹ Found preferred template remote: template
template
make: *** [rebase-template] Error 1
```
I belive it's due to the remote being a directory path (would be helpful if you show the repository URL of the remote name somewhere).

———
➜ make template-rebase

===================================================
Home Assistant Plugin Template Update
===================================================

✓ Using template remote: ℹ Found preferred template remote: template (../hoass_template)
template
ℹ Fetching from ℹ Found preferred template remote: template (../hoass_template)
template...
hostname contains invalid characters
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
✗ Failed to fetch from ℹ Found preferred template remote: template (../hoass_template)
template
make: *** [rebase-template] Error 1

———
The rebase script seems to do the right decisions, however, it still opens the editor for every commit to change the message, instead of doing it automatically. Automatically means: use the provided message, but uncomment the merge details (remove leading `#`).

Auto-merging scripts/release.sh
CONFLICT (content): Merge conflict in scripts/release.sh
error: could not apply aeedc28... 🛫 template | Applied plugin template with `init.sh`
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply aeedc28... 🛫 template | Applied plugin template with `init.sh`
⚠ Manual conflict resolution required

Files with conflicts:
ai/plugin_template/query.md

Commands to resolve:
  1. Edit the conflicted files
  2. Stage resolved files: git add <file>
  3. Continue rebase: git rebase --continue
  4. Or abort: git rebase --abort

Tip: JetBrains IDEs (IntelliJ, PyCharm, etc.) have excellent Git rebase conflict resolution tools
     Look for 'Resolve Conflicts' in the Git tool window

Press Enter after resolving conflicts manually, or 'a' to abort: 
ℹ Continuing rebase after manual resolution...
sed: 1: ".git/rebase-merge/message": invalid command code .
make: *** [rebase-template] Error 1

maybe the file I merged was not automatically added to git from the script?
PS: retry if it fails due to that error, so I can continue editing if something with the resolved file is not right.
 Also, if it's juuuust that I forgot to add the file (but it's no longer a diff), just add it automatically instead of failing.

————
➜ make release
Script directory: /Users/user/Documents/programming/Python/HomeAssistant/hoass_state-cycler/scripts
🚀 State Cycler - Release Script

Error: scripts/init.json not found!
Please run 'make init' or './scripts/init.sh' first to initialize the project.
No existing version tags found, starting at v0.0.0-pre1
Current version: v0.0.0-pre0
New version: v0.0.0-pre1

Proceed with release? (Y/n) n
Aborted.

-> `release.sh` should actually abort if the json file can not be loaded (probably the exit state of the python script is not checked/set?)

———

➜ make lint-ts
Type checking / linting frontend...

> plugin-template-card@0.0.0-dev0 lint
> eslint "**/*.{ts,js,vue}" --quiet

sh: eslint: command not found

> plugin-template-card@0.0.0-dev0 type-check
> vue-tsc -b

sh: vue-tsc: command not found


➜ make format-ts
Formatting TypeScript...

> plugin-template-card@0.0.0-dev0 format
> dprint fmt

sh: dprint: command not found
make: *** [format-ts] Error 127

--> SOLUTION: `make setup-frontend` 

———
/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/src/PluginTemplateCard.vue
  46:16  error  'callService' is defined but never used  @typescript-eslint/no-unused-vars

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/src/main.ts
    1:1   error    File has too many classes (2). Maximum allowed is 1       max-classes-per-file
   24:5   error    Unexpected dangling '_' in '_hass'                        no-underscore-dangle
   25:9   error    Unexpected dangling '_' in '_instance'                    no-underscore-dangle
   25:9   error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   26:21  error    Unexpected dangling '_' in '_instance'                    no-underscore-dangle
   26:21  error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   32:5   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
   33:9   error    Unexpected dangling '_' in '_instance'                    no-underscore-dangle
   33:9   error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   34:21  error    Unexpected dangling '_' in '_instance'                    no-underscore-dangle
   34:21  error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   40:10  error    Unexpected dangling '_' in '_root'                        no-underscore-dangle
   41:7   error    Unexpected dangling '_' in '_root'                        no-underscore-dangle
   42:24  error    Unexpected dangling '_' in '_root'                        no-underscore-dangle
   45:25  error    Unexpected dangling '_' in '_hass'                        no-underscore-dangle
   46:27  error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
   48:5   error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   64:5   error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   64:21  error    Unexpected dangling '_' in '_root'                        no-underscore-dangle
   68:9   error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   69:7   error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   70:7   error    Unexpected dangling '_' in '_app'                         no-underscore-dangle
   74:3   error    Expected 'this' to be used by class method 'getCardSize'  class-methods-use-this
   96:5   error    Unexpected dangling '_' in '_hass'                        no-underscore-dangle
   97:5   error    Unexpected dangling '_' in '_render'                      no-underscore-dangle
  101:5   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  102:5   error    Unexpected dangling '_' in '_render'                      no-underscore-dangle
  105:3   error    Unexpected dangling '_' in '_render'                      no-underscore-dangle
  106:10  error    Unexpected dangling '_' in '_hass'                        no-underscore-dangle
  107:5   error    Unexpected dangling '_' in '_renderManual'                no-underscore-dangle
  110:3   error    Unexpected dangling '_' in '_renderManual'                no-underscore-dangle
  120:25  error    Unexpected dangling '_' in '_createTextInput'             no-underscore-dangle
  123:7   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  127:25  error    Unexpected dangling '_' in '_createEntityPicker'          no-underscore-dangle
  130:25  error    Unexpected dangling '_' in '_createSelect'                no-underscore-dangle
  133:7   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  155:25  error    Unexpected dangling '_' in '_createSelect'                no-underscore-dangle
  158:7   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  172:9   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  173:27  error    Unexpected dangling '_' in '_createNumberInput'           no-underscore-dangle
  176:9   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  181:27  error    Unexpected dangling '_' in '_createNumberInput'           no-underscore-dangle
  184:9   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  197:25  error    Unexpected dangling '_' in '_createToggle'                no-underscore-dangle
  200:7   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  203:25  error    Unexpected dangling '_' in '_createToggle'                no-underscore-dangle
  206:7   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  209:25  error    Unexpected dangling '_' in '_createToggle'                no-underscore-dangle
  212:7   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  216:25  error    Unexpected dangling '_' in '_createSelect'                no-underscore-dangle
  219:7   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  250:3   error    Unexpected dangling '_' in '_createTextInput'             no-underscore-dangle
  270:7   error    Unexpected dangling '_' in '_updateConfig'                no-underscore-dangle
  278:3   error    Unexpected dangling '_' in '_createNumberInput'           no-underscore-dangle
  303:7   error    Unexpected dangling '_' in '_updateConfig'                no-underscore-dangle
  311:3   error    Unexpected dangling '_' in '_createSelect'                no-underscore-dangle
  344:7   error    Unexpected dangling '_' in '_updateConfig'                no-underscore-dangle
  352:3   error    Unexpected dangling '_' in '_createToggle'                no-underscore-dangle
  372:7   error    Unexpected dangling '_' in '_updateConfig'                no-underscore-dangle
  380:3   error    Unexpected dangling '_' in '_createEntityPicker'          no-underscore-dangle
  393:9   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  394:42  error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  396:34  error    Unexpected dangling '_' in '_hass'                        no-underscore-dangle
  403:7   error    Unexpected dangling '_' in '_updateConfig'                no-underscore-dangle
  411:3   error    Unexpected dangling '_' in '_updateConfig'                no-underscore-dangle
  412:5   error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  413:10  error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  416:5   error    Unexpected dangling '_' in '_fireConfigChanged'           no-underscore-dangle
  419:3   error    Unexpected dangling '_' in '_fireConfigChanged'           no-underscore-dangle
  421:25  error    Unexpected dangling '_' in '_config'                      no-underscore-dangle
  443:1   warning  Unexpected console statement                              no-console

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/tests/PluginTemplateCard.test.ts
  0:0  error  Parsing error: ESLint was configured to run on `<tsconfigRootDir>/tests/PluginTemplateCard.test.ts` using `parserOptions.project`: /users/user/documents/programming/python/homeassistant/hoass_template/frontend_vue/tsconfig.json
However, that TSConfig does not include this file. Either:
- Change ESLint's list of included files to not include this file
- Change that TSConfig to include this file
- Create a new TSConfig that includes this file and include it in your parserOptions.project
See the typescript-eslint docs for more info: https://typescript-eslint.io/linting/troubleshooting#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/tests/main.test.ts
  0:0  error  Parsing error: ESLint was configured to run on `<tsconfigRootDir>/tests/main.test.ts` using `parserOptions.project`: /users/user/documents/programming/python/homeassistant/hoass_template/frontend_vue/tsconfig.json
However, that TSConfig does not include this file. Either:
- Change ESLint's list of included files to not include this file
- Change that TSConfig to include this file
- Create a new TSConfig that includes this file and include it in your parserOptions.project
See the typescript-eslint docs for more info: https://typescript-eslint.io/linting/troubleshooting#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/tests/setup.ts
  0:0  error  Parsing error: ESLint was configured to run on `<tsconfigRootDir>/tests/setup.ts` using `parserOptions.project`: /users/user/documents/programming/python/homeassistant/hoass_template/frontend_vue/tsconfig.json
However, that TSConfig does not include this file. Either:
- Change ESLint's list of included files to not include this file
- Change that TSConfig to include this file
- Create a new TSConfig that includes this file and include it in your parserOptions.project
See the typescript-eslint docs for more info: https://typescript-eslint.io/linting/troubleshooting#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/tests/types.test.ts
  0:0  error  Parsing error: ESLint was configured to run on `<tsconfigRootDir>/tests/types.test.ts` using `parserOptions.project`: /users/user/documents/programming/python/homeassistant/hoass_template/frontend_vue/tsconfig.json
However, that TSConfig does not include this file. Either:
- Change ESLint's list of included files to not include this file
- Change that TSConfig to include this file
- Create a new TSConfig that includes this file and include it in your parserOptions.project
See the typescript-eslint docs for more info: https://typescript-eslint.io/linting/troubleshooting#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/tests/utils.test.ts
  0:0  error  Parsing error: ESLint was configured to run on `<tsconfigRootDir>/tests/utils.test.ts` using `parserOptions.project`: /users/user/documents/programming/python/homeassistant/hoass_template/frontend_vue/tsconfig.json
However, that TSConfig does not include this file. Either:
- Change ESLint's list of included files to not include this file
- Change that TSConfig to include this file
- Create a new TSConfig that includes this file and include it in your parserOptions.project
See the typescript-eslint docs for more info: https://typescript-eslint.io/linting/troubleshooting#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/vite.config.ts
  0:0  error  Parsing error: ESLint was configured to run on `<tsconfigRootDir>/vite.config.ts` using `parserOptions.project`: /users/user/documents/programming/python/homeassistant/hoass_template/frontend_vue/tsconfig.json
However, that TSConfig does not include this file. Either:
- Change ESLint's list of included files to not include this file
- Change that TSConfig to include this file
- Create a new TSConfig that includes this file and include it in your parserOptions.project
See the typescript-eslint docs for more info: https://typescript-eslint.io/linting/troubleshooting#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file

/Users/user/Documents/programming/Python/HomeAssistant/hoass_template/frontend_vue/vitest.config.ts
  0:0  error  Parsing error: ESLint was configured to run on `<tsconfigRootDir>/vitest.config.ts` using `parserOptions.project`: /users/user/documents/programming/python/homeassistant/hoass_template/frontend_vue/tsconfig.json
However, that TSConfig does not include this file. Either:
- Change ESLint's list of included files to not include this file
- Change that TSConfig to include this file
- Create a new TSConfig that includes this file and include it in your parserOptions.project
See the typescript-eslint docs for more info: https://typescript-eslint.io/linting/troubleshooting#i-get-errors-telling-me-eslint-was-configured-to-run--however-that-tsconfig-does-not--none-of-those-tsconfigs-include-this-file

✖ 79 problems (78 errors, 1 warning)

———

[vite:css] Preprocessor dependency "sass-embedded" not found. Did you install it? Try `yarn add -D sass-embedded`.                                                                                                
———

The merge variant has the same problem with opening a EDITOR instead of automatically providing the commit message, with everything un-commented.

———
The merge script seems to be missing the `# Re-check after auto-staging` part?
Also, it should edit the existing message the editor would display, not create (overwrite) the existing / a new one - uncommenting there would pretty useless, no?.
———
./scripts/release.sh: line 162: syntax error near unexpected token `)'
./scripts/release.sh: SC1075: Use 'elif' instead of 'else if' (or put 'if' on new line if nesting).
./scripts/fix-commits.sh: line 188: mapfile: command not found
./scripts/fix-commits.sh: line 433: PRINT_DRY_RUN_HEADER: command not found
———
My GitHub workflow(s) has/have the problem:
```txt
error This project's package.json defines "packageManager": "yarn@4.12.0". However the current global version of Yarn is 1.22.22.
```
———
Why is `make setup-frontend` using `npm` instead of `yarn`?
Also fix it to be named `setup-ts` and the backend `-py` like the other options.
———
The query/error diff is in `make fix-commit` is no longer shown/found. I assume because of the changes for multiple batches?
Also, it no longer checks for dirty git state before starting the script...
———
Why does `make commit-fix -- --interactive` work but `make fix-commits -- --interactive` does not start interactively?
———
--dry-run flag is not working (or not displayed correctly) in --interactive mode.
———
The init script seems to crash in the `read -p "Copy new file $rel_path? (y/n) [y]: " COPY_NEW` line.
Please let it also - before that happens - ask if I would want to move the existing folder to a date-stamped backup folder; `custom_components/your_plugin` -> `custom_components/your_plugin.2025-12-25.bak`, to then copy the new one `plugin_template` in place as `your_plugin` (this after the rename step the previous code, including the merging.
———
`.github/workflows/release.yml` and `…/ci.yml`:
error This project's package.json defines "packageManager": "yarn@4.12.0". However the current global version of Yarn is 1.22.22.

Presence of the "packageManager" field indicates that the project is meant to be used with Corepack, a tool included by default with all official Node.js distributions starting from 16.9 and 14.19.
Corepack must currently be enabled by running corepack enable in your terminal. For more information, check out https://yarnpkg.com/corepack.
Error: Process completed with exit code 1.

- Use the yarn version from the `package.json`'s `.packageManager` (currently line 58).
  - I want you to enable the **current** yarn version as specified in `frontend(_vue)/package.json` at the time of running! No hardcoded version in the workflow files!
- Also make sure the `make setup-ts` step does the corepack thing too.
———
The install in the pipeline fails ("Install dependencies"):
Run yarn install
➤ YN0000: · Yarn 4.12.0
➤ YN0028: · The lockfile would have been created by this install, which is explicitly forbidden.
➤ YN0000: · Failed with errors in 0s 15ms
Error: Process completed with exit code 1.
