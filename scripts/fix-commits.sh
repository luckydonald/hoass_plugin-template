#!/usr/bin/env bash
# ============================================================================
# Fix AI Commit Messages
# ============================================================================
#
# This script rebases the last batch of AI commits to:
#   1. Replace X with the actual total count in template format
#   2. Allow editing default "running…" messages to meaningful descriptions
#
# Supports both formats:
#   - Template: 📄TEMPLATE | ✨ ai: [013] running… (2/X)
#   - Regular: ✨ ai: running… (2-3)
#
# Usage:
#   ./scripts/fix-commits.sh
#   make fix-commits
#
# ============================================================================

set -e  # Exit on error

# Recovery tag template - customize this as needed
# Available variables: {step}, {date}, {time}
RECOVERY_TAG_TEMPLATE="fix-commits-backup-step-{step}-{date}"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}===================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================================${NC}\n"
}

print_info() {
    echo -e "${GREEN}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_header "Fix AI Commit Messages"

# Get the repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a git repository!"
    exit 1
fi

# Check if HEAD is detached
if ! git symbolic-ref -q HEAD > /dev/null; then
    print_error "HEAD is in a detached state!"
    print_info "Please checkout a branch first: git checkout <branch>"
    exit 1
fi

# Check for ongoing git operations
if [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; then
    print_error "A rebase is already in progress!"
    print_info "Continue with: git rebase --continue"
    print_info "Or abort with: git rebase --abort"
    exit 1
fi

if [ -f ".git/MERGE_HEAD" ]; then
    print_error "A merge is in progress!"
    print_info "Complete the merge first or abort with: git merge --abort"
    exit 1
fi

if [ -f ".git/CHERRY_PICK_HEAD" ]; then
    print_error "A cherry-pick is in progress!"
    print_info "Complete it or abort with: git cherry-pick --abort"
    exit 1
fi

if [ -f ".git/REVERT_HEAD" ]; then
    print_error "A revert is in progress!"
    print_info "Complete it or abort with: git revert --abort"
    exit 1
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    print_error "You have uncommitted changes. Please commit or stash them first."
    git status --short
    exit 1
fi

# Detect if this is a template repository and set commit prefix
REPO_DIR=$(basename "$PWD")
IS_TEMPLATE_REPO=false
COMMIT_PREFIX=""
if echo "$REPO_DIR" | grep -qE "^hoass_(plugin[-_])?template"; then
    IS_TEMPLATE_REPO=true
    COMMIT_PREFIX="📄TEMPLATE | "
    print_info "Template repository detected"
fi

# Find the last batch of AI commits
print_info "Scanning for AI commit batches..."

# Look for unified format: ✨ ai: [NNN] message… (X/Y)
# Works with or without TEMPLATE prefix
LAST_AI=$(git log --format=%s -1 --grep="ai: \[[0-9]\+\]")

if [ -z "$LAST_AI" ]; then
    print_error "No AI commits found in expected format"
    print_info "Expected format: ✨ ai: [NNN] message… (X/Y)"
    exit 1
fi

# Extract the step number (remove leading zeros)
STEP=$(echo "$LAST_AI" | sed 's/.*ai: \[\([0-9]*\)\].*/\1/' | sed 's/^0*//')
PADDED_STEP=$(printf "%03d" "$STEP")

print_info "Found AI commits for step [$PADDED_STEP]"

# Find all consecutive commits with the same step number, stopping at query/error or different steps
COMMIT_HASHES=()
COMMIT_COUNT=0

# Start from the last AI commit and walk backwards
CURRENT_COMMIT=$(git log --format=%H -1 --grep="ai: \[$PADDED_STEP\]")

while [ -n "$CURRENT_COMMIT" ]; do
    # Check if this commit has the correct step number
    COMMIT_MSG=$(git log --format=%s -1 "$CURRENT_COMMIT")
    if echo "$COMMIT_MSG" | grep -q "ai: \[$PADDED_STEP\]"; then
        # This is part of our batch
        COMMIT_HASHES=("$CURRENT_COMMIT" "${COMMIT_HASHES[@]}")
        COMMIT_COUNT=$((COMMIT_COUNT + 1))

        # Get the parent commit
        PARENT_COMMIT=$(git rev-parse "$CURRENT_COMMIT^" 2>/dev/null)
        if [ -z "$PARENT_COMMIT" ]; then
            # No more parents, stop
            break
        fi

        # Check the parent's message
        PARENT_MSG=$(git log --format=%s -1 "$PARENT_COMMIT")

        # Stop if parent is a query/error update
        if echo "$PARENT_MSG" | grep -qE "(ai: updated query|ai: updated errors)"; then
            print_info "Stopping at query/error commit: $PARENT_MSG"
            break
        fi

        # Stop if parent is a different AI step
        if echo "$PARENT_MSG" | grep -q "ai: \[[0-9]\+\]" && ! echo "$PARENT_MSG" | grep -q "ai: \[$PADDED_STEP\]"; then
            print_info "Stopping at different AI step: $PARENT_MSG"
            break
        fi

        # Continue with parent
        CURRENT_COMMIT="$PARENT_COMMIT"
    else
        # This commit doesn't match our step, stop
        break
    fi
done

if [ "$COMMIT_COUNT" -eq 0 ]; then
    print_error "No commits found for step [$PADDED_STEP]"
    exit 1
fi

print_success "Found $COMMIT_COUNT commit(s) in this connected batch"

# Show the commits
echo ""
echo "Commits to fix:"
for commit_hash in "${COMMIT_HASHES[@]}"; do
    git log --oneline -1 "$commit_hash"
done
echo ""

# Check if this batch was preceded by a query/error update
FIRST_COMMIT="${COMMIT_HASHES[0]}"
PARENT_COMMIT=$(git rev-parse "$FIRST_COMMIT^")
PARENT_MSG=$(git log --format=%s -1 "$PARENT_COMMIT")

QUERY_ERROR_COMMIT=""
if echo "$PARENT_MSG" | grep -qE "(ai: updated query|ai: updated errors)"; then
    QUERY_ERROR_COMMIT="$PARENT_COMMIT"
    print_info "This batch was preceded by: $PARENT_MSG"
    echo ""
    print_info "Changes in that commit:"
    echo ""

    # Disable pager unless USE_PAGER is set
    if [ -z "$USE_PAGER" ]; then
        export GIT_PAGER=cat
    fi

    # Try to use bat for colorized output, fall back to plain git show
    if command -v bat &> /dev/null; then
        git show "$PARENT_COMMIT" | bat --style=plain --color=always --language=diff --paging=never
    else
        git show "$PARENT_COMMIT"
    fi
    echo ""
fi

# Ask for the message once for all commits in this batch
echo ""
print_info "Enter a message for all commits in this batch"
print_warning "Leave empty to keep individual 'running…' messages"
print_warning "Press Ctrl+C to cancel"
echo ""
read -p "Message for step [$PADDED_STEP]: " BATCH_MESSAGE
echo ""

# Analyze commits for potential squashing
print_info "Analyzing commits for potential squashing..."

# Array to track which commits to squash
SQUASH_COMMITS=()

# Check each pair of consecutive commits
for ((i=0; i<${#COMMIT_HASHES[@]}-1; i++)); do
    COMMIT1="${COMMIT_HASHES[$i]}"
    COMMIT2="${COMMIT_HASHES[$((i+1))]}"

    # Check if these commits can be squashed by analyzing line overlaps
    can_squash=true

    # Get all files changed in both commits
    FILES1=$(git diff-tree --no-commit-id --name-only -r "$COMMIT1" | sort)
    FILES2=$(git diff-tree --no-commit-id --name-only -r "$COMMIT2" | sort)

    # Find files that appear in both commits
    COMMON_FILES=$(comm -12 <(echo "$FILES1") <(echo "$FILES2"))

    if [ -n "$COMMON_FILES" ]; then
        # They touch some common files - check if they modify different lines
        while IFS= read -r file; do
            if [ -z "$file" ]; then
                continue
            fi

            # Get the line ranges modified in each commit for this file
            # Use git diff to see which lines were changed

            # Get parent of COMMIT1 to compare against
            PARENT1=$(git rev-parse "$COMMIT1^")

            # Get lines changed in COMMIT1 for this file
            LINES1=$(git diff "$PARENT1" "$COMMIT1" -- "$file" 2>/dev/null | grep '^@@' | sed 's/@@ -[0-9,]* +\([0-9,]*\).*/\1/')

            # Get lines changed in COMMIT2 for this file (comparing against COMMIT1)
            LINES2=$(git diff "$COMMIT1" "$COMMIT2" -- "$file" 2>/dev/null | grep '^@@' | sed 's/@@ -[0-9,]* +\([0-9,]*\).*/\1/')

            # Convert line ranges to actual line numbers for comparison
            # This is a simplified check - if we can't determine, assume overlap
            if [ -n "$LINES1" ] && [ -n "$LINES2" ]; then
                # Extract starting line numbers
                START1=$(echo "$LINES1" | head -1 | cut -d, -f1)
                START2=$(echo "$LINES2" | head -1 | cut -d, -f1)

                # Get ending line numbers (start + count, or just start if no comma)
                if echo "$LINES1" | head -1 | grep -q ','; then
                    COUNT1=$(echo "$LINES1" | head -1 | cut -d, -f2)
                    END1=$((START1 + COUNT1))
                else
                    END1=$START1
                fi

                if echo "$LINES2" | head -1 | grep -q ','; then
                    COUNT2=$(echo "$LINES2" | head -1 | cut -d, -f2)
                    END2=$((START2 + COUNT2))
                else
                    END2=$START2
                fi

                # Check if ranges overlap
                # Ranges overlap if: START1 <= END2 AND START2 <= END1
                if [ "$START1" -le "$END2" ] && [ "$START2" -le "$END1" ]; then
                    # Lines overlap - cannot squash
                    can_squash=false
                    break
                fi
            else
                # Cannot determine line ranges safely - assume overlap
                can_squash=false
                break
            fi
        done <<< "$COMMON_FILES"
    fi

    if [ "$can_squash" = true ]; then
        SQUASH_COMMITS+=("$i:$((i+1))")
    fi
done

# Present squashing opportunities to the user
if [ ${#SQUASH_COMMITS[@]} -gt 0 ]; then
    echo ""
    print_info "Found commits that could potentially be squashed:"
    echo ""

    for pair in "${SQUASH_COMMITS[@]}"; do
        idx1=$(echo "$pair" | cut -d: -f1)
        idx2=$(echo "$pair" | cut -d: -f2)
        commit1="${COMMIT_HASHES[$idx1]}"
        commit2="${COMMIT_HASHES[$idx2]}"

        msg1=$(git log --format=%s -1 "$commit1")
        msg2=$(git log --format=%s -1 "$commit2")

        echo "  Commits $((idx1+1)) and $((idx2+1)):"
        echo "    [$((idx1+1))] $msg1"
        echo "    [$((idx2+1))] $msg2"

        # Show what files each touches
        files1=$(git diff-tree --no-commit-id --name-only -r "$commit1" | head -3)
        files2=$(git diff-tree --no-commit-id --name-only -r "$commit2" | head -3)
        echo "    Files in [$((idx1+1))]: $(echo "$files1" | tr '\n' ', ' | sed 's/,$//')"
        echo "    Files in [$((idx2+1))]: $(echo "$files2" | tr '\n' ', ' | sed 's/,$//')"
        echo ""
    done

    read -p "Would you like to squash these commits? (y/n) [n]: " SQUASH_CHOICE
    SQUASH_CHOICE=${SQUASH_CHOICE:-n}

    if [[ "$SQUASH_CHOICE" =~ ^[Yy]$ ]]; then
        print_info "Will squash the identified commits and adjust sub-numbering"
        DO_SQUASH=true
    else
        print_info "Keeping all commits separate"
        DO_SQUASH=false
    fi
else
    print_info "No squashing opportunities found (commits modify overlapping lines)"
    DO_SQUASH=false
fi
echo ""

# Create a temporary script for the rebase
REBASE_SCRIPT=$(mktemp)
trap "rm -f $REBASE_SCRIPT" EXIT

# Generate the rebase script
cat > "$REBASE_SCRIPT" << 'EOFSCRIPT'
#!/usr/bin/env bash
# Extract step and substep
STEP=$(echo "$1" | sed 's/.*ai: \[\([0-9]*\)\].*/\1/' | sed 's/^0*//')
SUBSTEP=$(echo "$1" | sed 's/.*(\([0-9]*\)\/.*/\1/')
TOTAL="TOTAL_PLACEHOLDER"

# Use override substep if provided (for renumbering after squash)
if [ -n "$SUBSTEP_OVERRIDE" ]; then
    SUBSTEP="$SUBSTEP_OVERRIDE"
fi

# Extract current message (everything between ] and ()
CURRENT_MSG=$(echo "$1" | sed 's/.*\] \(.*\) (.*/\1/')

# Use batch message from environment variable if provided, otherwise check individual message
if [ -n "$BATCH_MSG_ENV" ]; then
    NEW_MSG="$BATCH_MSG_ENV"
elif echo "$CURRENT_MSG" | grep -qE "^running[.…]+$"; then
    # Still default, keep it
    NEW_MSG="running…"
else
    # Keep existing non-default message
    NEW_MSG="$CURRENT_MSG"
fi

# Build the full commit message (without prefix)
PADDED_STEP=$(printf "%03d" "$STEP")
FULL_MSG="✨ ai: [$PADDED_STEP] $NEW_MSG ($SUBSTEP/$TOTAL)"
if [ -n "$COMMIT_PREFIX" ]; then
    case "$FULL_MSG" in
        "$COMMIT_PREFIX"*) echo "$FULL_MSG" ;;
        *) echo "$COMMIT_PREFIX$FULL_MSG" ;;
    esac
else
    echo "$FULL_MSG"
fi
EOFSCRIPT

# Replace placeholders
# Adjust total if squashing
if [ "$DO_SQUASH" = true ]; then
    ADJUSTED_TOTAL=$((COMMIT_COUNT - ${#SQUASH_COMMITS[@]}))
    sed -i.bak "s/TOTAL_PLACEHOLDER/$ADJUSTED_TOTAL/g" "$REBASE_SCRIPT"
else
    sed -i.bak "s/TOTAL_PLACEHOLDER/$COMMIT_COUNT/g" "$REBASE_SCRIPT"
fi

rm -f "$REBASE_SCRIPT.bak"

chmod +x "$REBASE_SCRIPT"

# Create a script for updating query/error commits
QUERY_ERROR_SCRIPT=$(mktemp)
trap "rm -f $COMMITS_TO_MODIFY $REBASE_SCRIPT $QUERY_ERROR_SCRIPT" EXIT

cat > "$QUERY_ERROR_SCRIPT" << 'EOFSCRIPT'
#!/usr/bin/env bash
# Append message to query/error commit

# Get the current commit message
CURRENT_MSG="$1"

# Check if batch message is provided
if [ -n "$BATCH_MSG_ENV" ]; then
    # Append ": message" to the existing query/error commit
    NEW_MSG="${CURRENT_MSG}: ${BATCH_MSG_ENV}"
else
    # No batch message, keep as-is but ensure prefix is correct
    NEW_MSG="$CURRENT_MSG"
fi
# Build the full commit message (without prefix)
FULL_MSG="$NEW_MSG"
if [ -n "$COMMIT_PREFIX" ]; then
    case "$FULL_MSG" in
        "$COMMIT_PREFIX"*) echo "$FULL_MSG" ;;
        *) echo "$COMMIT_PREFIX$FULL_MSG" ;;
    esac
else
    echo "$FULL_MSG"
fi
EOFSCRIPT

chmod +x "$QUERY_ERROR_SCRIPT"

# Replace COMMIT_PREFIX_PLACEHOLDER in query/error script
ESCAPED_PREFIX=$(echo "$COMMIT_PREFIX" | sed 's/[\/&]/\\&/g')
sed -i.bak "s/COMMIT_PREFIX_PLACEHOLDER/$ESCAPED_PREFIX/g" "$QUERY_ERROR_SCRIPT"
rm -f "$QUERY_ERROR_SCRIPT.bak"

# Find the parent commit (the commit before the first AI commit in this batch)
# If there's a query/error commit, start from before that
if [ -n "$QUERY_ERROR_COMMIT" ]; then
    REBASE_PARENT=$(git rev-parse "$QUERY_ERROR_COMMIT^" 2>/dev/null)
    if [ -z "$REBASE_PARENT" ]; then
        print_error "Could not find parent commit for $QUERY_ERROR_COMMIT. Aborting."
        exit 1
    fi
else
    FIRST_COMMIT="${COMMIT_HASHES[0]}"
    if [ -z "$FIRST_COMMIT" ]; then
        print_error "Could not find the first commit for step [$PADDED_STEP]. Aborting."
        exit 1
    fi
    REBASE_PARENT=$(git rev-parse "$FIRST_COMMIT^" 2>/dev/null)
    if [ -z "$REBASE_PARENT" ]; then
        print_error "Could not find parent commit for $FIRST_COMMIT. Aborting."
        exit 1
    fi
fi

# Create a set of commits to modify (for fast lookup)
COMMITS_TO_MODIFY=$(mktemp)
trap "rm -f $COMMITS_TO_MODIFY $REBASE_SCRIPT $QUERY_ERROR_SCRIPT" EXIT

# Add all commits from our batch
for commit_hash in "${COMMIT_HASHES[@]}"; do
    echo "$commit_hash" >> "$COMMITS_TO_MODIFY"
done

# Add query/error commit to the list if it exists
if [ -n "$QUERY_ERROR_COMMIT" ]; then
    echo "$QUERY_ERROR_COMMIT" >> "$COMMITS_TO_MODIFY"
fi

# Create rebase editor script that modifies only our AI commits
REBASE_EDITOR=$(mktemp)
SQUASH_MAP=$(mktemp)
trap "rm -f $COMMITS_TO_MODIFY $REBASE_SCRIPT $QUERY_ERROR_SCRIPT $REBASE_EDITOR $SQUASH_MAP" EXIT

# Build squash map if needed
if [ "$DO_SQUASH" = true ]; then
    # Create a map of which commits to squash
    for pair in "${SQUASH_COMMITS[@]}"; do
        idx1=$(echo "$pair" | cut -d: -f1)
        idx2=$(echo "$pair" | cut -d: -f2)
        echo "${COMMIT_HASHES[$idx2]}" >> "$SQUASH_MAP"
    done
fi

cat > "$REBASE_EDITOR" << 'EOF'
#!/usr/bin/env bash
# This script modifies the git rebase todo list
# It adds exec commands only for the AI commits we want to fix
# And optionally marks commits for squashing

TODO_FILE="$1"
TEMP_FILE="${TODO_FILE}.tmp"

> "$TEMP_FILE"

# Track which substep we're on (for renumbering after squash)
current_substep=1

while IFS= read -r line; do
    # Extract commit hash from the line (format: "pick abc123 commit message")
    if [[ "$line" =~ ^pick[[:space:]]+([a-f0-9]+) ]]; then
        commit_hash="${BASH_REMATCH[1]}"

        # Check if this commit should be squashed
        should_squash=false
        if [ "$DO_SQUASH_ENV" = "true" ] && grep -q "^$commit_hash" "$SQUASH_MAP_FILE" 2>/dev/null; then
            should_squash=true
        fi

        # Check if this commit is in our list to modify
        if grep -q "^$commit_hash" "$COMMITS_TO_MODIFY_FILE"; then
            # This is an AI commit we want to fix
            commit_msg=$(git log --format=%s -1 "$commit_hash")

            # Use a unique temp file based on commit hash
            temp_msg_file="/tmp/new_msg_${commit_hash}.txt"

            # Check if this is a query/error commit
            if echo "$commit_msg" | grep -qE "(ai: updated query|ai: updated errors)"; then
                # Query/error commit - use the query/error script to append message
                echo "exec BATCH_MSG_ENV=\"\$BATCH_MSG_ENV\" $QUERY_ERROR_SCRIPT_FILE '$commit_msg' > $temp_msg_file" >> "$TEMP_FILE"
            else
                # Regular AI commit - use the regular script
                # Pass the current substep for renumbering
                echo "exec BATCH_MSG_ENV=\"\$BATCH_MSG_ENV\" SUBSTEP_OVERRIDE=$current_substep $REBASE_SCRIPT_FILE '$commit_msg' > $temp_msg_file" >> "$TEMP_FILE"

                # Only increment substep if not squashing this commit
                if [ "$should_squash" = false ]; then
                    current_substep=$((current_substep + 1))
                fi
            fi

            # Pick or squash
            if [ "$should_squash" = true ]; then
                # Change pick to squash
                echo "squash $commit_hash $(git log --format=%s -1 "$commit_hash")" >> "$TEMP_FILE"
            else
                # Keep the pick
                echo "$line" >> "$TEMP_FILE"
            fi

            # Add exec to amend with new message (only for non-squashed commits)
            if [ "$should_squash" = false ]; then
                echo "exec git commit --amend -m \"\$(cat $temp_msg_file)\" && rm -f $temp_msg_file" >> "$TEMP_FILE"
            else
                # For squashed commits, just clean up the temp file
                echo "exec rm -f $temp_msg_file" >> "$TEMP_FILE"
            fi
        else
            # Not an AI commit, keep as-is
            echo "$line" >> "$TEMP_FILE"
        fi
    else
        # Not a pick line (comment, etc), keep as-is
        echo "$line" >> "$TEMP_FILE"
    fi
done < "$TODO_FILE"

mv "$TEMP_FILE" "$TODO_FILE"
EOF

chmod +x "$REBASE_EDITOR"

# Export variables needed by the rebase editor
export COMMITS_TO_MODIFY_FILE="$COMMITS_TO_MODIFY"
export REBASE_SCRIPT_FILE="$REBASE_SCRIPT"
export QUERY_ERROR_SCRIPT_FILE="$QUERY_ERROR_SCRIPT"
export DO_SQUASH_ENV="$DO_SQUASH"
export SQUASH_MAP_FILE="$SQUASH_MAP"

print_info "Starting interactive rebase..."
echo ""

# Create recovery tag before rebase
CURRENT_HEAD=$(git rev-parse HEAD)
DATE_STR=$(date +%Y-%m-%d_%H-%M-%S)
TIME_STR=$(date +%H%M%S)

# Build recovery tag name from template (always use padded step)
RECOVERY_TAG=$(echo "$RECOVERY_TAG_TEMPLATE" | sed "s/{step}/$PADDED_STEP/g" | sed "s/{date}/$DATE_STR/g" | sed "s/{time}/$TIME_STR/g")

# Create the recovery tag
if git tag "$RECOVERY_TAG" "$CURRENT_HEAD" 2>/dev/null; then
    print_success "Created recovery tag: $RECOVERY_TAG"
    print_info "If something goes wrong, you can recover with: git reset --hard $RECOVERY_TAG"
else
    print_warning "Could not create recovery tag (may already exist): $RECOVERY_TAG"
    exit 2
fi
echo ""

# Export the batch message as an environment variable (preserves all special characters)
export BATCH_MSG_ENV="$BATCH_MESSAGE"

# Create a custom git editor for handling squash commit messages
GIT_EDITOR_WRAPPER="$SCRIPT_DIR/fix-commits-editor-wrapper.sh"
GIT_EDITOR_REAL="$SCRIPT_DIR/fix-commits-editor-real.sh"
chmod +x "$GIT_EDITOR_WRAPPER" "$GIT_EDITOR_REAL"

# Save the current core.editor
ORIGINAL_CORE_EDITOR=$(git config --get core.editor || true)
# Set core.editor to our wrapper
GIT_EDITOR_WRAPPER_ABS=$(cd "$SCRIPT_DIR" && pwd)/fix-commits-editor-wrapper.sh
GIT_EDITOR_REAL_ABS=$(cd "$SCRIPT_DIR" && pwd)/fix-commits-editor-real.sh
export COMMIT_PREFIX="$COMMIT_PREFIX"
git config core.editor "$GIT_EDITOR_WRAPPER_ABS"

# Set up environment for the rebase
export GIT_SEQUENCE_EDITOR="$REBASE_EDITOR"
# (No need to set GIT_EDITOR, core.editor is used)

# Run the rebase
if git rebase -i "$REBASE_PARENT"; then
    print_success "Rebase completed successfully!"
    echo ""
    print_info "Updated commits:"
    git log --oneline --grep="ai: \[$PADDED_STEP\]" --reverse
    echo ""
    print_success "All done! Commits have been fixed."
    echo ""

    # Restore the original core.editor
    if [ -n "$ORIGINAL_CORE_EDITOR" ]; then
        git config core.editor "$ORIGINAL_CORE_EDITOR"
    else
        git config --unset core.editor
    fi

    # Clean up old recovery tags
    print_info "Checking for old recovery tags to clean up..."

    # Get current branch
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

    # Find all tags matching the recovery pattern
    RECOVERY_PATTERN="fix-commits-backup-step-"
    OLD_TAGS=()

    while IFS= read -r tag; do
        if [ -z "$tag" ]; then
            continue
        fi

        # Skip the current recovery tag we just created
        if [ "$tag" = "$RECOVERY_TAG" ]; then
            continue
        fi

        # Check if tag is in the current branch
        if ! git merge-base --is-ancestor "$tag" HEAD 2>/dev/null; then
            # Tag is not in current branch history
            OLD_TAGS+=("$tag")
        fi
    done < <(git tag -l "${RECOVERY_PATTERN}*")

    if [ ${#OLD_TAGS[@]} -gt 0 ]; then
        echo ""
        print_warning "Found ${#OLD_TAGS[@]} old recovery tag(s) not in current branch:"
        for tag in "${OLD_TAGS[@]}"; do
            echo "  - $tag"
        done
        echo ""

        read -p "Would you like to delete these old recovery tags? (y/n) [n]: " DELETE_TAGS
        DELETE_TAGS=${DELETE_TAGS:-n}

        if [[ "$DELETE_TAGS" =~ ^[Yy]$ ]]; then
            for tag in "${OLD_TAGS[@]}"; do
                if git tag -d "$tag" 2>/dev/null; then
                    print_success "Deleted tag: $tag"
                else
                    print_warning "Could not delete tag: $tag"
                fi
            done
            echo ""
            print_success "Old recovery tags cleaned up"
        else
            print_info "Keeping old recovery tags"
            print_info "You can manually delete them later with: git tag -d <tag-name>"
        fi
    else
        print_info "No old recovery tags found to clean up"
    fi

    # Also delete the current recovery tag now that rebase succeeded
    echo ""
    read -p "Delete the recovery tag for this rebase? (y/n) [n]: " DELETE_CURRENT
    DELETE_CURRENT=${DELETE_CURRENT:-n}

    if [[ "$DELETE_CURRENT" =~ ^[Yy]$ ]]; then
        if git tag -d "$RECOVERY_TAG" 2>/dev/null; then
            print_success "Deleted recovery tag: $RECOVERY_TAG"
        fi
    else
        print_info "Keeping recovery tag: $RECOVERY_TAG"
        print_info "Delete it manually when no longer needed: git tag -d $RECOVERY_TAG"
    fi

else
    # Restore the original core.editor on failure as well
    if [ -n "$ORIGINAL_CORE_EDITOR" ]; then
        git config core.editor "$ORIGINAL_CORE_EDITOR"
    else
        git config --unset core.editor
    fi
    print_error "Rebase failed or was aborted"
    print_info "You can continue with: git rebase --continue"
    print_info "Or abort with: git rebase --abort"
    print_info "To recover to the state before rebase: git reset --hard $RECOVERY_TAG"
    exit 1
fi

