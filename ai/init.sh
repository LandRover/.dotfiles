#!/bin/bash

# Cursor AI Rules Global Configuration Script
# This script configures Cursor to use your AI rules from ~/.dotfiles/ai/ directly
# across all projects and applications.

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Define directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_RULES_DIR="$SCRIPT_DIR"

log "Starting Cursor AI Rules Global Configuration"
log "AI Rules directory: $AI_RULES_DIR"

# Validate AI rules directory exists
if [[ ! -d "$AI_RULES_DIR/rules" ]]; then
    error "AI rules directory $AI_RULES_DIR/rules does not exist!"
    exit 1
fi

# Check if we have any markdown files to process
if ! find "$AI_RULES_DIR" -name "*.md" -type f | head -1 | grep -q .; then
    warning "No markdown files found in $AI_RULES_DIR"
    exit 0
fi

# Create a global .cursorrules file by concatenating all markdown files
log "Creating global .cursorrules file..."

# Remove existing global rules file
rm -f "$HOME/.cursorrules"

# Create header
cat > "$HOME/.cursorrules" << 'EOF'
# Global AI Rules for Cursor
# Auto-generated from ~/.dotfiles/ai/
# 
# These rules apply to all projects unless overridden by project-specific .cursorrules

EOF

# Add all markdown files
file_count=0
find "$AI_RULES_DIR" -name "*.md" -type f | sort | while read -r file; do
    relative_path="${file#$AI_RULES_DIR/}"
    echo "" >> "$HOME/.cursorrules"
    echo "# ============================================" >> "$HOME/.cursorrules"
    echo "# File: $relative_path" >> "$HOME/.cursorrules"
    echo "# ============================================" >> "$HOME/.cursorrules"
    echo "" >> "$HOME/.cursorrules"
    cat "$file" >> "$HOME/.cursorrules"
    echo "" >> "$HOME/.cursorrules"
done

# Count files for reporting
file_count=$(find "$AI_RULES_DIR" -name "*.md" -type f | wc -l)

success "Created global .cursorrules file: $HOME/.cursorrules"
success "Included $file_count AI rule files"

# Set up environment variable in shell profiles
log "Setting up environment variable for AI rules path..."

for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
    if [[ -f "$profile" ]]; then
        # Remove any existing CURSOR_AI_RULES_PATH
        if grep -q "CURSOR_AI_RULES_PATH" "$profile" 2>/dev/null; then
            sed -i '/CURSOR_AI_RULES_PATH/d' "$profile"
        fi
        
        # Add new environment variable
        echo "" >> "$profile"
        echo "# Cursor AI Rules Configuration - Auto-generated" >> "$profile"
        echo "export CURSOR_AI_RULES_PATH=\"$AI_RULES_DIR\"" >> "$profile"
        
        success "Updated $profile with AI rules path"
    fi
done

# Create a simple reference file
log "Creating reference file..."
cat > "$AI_RULES_DIR/CURSOR_SETUP.md" << EOF
# Cursor AI Rules Setup

This directory has been configured for global use with Cursor IDE.

## What was configured:

1. **Global Rules File**: \`$HOME/.cursorrules\`
   - Contains all your AI rules from this directory
   - Applied to all Cursor projects globally
   - Can be overridden by project-specific .cursorrules files

2. **Environment Variable**: \`CURSOR_AI_RULES_PATH\`
   - Set to: \`$AI_RULES_DIR\`
   - Available in your shell profiles

3. **Files Included**: $file_count markdown files

## Usage:

- Your AI rules are now active globally in Cursor
- Edit any .md file in this directory and re-run \`./init.sh\` to update
- Project-specific .cursorrules files will override these global rules

## Last Updated:
$(date)

## Files Processed:
$(find "$AI_RULES_DIR" -name "*.md" -type f | sort | sed 's|'"$AI_RULES_DIR"'/||')
EOF

success "Created setup reference: $AI_RULES_DIR/CURSOR_SETUP.md"

# Verify the setup
log "Verifying setup..."
if [[ -f "$HOME/.cursorrules" ]]; then
    rules_size=$(wc -c < "$HOME/.cursorrules")
    success "Global rules file created successfully ($rules_size bytes)"
else
    error "Failed to create global rules file"
    exit 1
fi

# Final instructions
echo ""
log "Configuration complete! Your AI rules are now globally available in Cursor."
echo ""
echo -e "${BLUE}What was configured:${NC}"
echo "1. ✅ Global .cursorrules file: $HOME/.cursorrules"
echo "2. ✅ Environment variable CURSOR_AI_RULES_PATH in shell profiles"
echo "3. ✅ Reference file: $AI_RULES_DIR/CURSOR_SETUP.md"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. 🔄 Restart your terminal (to load environment variable)"
echo "2. 🔄 Restart Cursor (to load new global rules)"
echo "3. ✨ Your AI rules are now active globally!"
echo ""
echo -e "${BLUE}To update rules:${NC}"
echo "- Edit any .md file in: $AI_RULES_DIR"
echo "- Re-run: $AI_RULES_DIR/init.sh"
echo ""
echo -e "${BLUE}Troubleshooting:${NC}"
echo "- View global rules: cat $HOME/.cursorrules"
echo "- Check environment: echo \$CURSOR_AI_RULES_PATH"
echo "- Check setup: cat $AI_RULES_DIR/CURSOR_SETUP.md"
echo ""
success "Setup completed successfully! 🎉 ($file_count files configured)"