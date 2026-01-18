# ... rebase fails ...

✗ Rebase failed or was aborted
ℹ You can continue with: git rebase --continue
ℹ Or abort with: git rebase --abort
ℹ To recover to the state before rebase: git reset --hard fix-commits-backup-step-014-20260118

# Recover:
git reset --hard fix-commits-backup-step-014-20260118

# Tag is still there for next time
```

### Example 3: Keep Recovery Tags

```bash
make fix-commits

# ... successful rebase ...

Would you like to delete these old recovery tags? (y/n) [n]: n

ℹ Keeping old recovery tags
ℹ You can manually delete them later with: git tag -d <tag-name>

Delete the recovery tag for this rebase? (y/n) [y]: n

ℹ Keeping recovery tag: fix-commits-backup-step-014-20260118
ℹ Delete it manually when no longer needed: git tag -d fix-commits-backup-step-014-20260118
```

## Recovery Scenarios

### Scenario 1: Rebase Goes Wrong

```bash
# During rebase, something breaks
git rebase --abort

# Recover to state before fix-commits
git reset --hard fix-commits-backup-step-014-20260118

# Try again
make fix-commits
```

### Scenario 2: Conflicts During Rebase

```bash
# Rebase stops at conflict
# Don't want to resolve it

git rebase --abort
git reset --hard fix-commits-backup-step-014-20260118

# Back to original state
```

### Scenario 3: Wrong Message Applied

```bash
# Completed rebase but message was wrong
git reset --hard fix-commits-backup-step-014-20260118

# Run again with correct message
make fix-commits
```

## Safety Features

### Pre-Rebase Tag

- ✅ Created before any changes
- ✅ Always points to clean state
- ✅ Easy to find (predictable name)
- ✅ Shows recovery command

### Smart Cleanup

- ✅ Only suggests tags not in current branch
- ✅ Never deletes tags from failed rebases
- ✅ Requires user confirmation
- ✅ Shows what will be deleted

### Manual Control

- ✅ Can keep all tags if desired
- ✅ Can manually delete anytime
- ✅ Clear instructions provided

## Tag Lifecycle

### Creation
```
make fix-commits
→ Tag created: fix-commits-backup-step-014-20260118
```

### During Rebase
```
Tag points to HEAD before rebase
Use if rebase fails: git reset --hard <tag>
```

### After Success
```
Option 1: Delete automatically (default)
Option 2: Keep for safety
```

### Manual Cleanup
```bash
# List all recovery tags
git tag -l "fix-commits-backup-*"

# Delete specific tag
git tag -d fix-commits-backup-step-014-20260118

# Delete all recovery tags
git tag -l "fix-commits-backup-*" | xargs git tag -d
```

## Benefits

### Safety Net
- ✅ **Easy recovery** from failed rebases
- ✅ **One command** to restore
- ✅ **No data loss** risk

### Clean Repository
- ✅ **Automatic cleanup** of old tags
- ✅ **No manual management** needed
- ✅ **Prevents tag clutter**

### Flexibility
- ✅ **Customizable** tag names
- ✅ **Optional** cleanup
- ✅ **Manual control** available

## Configuration

### Customize Tag Template

Edit at top of `scripts/fix-commits.sh`:

```bash
# Simple numeric
RECOVERY_TAG_TEMPLATE="backup-{step}"

# With timestamp
RECOVERY_TAG_TEMPLATE="fix-backup-{step}-{date}-{time}"

# Descriptive
RECOVERY_TAG_TEMPLATE="rebase-safety-step{step}-{date}"
```

### Pattern Matching

The cleanup looks for tags matching:
```bash
RECOVERY_PATTERN="fix-commits-backup-step-"
```

Make sure your template starts with this pattern, or update the pattern in the cleanup code.

## Technical Details

### Tag Creation
```bash
CURRENT_HEAD=$(git rev-parse HEAD)
git tag "$RECOVERY_TAG" "$CURRENT_HEAD"
```

### Finding Old Tags
```bash
# Get all matching tags
git tag -l "${RECOVERY_PATTERN}*"

# Check if tag is in current branch
git merge-base --is-ancestor "$tag" HEAD
```

### Cleanup Logic
```bash
# Tag is NOT in current branch → can be deleted
if ! git merge-base --is-ancestor "$tag" HEAD; then
    OLD_TAGS+=("$tag")
fi
```

## Best Practices

### When to Delete Tags

**Delete automatically (recommended):**
- Normal rebases that succeed
- No issues encountered
- Don't need recovery point

**Keep tags when:**
- First time using fix-commits
- Complex rebases
- Want extra safety net
- Testing changes

### When to Recover

Use recovery tag when:
- Rebase goes wrong
- Applied wrong message
- Unexpected conflicts
- Want to start over

### Tag Maintenance

**Good:**
```bash
# Let script auto-cleanup
make fix-commits
# → Select 'y' to delete old tags
```

**Also good:**
```bash
# Periodic manual cleanup
git tag -l "fix-commits-backup-*" | grep -v $(date +%Y%m) | xargs git tag -d
# Keeps only current month's tags
```

---

**Status**: ✅ Complete
**Feature**: Recovery tags with automatic cleanup
**Template**: Customizable tag naming
**Safety**: Multiple confirmation steps
**Cleanup**: Automatic detection and removal
# ✅ Recovery Tags Feature Complete!

## Summary

The `fix-commits.sh` script now creates recovery tags before rebasing and cleans up old recovery tags after successful completion.

## Features

### 1. Recovery Tag Template

Configurable tag name template at the top of the script:

```bash
# Recovery tag template - customize this as needed
# Available variables: {step}, {date}, {time}
RECOVERY_TAG_TEMPLATE="fix-commits-backup-step-{step}-{date}"
```

### 2. Pre-Rebase Tagging

Before starting the rebase, creates a recovery tag:

```bash
# Example tags created:
fix-commits-backup-step-014-20260118
fix-commits-backup-step-7-20260118
```

### 3. Post-Rebase Cleanup

After successful rebase:
- Finds old recovery tags not in current branch
- Asks user to delete them
- Optionally deletes the current recovery tag

## How It Works

### Recovery Tag Creation

**Before rebase starts:**
```
ℹ Starting interactive rebase...

✓ Created recovery tag: fix-commits-backup-step-014-20260118
ℹ If something goes wrong, you can recover with: git reset --hard fix-commits-backup-step-014-20260118
```

The tag points to the current HEAD before any rebase operations.

### Template Variables

Available variables in `RECOVERY_TAG_TEMPLATE`:

| Variable | Description | Example |
|----------|-------------|---------|
| `{step}` | Step number (padded for template repo) | `014` or `7` |
| `{date}` | Current date (YYYYMMDD) | `20260118` |
| `{time}` | Current time (HHMMSS) | `143025` |

### Example Templates

```bash
# Default
RECOVERY_TAG_TEMPLATE="fix-commits-backup-step-{step}-{date}"
# Result: fix-commits-backup-step-014-20260118

# With time
RECOVERY_TAG_TEMPLATE="fix-commits-backup-step-{step}-{date}-{time}"
# Result: fix-commits-backup-step-014-20260118-143025

# Shorter
RECOVERY_TAG_TEMPLATE="fix-backup-{step}"
# Result: fix-backup-014

# Custom prefix
RECOVERY_TAG_TEMPLATE="rebase-safety-{step}-{date}"
# Result: rebase-safety-014-20260118
```

## Cleanup Process

### After Successful Rebase

**Step 1: Find old tags**
```
ℹ Checking for old recovery tags to clean up...

⚠ Found 3 old recovery tag(s) not in current branch:
  - fix-commits-backup-step-013-20260117
  - fix-commits-backup-step-012-20260116
  - fix-commits-backup-step-011-20260115

Would you like to delete these old recovery tags? (y/n) [n]:
```

**Step 2: Delete if confirmed**
```
y

✓ Deleted tag: fix-commits-backup-step-013-20260117
✓ Deleted tag: fix-commits-backup-step-012-20260116
✓ Deleted tag: fix-commits-backup-step-011-20260115

✓ Old recovery tags cleaned up
```

**Step 3: Delete current recovery tag**
```
Delete the recovery tag for this rebase? (y/n) [y]: y

✓ Deleted recovery tag: fix-commits-backup-step-014-20260118
```

### What Gets Cleaned Up

The script finds tags that are:
1. Matching the recovery pattern (`fix-commits-backup-step-*`)
2. NOT in the current branch's history
3. NOT the tag just created

This ensures:
- ✅ Tags from successful rebases are cleaned up
- ✅ Tags from aborted/failed rebases are kept
- ✅ Current recovery tag is available until manually deleted

## Usage Examples

### Example 1: Successful Rebase

```bash
make fix-commits

# ... rebase process ...

✓ Rebase completed successfully!

ℹ Checking for old recovery tags to clean up...
⚠ Found 2 old recovery tag(s) not in current branch:
  - fix-commits-backup-step-013-20260117
  - fix-commits-backup-step-012-20260116

Would you like to delete these old recovery tags? (y/n) [n]: y

✓ Deleted tag: fix-commits-backup-step-013-20260117
✓ Deleted tag: fix-commits-backup-step-012-20260116

Delete the recovery tag for this rebase? (y/n) [y]: y

✓ Deleted recovery tag: fix-commits-backup-step-014-20260118
```

### Example 2: Failed Rebase - Recovery

```bash
make fix-commits

✓ Created recovery tag: fix-commits-backup-step-014-20260118
ℹ If something goes wrong, you can recover with: git reset --hard fix-commits-backup-step-014-20260118


