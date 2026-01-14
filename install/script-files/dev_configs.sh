# PyEnv Configurations.
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# NVM Configurations
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi

# Git Configurations
# Check if ssh-agent is already running
if [ -z "$SSH_AUTH_SOCK" ]; then
   eval "$(ssh-agent -s)" > /dev/null
else
   # Optional: Check if the agent is actually responsive
   ssh-add -l > /dev/null 2>&1 || eval "$(ssh-agent -s)" > /dev/null
fi

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"