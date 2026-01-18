# ✅ Fixed: init.sh Re-run Frontend Detection

## Issue

On the second run of `init.sh`, the script couldn't detect the Vue frontend because the `frontend_vue/` directory had already been renamed to `frontend/` during the first run. This caused:
- Only "none" option was available
- Selecting "none" would delete the existing `frontend/` directory
- Loss of Vue-specific files

## Root Cause

The script only checked for `frontend_vue/` to determine if Vue was available:

```bash
# Before fix
HAS_VUE=false
[ -d "frontend_vue" ] && HAS_VUE=true

# On first run: frontend_vue/ exists → HAS_VUE=true ✓
# On re-run: frontend_vue/ doesn't exist → HAS_VUE=false ✗
```

## Solution

Updated the detection to also check for `frontend/` (which exists after first initialization):

```bash
# After fix
HAS_VUE=false
[ -d "frontend_vue" ] && HAS_VUE=true
[ -d "frontend" ] && HAS_VUE=true  # Already initialized

# On first run: frontend_vue/ exists → HAS_VUE=true ✓
# On re-run: frontend/ exists → HAS_VUE=true ✓
```

## Display Updates

The display now adapts based on which directory exists:

**First Run:**
```
Choose your frontend framework:
  vue   - Vue.js framework (from frontend_vue/)
  none  - No frontend (backend-only plugin)
```

**Re-run (after first initialization):**
```
Choose your frontend framework:
  vue   - Vue.js framework (keep existing frontend/)
  none  - No frontend (backend-only plugin)
```

## Behavior

### First Run (frontend_vue/ exists)
1. User selects "vue"
2. `frontend_vue/` is renamed to `frontend/`
3. Files are processed and replaced

### Second Run (frontend/ exists)
1. Script detects `frontend/` as Vue
2. User can select "vue" again
3. `frontend/` is kept as-is
4. Files are re-processed with updated templates

### Handling "none" on Re-run
```bash
if [ "$FRONTEND_CHOICE" = "none" ]; then
    [ -d "frontend_vue" ] && rm -rf "frontend_vue"
    [ -d "frontend_plain" ] && rm -rf "frontend_plain"
    [ -d "frontend" ] && rm -rf "frontend"  # Removes existing frontend
```

## Safety

The existing logic already had proper handling:

```bash
elif [ "$FRONTEND_CHOICE" = "vue" ]; then
    if [ -d "frontend_vue" ]; then
        # First run: rename frontend_vue to frontend
        safe_move_directory "frontend_vue" "frontend" "Frontend"
    elif [ ! -d "frontend" ]; then
        # Error: neither exists
        print_error "frontend_vue/ directory not found and no frontend/ exists!"
        exit 1
    else
        # Re-run: frontend already exists, keep it
        print_info "frontend/ directory already exists, keeping it"
    fi
```

## Test Scenarios

### Scenario 1: First Run
```bash
# Initial state
ls -d frontend*
# frontend_vue/

./scripts/init.sh
# Select: vue

# After
ls -d frontend*
# frontend/
```

### Scenario 2: Re-run (Update Templates)
```bash
# Initial state
ls -d frontend*
# frontend/

./scripts/init.sh
# Select: vue ← NOW WORKS!

# After
ls -d frontend*
# frontend/  (kept, files re-processed)
```

### Scenario 3: Switch to None
```bash
# Initial state
ls -d frontend*
# frontend/

./scripts/init.sh
# Select: none

# After
ls -d frontend*
# (no output - frontend/ deleted)
```

### Scenario 4: Add Frontend Later
```bash
# Initial state (no frontend)
./scripts/init.sh
# Select: none

# Later, manually add frontend_vue/
mkdir frontend_vue
# ... add files ...

./scripts/init.sh
# Select: vue ← Works on re-run
```

## Benefits

### Re-run Safety
- ✅ Can re-run init.sh without losing frontend
- ✅ Vue option available on re-runs
- ✅ Templates get updated on re-runs

### Flexibility
- ✅ Can update plugin name/settings
- ✅ Can add new template files
- ✅ Can switch between options

### Clear Messaging
- ✅ Different messages for first run vs re-run
- ✅ User knows what will happen
- ✅ No surprise deletions

---

**Status**: ✅ Fixed
**Issue**: Vue not detected on re-run
**Solution**: Check both frontend_vue/ and frontend/
**Result**: init.sh now fully supports re-runs

