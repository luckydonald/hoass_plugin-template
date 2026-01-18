# ✅ Fixed: Repository Root Detection in Scripts

## Issue

After running `init.sh`, both `commit.sh` and `release.sh` would fail with:
```
Error: Must be run from the repository root
```

This was because they were checking for the hardcoded path `custom_components/plugin_template/manifest.json` which no longer exists after the template is initialized.

## Root Cause

Both scripts had hardcoded checks for template-specific paths:

**commit.sh:**
```bash
if \
  [ ! -f "custom_components/plugin_template/manifest.json" ] \
  && [ ! -f "frontend{,_vue,_plain}/src/main.ts" ] \
  && [ ! -f "frontend{,_vue,_plain}/package.json" ] \
; then
```

**release.sh:**
```bash
if [ ! -f "custom_components/plugin_template/manifest.json" ]; then
```

## Solution

Updated both scripts to check for generic indicators of being in the repository root that work both before and after initialization:

### New Check (Both Scripts)
```bash
# Look for any of: custom_components/, frontend/, frontend_vue/, or hacs.json
if [ ! -d "custom_components" ] && [ ! -d "frontend" ] && [ ! -d "frontend_vue" ] && [ ! -f "hacs.json" ]; then
    echo -e "${RED}Error: Must be run from the repository root${NC}"
    echo "Expected to find: custom_components/, frontend/, or hacs.json"
    exit 1
fi
```

### Additional Fix

Also fixed the hardcoded plugin name in `release.sh`:

**Before:**
```bash
echo -e "${GREEN}🚀 Calendar Alarm Clock - Release Script${NC}"
```

**After:**
```bash
echo -e "${GREEN}🚀 Plugin Template - Release Script${NC}"
```

Now `init.sh` will replace "Plugin Template" with the actual plugin name.

## What Gets Checked

The scripts now look for any of these indicators:
- ✅ `custom_components/` directory (backend plugins)
- ✅ `frontend/` directory (after init.sh)
- ✅ `frontend_vue/` directory (before init.sh)
- ✅ `hacs.json` file (HACS-compatible plugins)

This works for:
- ✅ Backend-only plugins
- ✅ Frontend-only plugins
- ✅ Full-stack plugins
- ✅ Before and after init.sh

## Result

**Before Fix:**
```bash
./scripts/commit.sh
Error: Must be run from the repository root

./scripts/release.sh
Error: Must be run from the repository root
```

**After Fix:**
```bash
./scripts/commit.sh
📝 My Plugin Name - Commit Script

./scripts/release.sh
🚀 My Plugin Name - Release Script
```

---

**Status**: ✅ Fixed
**Files Modified**: 
- scripts/commit.sh
- scripts/release.sh
**Changes**: Generic repository root detection that works after initialization

