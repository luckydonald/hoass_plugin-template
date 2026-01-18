# ✅ Fixed: "Plugin Template" in commit.sh

## Issue

After running `init.sh`, the `commit.sh` script still displayed:
```
📝 Plugin Template - Commit Script
```

The text was not being replaced with the actual plugin name.

## Root Cause

The `scripts/commit.sh` file was not included in the `FILES_TO_PROCESS` array in `init.sh`, so the replacement logic never processed it.

## Solution

Added `scripts/commit.sh` and `scripts/release.sh` to the list of files to process:

```bash
# Add script files
[ -f "scripts/commit.sh" ] && FILES_TO_PROCESS+=("scripts/commit.sh")
[ -f "scripts/release.sh" ] && FILES_TO_PROCESS+=("scripts/release.sh")
```

## Result

After running `init.sh` with plugin name "My Plugin":

**Before:**
```
📝 Plugin Template - Commit Script
```

**After:**
```
📝 My Plugin - Commit Script
```

The replacement pattern `s/Plugin Template/$DISPLAY_NAME/g` now correctly replaces the text in `commit.sh`.

---

**Status**: ✅ Fixed
**File Modified**: scripts/init.sh
**Files Added to Processing**: scripts/commit.sh, scripts/release.sh

