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
