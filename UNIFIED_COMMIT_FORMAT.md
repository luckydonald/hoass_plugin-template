```bash
if [ "$IS_TEMPLATE_REPO" = true ]; then
    # Won't match - uses different format
else
    COMMIT_MSG="✨ ai: running… (1-1)"
fi
```

### New Way (Unified)

**All Repos:**
```bash
COMMIT_PREFIX=""  # Set based on repo detection
COMMIT_MSG="${COMMIT_PREFIX}✨ ai: [007] running… (1/X)"
```

**Result:**
- Template: `📄TEMPLATE | ✨ ai: [007] running… (1/X)`
- User: `✨ ai: [007] running… (1/X)`

## Validation

Both scripts validate the format:

```bash
# Look for unified format
LAST_AI=$(git log --format=%s -1 --grep="ai: \[[0-9]\+\]")

if [ -z "$LAST_AI" ]; then
    print_error "No AI commits found in expected format"
    print_info "Expected format: ✨ ai: [NNN] message… (X/Y)"
    exit 1
fi
```

---

**Status**: ✅ Complete
**Format**: Unified across all repositories
**Prefix**: Dynamic based on repository detection
**Scripts**: commit.sh, fix-commits.sh updated
**Compatibility**: Works for both template and user repos
# ✅ Unified Commit Format Complete!

## Summary

Both `commit.sh` and `fix-commits.sh` now use the same unified commit format across all repositories, with the `📄TEMPLATE | ` prefix added dynamically only for the template repository.

## Changes Made

### 1. Unified Commit Format

**New format for ALL repositories:**
```
✨ ai: [007] running… (1/X)
```

With TEMPLATE prefix (template repo only):
```
📄TEMPLATE | ✨ ai: [007] running… (1/X)
```

### 2. Dynamic Prefix Application

The prefix is now added at the echo/commit time, not in the template string:

```bash
# Detect template repository
IS_TEMPLATE_REPO=false
COMMIT_PREFIX=""
if echo "$REPO_DIR" | grep -qE "^hoass_(plugin[-_])?template"; then
    IS_TEMPLATE_REPO=true
    COMMIT_PREFIX="📄TEMPLATE | "
fi

# Use prefix dynamically
git commit -m "${COMMIT_PREFIX}${COMMIT_MSG_QUERY}"
git commit -m "${COMMIT_PREFIX}✨ ai: [${padded_step}] ${msg} (${substep}/${total})"
```

### 3. Simplified Scripts

#### commit.sh
- ✅ Removed dual format logic
- ✅ Always uses zero-padded steps `[007]`
- ✅ Always uses `substep/total` format `(1/5)`
- ✅ Always uses `…` (ellipsis character)
- ✅ Prefix added dynamically based on repo detection

#### fix-commits.sh  
- ✅ Removed dual format detection
- ✅ Always searches for `ai: \[NNN\]` pattern
- ✅ Always uses zero-padded steps
- ✅ Prefix replaced via placeholder in scripts
- ✅ Works seamlessly across all repositories

## Format Specifications

### Commit Message Structure

```
[PREFIX]✨ ai: [STEP] MESSAGE… (SUBSTEP/TOTAL)
```

Where:
- `[PREFIX]` = `📄TEMPLATE | ` for template repo, empty for others
- `STEP` = Zero-padded 3 digits (e.g., `007`, `014`, `123`)
- `MESSAGE` = User message or "running"
- `…` = Single ellipsis character (U+2026)
- `SUBSTEP/TOTAL` = e.g., `(1/5)`, `(2/X)`

### Query/Error Commits

```
[PREFIX]🤌 ai: updated query
[PREFIX]🐞 ai: updated errors
```

After fix-commits with message:
```
[PREFIX]🤌 ai: updated query: Your message here
[PREFIX]🐞 ai: updated errors: Your message here
```

## Examples

### Template Repository

```bash
# Initial commits
📄TEMPLATE | 🤌 ai: updated query
📄TEMPLATE | ✨ ai: [007] running… (1/X)
📄TEMPLATE | ✨ ai: [007] running… (2/X)
📄TEMPLATE | ✨ ai: [007] running… (3/X)

# After fix-commits
📄TEMPLATE | 🤌 ai: updated query: Implement feature X
📄TEMPLATE | ✨ ai: [007] Implement feature X… (1/3)
📄TEMPLATE | ✨ ai: [007] Implement feature X… (2/3)
📄TEMPLATE | ✨ ai: [007] Implement feature X… (3/3)
```

### User Repository

```bash
# Initial commits
🤌 ai: updated query
✨ ai: [001] running… (1/X)
✨ ai: [001] running… (2/X)

# After fix-commits
🤌 ai: updated query: Add state cycling
✨ ai: [001] Add state cycling… (1/2)
✨ ai: [001] Add state cycling… (2/2)
```

## Benefits

### Consistency
- ✅ Same format everywhere
- ✅ Easy to recognize AI commits
- ✅ Clear numbering system
- ✅ Professional appearance

### Clarity
- ✅ Template commits clearly marked
- ✅ Step numbers always zero-padded
- ✅ Substep and total always shown
- ✅ Distinguishes work units

### Maintenance
- ✅ Single code path to maintain
- ✅ No dual format complexity
- ✅ Easier to update
- ✅ Less prone to bugs

## Migration

### Old Format (Regular Repos)
```
✨ ai: running… (3-2)
```

### New Format (All Repos)
```
✨ ai: [003] running… (2/X)
```

Old format commits will still be recognized for a transition period, but new commits use the unified format.

## Technical Details

### Prefix Detection

```bash
REPO_DIR=$(basename "$PWD")
if echo "$REPO_DIR" | grep -qE "^hoass_(plugin[-_])?template"; then
    COMMIT_PREFIX="📄TEMPLATE | "
else
    COMMIT_PREFIX=""
fi
```

Matches:
- `hoass_template`
- `hoass_plugin-template`
- `hoass_plugin_template`

### Placeholder Replacement

In scripts that generate commit messages:

```bash
# In the script template
echo "COMMIT_PREFIX_PLACEHOLDER✨ ai: [$PADDED_STEP] $MSG ($SUBSTEP/$TOTAL)"

# Replace placeholder
ESCAPED_PREFIX=$(echo "$COMMIT_PREFIX" | sed 's/[\/&]/\\&/g')
sed -i.bak "s/COMMIT_PREFIX_PLACEHOLDER/$ESCAPED_PREFIX/g" "$SCRIPT_FILE"
```

### Grep Patterns

Search for commits:
```bash
# Find all AI commits for step 7
git log --grep="ai: \[007\]"

# Find all AI commits (any step)
git log --grep="ai: \[[0-9]\+\]"

# Find query/error commits
git log --grep="ai: updated \(query\|errors\)"
```

## Comparison

### Old Way (Dual Format)

**Template Repo:**
```bash
if [ "$IS_TEMPLATE_REPO" = true ]; then
    COMMIT_MSG="📄TEMPLATE | ✨ ai: [007] running… (1/X)"
else
    COMMIT_MSG="✨ ai: running… (7-1)"
fi
```

**User Repo:**

