
After initialization, you can customize:

- **CI checks**: Add more linters, tests
- **Build steps**: Add additional build tasks
- **Release artifacts**: Include more files
- **HACS validation**: Adjust validation rules

---

**Status**: ✅ Complete
**Files Added**: .github/workflows/ci.yml, .github/workflows/release.yml
**Integration**: Full GitHub Actions CI/CD
**HACS**: Compatible release structure
**Automation**: Tag-based releases
# ✅ GitHub Workflows Integration Complete!

## Summary

The `init.sh` script now properly handles the `.github/workflows` directory, copying workflow files and replacing plugin-specific names with template placeholders.

## Changes Made

### 1. Updated Workflow Files

**`.github/workflows/release.yml`:**
- Replaced `calendar_alarm_clock` → `plugin_template`
- Replaced `alarm-clock-card.js` → `plugin-template-card.js`
- Replaced `calendar_alarm_clock.zip` → `plugin-template.zip`

**Paths updated:**
```yaml
# Before
path: custom_components/calendar_alarm_clock/www/alarm-clock-card.js
sed -i 's/.../' custom_components/calendar_alarm_clock/manifest.json
cd custom_components/calendar_alarm_clock
zip -r ../../calendar_alarm_clock.zip .
files: calendar_alarm_clock.zip

# After
path: custom_components/plugin_template/www/plugin-template-card.js
sed -i 's/.../' custom_components/plugin_template/manifest.json
cd custom_components/plugin_template
zip -r ../../plugin-template.zip .
files: plugin-template.zip
```

### 2. Updated init.sh

Added `.github/workflows` files to processing:

```bash
# Add .github workflow files
if [ -d ".github/workflows" ]; then
    while IFS= read -r -d '' file; do
        FILES_TO_PROCESS+=("$file")
    done < <(find .github/workflows -type f \( -name "*.yml" -o -name "*.yaml" \) -print0)
fi
```

## What Gets Replaced

The `init.sh` script will now replace in workflow files:

| Pattern | Replacement | Example |
|---------|-------------|---------|
| `plugin_template` | `$SNAKE_NAME` | `my_plugin` |
| `plugin-template` | `$DASH_NAME` | `my-plugin` |
| `Plugin Template` | `$DISPLAY_NAME` | `My Plugin` |

## Example Transformation

### Before init.sh

**Release workflow:**
```yaml
path: custom_components/plugin_template/www/plugin-template-card.js
cd custom_components/plugin_template
zip -r ../../plugin-template.zip .
files: plugin-template.zip
```

### After init.sh (with plugin name "State Cycler")

**Release workflow:**
```yaml
path: custom_components/state_cycler/www/state-cycler-card.js
cd custom_components/state_cycler
zip -r ../../state-cycler.zip .
files: state-cycler.zip
```

## Workflow Files Included

### CI Workflow (`.github/workflows/ci.yml`)
- Python linting with Ruff
- Frontend build verification
- Runs on push/PR to mane/main branches

### Release Workflow (`.github/workflows/release.yml`)
- Builds frontend on tag push
- Creates GitHub release with zip file
- Updates manifest version
- Validates with HACS

## Benefits

### Automated CI/CD
- ✅ Automatic linting on every push
- ✅ Build verification
- ✅ Automated releases on tags

### HACS Integration
- ✅ Proper zip structure for HACS
- ✅ HACS validation step
- ✅ Automated release notes

### Version Management
- ✅ Syncs version from git tags
- ✅ Updates manifest automatically
- ✅ Creates proper release artifacts

## File Structure

```
.github/
└── workflows/
    ├── ci.yml        ← Runs on push/PR
    └── release.yml   ← Runs on tag push
```

## Testing

To verify the workflows work after initialization:

```bash
# Run init.sh
./scripts/init.sh

# Commit the changes
git add .github/
git commit -m "Configure GitHub workflows"

# Push to trigger CI
git push origin mane

# Create a release
git tag v0.0.1
git push origin v0.0.1
# This triggers the release workflow
```

## Workflow Triggers

### CI Workflow
```yaml
on:
  push:
    branches: [mane, main]
  pull_request:
    branches: [mane, main]
```

### Release Workflow
```yaml
on:
  push:
    tags: ['v*']
```

## Release Process

When you push a tag:

1. **Build** - Frontend is built
2. **Package** - Creates HACS-compatible zip
3. **Release** - Creates GitHub release with:
   - Zip file attachment
   - Auto-generated release notes
   - Proper prerelease detection

## HACS Compatibility

The workflow creates a zip file with the correct structure:

```
plugin-name.zip
├── __init__.py
├── manifest.json
├── sensor.py
├── www/
│   └── plugin-name-card.js
└── ... (other component files)
```

When extracted, files go directly into `custom_components/plugin-name/`.

## Customization

