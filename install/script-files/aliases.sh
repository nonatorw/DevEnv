#!/bin/bash

# Aliases
alias home-config="code ~"              # Opens the user's home folder in VSCode.
alias omz-config="code ~/.oh-my-zsh"    # Opens the Oh-My-Zsh configuration file in VSCode.
alias omz-source="source ~/.oh-my-zsh"  # Applies changes to the Oh-My-Zsh configuration file.
alias zsh-config="code ~/.zshrc"        # Opens the Zsh session configuration file in VSCode.
alias zsh-source="source ~/.zshrc"      # Applies changes to the Zsh session configuration file.

alias cls="clear"                       # Clears the screen.
alias cl="clear"                        # Clears the screen.

if command -v eza &> /dev/null; then
    alias ll="eza -laghHUm --all --classify=always --git --git-repos --group-directories-first --hyperlink --icons=always --time-style=long-iso"
    alias tree="eza -laghH --classify=always --git --git-repos --group-directories-first --hyperlink --icons=always --time-style=long-iso --tree --level=2"
    alias ltree="eza -laghH --classify=always --git --git-repos --group-directories-first --hyperlink --icons=always --time-style=long-iso --tree -L"
else
    alias ll="ls -lah"
    alias tree="ls -R"
    # ltree not available with standard ls
fi

COLOR_BLACK=$(tput setaf 0 2>/dev/null || echo "")
COLOR_RED=$(tput setaf 1 2>/dev/null || echo "")
COLOR_GREEN=$(tput setaf 2 2>/dev/null || echo "")
COLOR_YELLOW=$(tput setaf 3 2>/dev/null || echo "")
COLOR_BLUE=$(tput setaf 4 2>/dev/null || echo "")
COLOR_MAGENTA=$(tput setaf 5 2>/dev/null || echo "")
COLOR_CYAN=$(tput setaf 6 2>/dev/null || echo "")
COLOR_WHITE=$(tput setaf 7 2>/dev/null || echo "")
COLOR_RESET=$(tput sgr0 2>/dev/null || echo "")
