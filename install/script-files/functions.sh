function upd-sys() {
  echo -e " "
  echo -e "${COLOR_YELLOW}>>> [sudo] apt update: ${COLOR_RESET}"
  sudo apt update
  echo -e " "
  echo -e "${COLOR_YELLOW}>>> [sudo] apt upgrade: ${COLOR_RESET}"
  sudo apt upgrade -y
}

function cls-sys() {
  echo -e "${COLOR_YELLOW}>>> [sudo] apt autoclean: ${COLOR_RESET}"
  sudo apt autoclean
  echo -e " "
  echo -e "${COLOR_YELLOW}>>> [sudo] apt autoremove: ${COLOR_RESET}"
  sudo apt autoremove -y
}

function upd-omz() {
  echo -e "${COLOR_YELLOW}>>> oh-my-zsh update: ${COLOR_RESET}"
  omz update
}

function UpdateSystem() {
  echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*> Update System Packages --------------------------------------------------*${COLOR_RESET}"
  upd-sys
  echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*> Remove Old Packages -----------------------------------------------------*${COLOR_RESET}"
  cls-sys
  echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*> Update Oh-My-Zsh --------------------------------------------------------*${COLOR_RESET}"
  upd-omz
}

function RunUpdates() {
  cl
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*                         U p d a t e   S y s t e m                         *${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  UpdateSystem
  echo -e " "
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
}


function upd-java-env() {
  echo -e "${COLOR_YELLOW}>>> sdkman upgrade (selfupdate): ${COLOR_RESET}"
  sdk selfupdate && echo -e " "

  echo -e "${COLOR_YELLOW}>>> sdkman update: ${COLOR_RESET}"
  sdk update
}

function upd-python-env() {
  echo -e "${COLOR_YELLOW}>>> pyenv update: ${COLOR_RESET}"
  pyenv update && echo -e " "

  echo -e "${COLOR_YELLOW}>>> pip upgrade: ${COLOR_RESET}"
  pip install --upgrade pip
}

#function upd-node-env() {
#  echo -e "${COLOR_YELLOW}>>> Updating NVM (Node Version Manager)... ${COLOR_RESET}"
#  # Fetches the latest NVM install script and runs it. This is the official update method.
#
#  # 1. Use the GitHub API to find the latest stable release tag.
#  local latest_nvm_version=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .tag_name)
#
#  if [[ -z "$latest_nvm_version" ]]; then
#    # Handle cases where the API call fails (e.g., no internet, rate limiting).
#    echo -e "${COLOR_RED}>>> ERROR: Could not fetch the latest NVM version. Skipping NVM update.${COLOR_RESET}"
#  else
#    echo -e "${COLOR_GREEN}> Latest NVM version found: ${latest_nvm_version}. Proceeding with installation/update...${COLOR_RESET}"
#    # 2. Construct the dynamic URL and execute the installation script.
#    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${latest_nvm_version}/install.sh" | bash &>/dev/null
#  fi
#  echo " "
#
#  # Source nvm to use it in the current shell session immediately after update.
#  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
#  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#
#  echo -e "${COLOR_YELLOW}>>> Checking for Node.js LTS update... ${COLOR_RESET}"
#
#  # Get the currently active Node.js version (e.g., "v18.17.1").
#  local current_node_version=$(nvm current)
#
#  # Extract the major version number (e.g., "18" from "v18.17.1").
#  local major_version=$(echo "$current_node_version" | sed -E 's/v([0-9]+)\..*/\1/')
#
#  local lts_codename=$(nvm ls-remote --lts | grep -E "v${major_version}\." | sed -n 's/.*LTS: \([^)]*\)).*/\1/p' | tr '[:upper:]' '[:lower:]' | head -n 1)
#
#  if [[ -n "$lts_codename" ]]; then
#    # An LTS codename was found, so the current version is an LTS version.
#    echo -e "${COLOR_GREEN}> Current version ${current_node_version} is part of the '${lts_codename}' LTS line. Attempting to update...${COLOR_RESET}"
#
#    local lts_alias="lts/${lts_codename}"
#
#    nvm install "$lts_alias" --reinstall-packages-from=current --latest-npm
#  else
#    echo -e "${COLOR_WHITE}INFO: Current version ${current_node_version} is not an LTS release.${COLOR_RESET}"
#    echo -e "${COLOR_WHITE}This script is designed to only update LTS versions to ensure stability.${COLOR_RESET}"
#    echo -e "${COLOR_WHITE}No action will be taken on Node.js.${COLOR_RESET}"
#  fi
#
#  echo " "
#  echo -e "${COLOR_YELLOW}>>> Updating NPM (Node Package Manager) to the latest version... ${COLOR_RESET}"
#  npm install -g npm@latest
#}

function RunDevUpdates() {
  cl
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*                         U p d a t e   D e v E n v                         *${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*> Update Java Env (SDKMAN) ------------------------------------------------*${COLOR_RESET}"
  upd-java-env
  echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*> Update Python Env (PyEnv) -----------------------------------------------*${COLOR_RESET}"
  upd-python-env
  echo -e " "
  # echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  # echo -e "${COLOR_CYAN}*> Updating Node.js Env (NVM) ----------------------------------------------*${COLOR_RESET}"
  # echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  # upd-node-env
  # echo -e " "
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
}

function get-java-env() {
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*                     J a v a    E n v i r o n m e n t                      *${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>> SDKMan version: ${COLOR_RESET}" && sdk version
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>>> [sdkman] Java: ${COLOR_RESET}" && sdk current java && echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  java --version
  echo -e " "
  javac --version
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>>> [sdkman] Maven: ${COLOR_RESET}" && sdk current maven && echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  mvn -v
  echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>>> [sdkman] Gradle: ${COLOR_RESET}" && sdk current gradle
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  gradle -v
}

function get-python-env() {
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*                    P y t h o n   E n v i r o n m e n t                    *${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>> PyEnv version: ${COLOR_RESET}" && pyenv --version && echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>>> [pyenv] Python Versions: ${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  pyenv versions && echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>>> PIP version: ${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  pip --version
}

function get-node-env() {
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*                   N o d e . j s   E n v i r o n m e n t                   *${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>> NVM version: ${COLOR_RESET}" && nvm --version && echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>>> [nvm] Node.js installed versions: ${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  nvm ls && echo -e " "
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  echo -e "${COLOR_CYAN}>>> [nvm] NPM version (current): ${COLOR_RESET}"
  echo -e "${COLOR_CYAN}*---------------------------------------------------------------------------*${COLOR_RESET}"
  npm --version
}

function GetDevEnv() {
  cl
  get-java-env
  echo -e " "
  get-python-env
  echo -e " "
  echo -e "${COLOR_MAGENTA}*===========================================================================*${COLOR_RESET}"
}

function gig() {
  curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@;
}
