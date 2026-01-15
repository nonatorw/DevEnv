#!/bin/bash

# ==============================================================================
# Post-Create Script - DevEnv Project
# ==============================================================================
# This script is automatically executed after container creation.
# It performs final configurations and file copying.
# ==============================================================================
# NOTE: SDKMan, NVM, PyEnv, and Java have already been installed in the Dockerfile.
# ==============================================================================

set -e  # Stop execution on error

echo "=========================================="
echo "🚀 Starting final configuration for DevEnv environment"
echo "=========================================="

# ==============================================================================
# HELPER FUNCTION: Display formatted messages
# ==============================================================================
log_info() {
    echo -e "\n✅ $1\n"
}

log_error() {
    echo -e "\n❌ ERROR: $1\n"
}

log_warning() {
    echo -e "\n⚠️ WARNING: $1\n"
}

# ==============================================================================
# 1. INSTALLED TOOLS VERIFICATION
# ==============================================================================
log_info "Verifying installed tools..."

# Load SDKMan
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Verify Java
if command -v java &> /dev/null; then
    log_info "Java installed:"
    java -version
else
    log_error "Java not found! Check the Dockerfile."
fi

# Verify Maven
if command -v mvn &> /dev/null; then
    log_info "Maven installed:"
    mvn -version | head -n 1
else
    log_error "Maven not found! Check the Dockerfile."
fi

# Verify NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    log_info "NVM installed (Node.js will be installed via scripts in install/script-files)"
else
    log_error "NVM not found! Check the Dockerfile."
fi

# Verify PyEnv
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
    log_info "PyEnv installed (Python will be installed via scripts in install/script-files)"
else
    log_error "PyEnv not found! Check the Dockerfile."
fi

# Verify Unzip (Required for Payara)
if command -v unzip &> /dev/null; then
    log_info "Unzip installed"
else
    log_error "Unzip not found! Please install 'unzip' in the Dockerfile."
fi

# ==============================================================================
# 2. CUSTOM SCRIPTS EXECUTION
# ==============================================================================
log_info "Checking for custom scripts execution..."

# Execute initialization scripts if they exist
if [ -f "$HOME/.local/bin/init-environment.sh" ]; then
    log_info "Executing environment initialization script..."
    bash "$HOME/.local/bin/init-environment.sh"
fi

# ==============================================================================
# 3. SSH CONFIGURATION
# ==============================================================================
log_info "Configuring SSH..."

if [ -d "/tmp/ssh-files" ] && [ "$(ls -A /tmp/ssh-files 2>/dev/null)" ]; then
    # Copy SSH files
    cp -r /tmp/ssh-files/* "$HOME/.ssh/" 2>/dev/null || true

    # Adjust permissions (critical for SSH)
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/"* 2>/dev/null || true
    chmod 644 "$HOME/.ssh/"*.pub 2>/dev/null || true

    log_info "SSH files configured"
else
    log_info "No SSH files found in install/ssh-files (optional)"
fi

# ==============================================================================
# 4. FINAL CONFIGURATION
# ==============================================================================
log_info "Creating welcome file..."

cat > "$HOME/.welcome" << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🚀 DevEnv Development Environment                       ║
║                                                              ║
║     Containerized development environment ready!             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
📋 Useful Commands:
   <your-command>   - Description of your command

📦 Additional Installations:
   Node.js: Install via scripts in install/script-files/
   Python:  Install via scripts in install/script-files/

EOF

# Add welcome message display to .zshrc
if ! grep -q "cat ~/.welcome" "$HOME/.zshrc"; then
    echo "" >> "$HOME/.zshrc"
    echo "# Welcome message" >> "$HOME/.zshrc"
    echo "cat ~/.welcome" >> "$HOME/.zshrc"
fi

# ==============================================================================
# FINALIZATION
# ==============================================================================
echo ""
echo "=========================================="
echo "✅ Configuration successfully completed!"
echo "=========================================="
echo ""
echo "ℹ️  Tools installed in Dockerfile:"
echo "   ✅ Java 8 and 11 (via SDKMan)"
echo "   ✅ Maven (via SDKMan)"
echo "   ✅ NVM (Node.js manager)"
echo "   ✅ PyEnv (Python manager)"
echo ""
echo "ℹ️  Additional Installations:"
echo "   📝 Node.js: Configure via install/script-files/"
echo "   📝 Python:  Configure via install/script-files/"
echo ""
echo "▶️  To view environment info: env-info"
echo ""
