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

# ==============================================================================
# 2. PAYARA UNPACKING
# ==============================================================================
log_info "Configuring Payara Application Server..."

if [ -d "$HOME/Dev/tools/payara5" ]; then
    log_info "Payara already installed at: $HOME/Dev/tools/payara5"
else
    # Search for Payara files
    PAYARA_ZIP=$(find /tmp/tools -maxdepth 1 -name "payara*.zip" 2>/dev/null | head -n 1)

    if [ -n "$PAYARA_ZIP" ]; then
        log_info "Unzipping Payara from $PAYARA_ZIP..."
        unzip -q "$PAYARA_ZIP" -d "$HOME/Dev/tools/"

        # Rename directory to a standard name (eases referencing)
        # Find the created directory (any Payara version)
        PAYARA_DIR=$(find "$HOME/Dev/tools" -maxdepth 1 -type d -name "payara*" | head -n 1)
        if [ -n "$PAYARA_DIR" ] && [ "$(basename "$PAYARA_DIR")" != "payara5" ]; then
            mv "$PAYARA_DIR" "$HOME/Dev/tools/payara5"
        fi

        # Make scripts executable
        chmod +x "$HOME/Dev/tools/payara5/bin/"*

        log_info "Payara installed at: $HOME/Dev/tools/payara5"
    else
        log_warning "No Payara file found in /tmp/tools/"
        log_info "ACTION: Place the payara-5*.zip file in install/tools/ and Rebuild Container"
    fi
fi

# ==============================================================================
# 3. CUSTOM SCRIPTS COPY
# ==============================================================================
log_info "Copying custom scripts..."

if [ -d "/tmp/script-files" ] && [ "$(ls -A /tmp/script-files 2>/dev/null)" ]; then
    # Copy .sh scripts to ~/.local/bin/
    mkdir -p "$HOME/.local/bin"
    find /tmp/script-files -maxdepth 1 -name "*.sh" -exec cp {} "$HOME/.local/bin/" \; 2>/dev/null || true
    chmod +x "$HOME/.local/bin/"*.sh

    # Copy Powerlevel10k configuration
    if [ -f "/tmp/script-files/userConfigs/.p10k.zsh" ]; then
        cp /tmp/script-files/userConfigs/.p10k.zsh "$HOME/.p10k.zsh"
        log_info "Powerlevel10k configuration copied"
    fi

    # Copy .zshrc configuration if it exists (overwrites Dockerfile's)
    if [ -f "/tmp/script-files/userConfigs/.zshrc" ]; then
        cp /tmp/script-files/userConfigs/.zshrc "$HOME/.zshrc"
        log_info "Custom .zshrc configuration copied"
    fi

    log_info "Scripts copied to ~/.local/bin/"

    # Execute initialization scripts if they exist
    if [ -f "$HOME/.local/bin/init-environment.sh" ]; then
        log_info "Executing environment initialization script..."
        bash "$HOME/.local/bin/init-environment.sh"
    fi
else
    log_info "No scripts found in install/script-files (optional)"
fi

# ==============================================================================
# 4. SSH CONFIGURATION
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
# 5. FINAL CONFIGURATION
# ==============================================================================
log_info "Creating welcome file..."

cat > "$HOME/.welcome" << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🚀 DevEnv Development Environment                          ║
║                                                              ║
║     Containerized development environment ready!             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
📋 Useful Commands:
   env-info         - Displays environment information
   use-java <ver>   - Switches Java version (8 or 11)

   payara-start     - Starts Payara Server
   payara-stop      - Stops Payara Server
   payara-admin     - Displays Admin Console URL

   cdDevEnv         - Go to project directory
   cdtools          - Go to tools directory

   mvnci            - Maven clean install
   mvncs            - Maven clean install (sem testes)

📦 Additional Installations:
   Node.js: Install via scripts in install/script-files/
   Python:  Install via scripts in install/script-files/

EOF

# Add welcome message display to .zshrc
echo "" >> "$HOME/.zshrc"
echo "# Welcome message" >> "$HOME/.zshrc"
echo "cat ~/.welcome" >> "$HOME/.zshrc"

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
