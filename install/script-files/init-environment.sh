#!/bin/bash

# ==============================================================================
# Environment Initialization Script - Example
# ==============================================================================
# This script is automatically executed by post-create.sh if it exists.
# Use it to install Node.js, Python, or other specific configurations.
# ==============================================================================

set -e

echo "=========================================="
echo "🔧 Initializing custom environment"
echo "=========================================="

# ==============================================================================
# 1. NODE.JS INSTALLATION (via NVM)
# ==============================================================================
echo "📦 Installing Node.js..."

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Install Node.js LTS version
# Uncomment and adjust version as needed
# nvm install --lts
# nvm use --lts
# nvm alias default 'lts/*'

# Or install a specific version:
# nvm install 20.11.0
# nvm use 20.11.0
# nvm alias default 20.11.0

echo "⚠️  Node.js not installed (uncomment lines above to install)"

# ==============================================================================
# 2. PYTHON INSTALLATION (via PyEnv)
# ==============================================================================
echo "📦 Installing Python..."

# Load PyEnv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Install a specific Python version
# Uncomment and adjust version as needed
# pyenv install 3.12.1
# pyenv global 3.12.1

# Or install multiple versions:
# pyenv install 3.11.7
# pyenv install 3.12.1
# pyenv global 3.12.1

echo "⚠️  Python not installed (uncomment lines above to install)"

# ==============================================================================
# 3. ADDITIONAL PACKAGE INSTALLATIONS
# ==============================================================================
echo "📦 Installing additional packages..."

# Example: Install global Python packages
# pip install --upgrade pip
# pip install requests pytest black flake8

# Example: Install global Node.js packages
# npm install -g typescript ts-node eslint

echo "ℹ️  No additional packages configured"

# ==============================================================================
# 4. CUSTOM CONFIGURATIONS
# ==============================================================================
echo "⚙️  Applying custom configurations..."

# Add your specific configurations here
# Examples:
# - Configure environment variables
# - Create additional aliases
# - Configure specific tools

# Example: Add variable to .zshrc_ref
# echo 'export MY_VAR="value"' >> ~/.zshrc_ref

echo "✅ Custom configurations applied"

# ==============================================================================
# FINALIZATION
# ==============================================================================
echo "=========================================="
echo "✅ Custom initialization completed!"
echo "=========================================="
echo ""
echo "ℹ️  To install Node.js or Python:"
echo "   1. Edit this file: install/script-files/init-environment.sh"
echo "   2. Uncomment the installation lines"
echo "   3. Rebuild the container"
echo ""
