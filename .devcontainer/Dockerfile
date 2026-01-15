# ==============================================================================
# DevContainer for DevEnv Project
# Base: Ubuntu 24.04 LTS
# ==============================================================================
FROM ubuntu:24.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# ==============================================================================
# BUILD ARGUMENTS - Customizable during build
# ==============================================================================
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# ==============================================================================
# GLOBAL ENVIRONMENT VARIABLES
# ==============================================================================
ENV HOME=/home/${USERNAME}
ENV SDKMAN_DIR=${HOME}/.sdkman
ENV NVM_DIR=${HOME}/.nvm
ENV PYENV_ROOT=${HOME}/.pyenv
ENV PATH="${HOME}/.local/bin:${PYENV_ROOT}/bin:${PATH}"

# ==============================================================================
# STEP 1: System Update and Essential Packages
# ==============================================================================
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    eza \
    locales \
    fontconfig \
    git \
    gpg \
    htop \
    iputils-ping \
    jq \
    libbz2-dev \
    libffi-dev \
    libgtk-3-0 \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libxtst6 \
    libxxf86vm1 \
    llvm \
    nano \
    net-tools \
    sudo \
    tk-dev \
    tree \
    unzip \
    vim \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
    zsh \
    zsh-doc && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Generate locales to avoid encoding problems
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ==============================================================================
# STEP 2: User Configuration
# ==============================================================================
# Create group if it doesn't exist
RUN groupadd --gid $USER_GID $USERNAME || true

# Create user if it doesn't exist
RUN useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME || true

# Add user to sudo group
RUN echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    usermod -aG sudo $USERNAME || true

# ==============================================================================
# STEP 3: Project Directory Structure
# ==============================================================================
USER $USERNAME
WORKDIR $HOME

# Create directory structure
# NOTE: ~/Dev will be mounted as a Docker volume (persists between rebuilds)
RUN mkdir -p ${HOME}/.local/bin && \
    mkdir -p ${HOME}/.ssh       && \
    mkdir -p ${HOME}/.m2        && \
    mkdir -p ${HOME}/Dev/.m2    && \
    mkdir -p ${HOME}/Dev/tools  && \
    mkdir -p ${HOME}/Dev/repos

# The Docker volume 'DevEnv-dev-home' will be mounted at ~/Dev
# This ensures EVERYTHING in ~/Dev persists between rebuilds

# ==============================================================================
# STEP 4: Payara Installation (Embedded in Image)
# ==============================================================================
COPY --chown=${USERNAME}:${USERNAME} install/tools/payara*.zip ${HOME}/temp/
RUN unzip -q ${HOME}/temp/payara*.zip -d ${HOME}/Dev/tools/ && \
    DIR=$(find ${HOME}/Dev/tools -maxdepth 1 -type d -name "payara*" | grep -v "payara5" | head -n 1) && \
    if [ -n "$DIR" ]; then mv "$DIR" "${HOME}/Dev/tools/payara5"; fi && \
    chmod +x ${HOME}/Dev/tools/payara5/bin/* && \
    rm -rf ${HOME}/temp/payara*.zip

# ==============================================================================
# STEP 5: Font Installation for Powerlevel10k
# ==============================================================================
# Create font directory and copy Meslo fonts
RUN mkdir -p ${HOME}/temp
COPY --chown=${USERNAME}:${USERNAME} install/script-files/fonts/Meslo.zip ${HOME}/temp

# Unzip and install fonts
RUN mkdir -p ${HOME}/.local/share/fonts/meslo && \
    unzip -q ${HOME}/temp/Meslo.zip -d ${HOME}/.local/share/fonts/meslo && \
    fc-cache -f -v && \
    rm -rf ${HOME}/temp

# ==============================================================================
# STEP 6: Install Oh-My-Zsh, Powerlevel10k and Oh-My-Zsh Plugins
# ==============================================================================
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

RUN git clone https://github.com/zsh-users/zsh-autosuggestions  \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

RUN git clone https://github.com/zsh-users/zsh-history-substring-search  \
     "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git  \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

RUN git clone https://github.com/agkozak/zsh-z  \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-z"
# ==============================================================================
# STEP 7: Install SDK Managers (LAST)
# ==============================================================================
# NOTE: SDKMan, PyEnv, and NVM are installed last as specified
# Their specific configurations will come from scripts in install/script-files/

# Install SDKMan
RUN curl -s "https://get.sdkman.io" | bash

# Install PyEnv (Python version manager)
# NOTE: Specific Python versions must be installed via scripts
RUN curl https://pyenv.run | bash

# Install NVM (Node Version Manager)
# NOTE: Specific Node.js versions must be installed via scripts
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# ==============================================================================
# STEP 8: Install Java and Maven versions via SDKMan
# ==============================================================================
# ⚠️ MOCKED VERSIONS - EDIT AS NEEDED
# ==============================================================================
# The versions below are examples. Replace with specific versions for your project.
#
# To list available versions:
#   sdk list java
#   sdk list maven
#
# Java version format: MAJOR.MINOR.PATCH-VENDOR
#   Examples: 8.0.432-tem, 11.0.25-tem, 17.0.9-tem, 21.0.1-tem
#   Vendors: tem (Temurin), amzn (Amazon Corretto), zulu, etc
# ==============================================================================
RUN bash -c "source ${SDKMAN_DIR}/bin/sdkman-init.sh \
             && sdk install java 8.0.472.fx-zulu \
             && sdk install java 11.0.29.fx-zulu \
             && sdk install maven 3.9.9 \
             && sdk default java 11.0.29.fx-zulu \
             && sdk default maven 3.9.9"

# ==============================================================================
# STEP 9: Basic ZSH Configuration
# ==============================================================================
# Copy ZSH configurations and provided support scripts

COPY --chown=${USERNAME}:${USERNAME} install/script-files/userConfigs/.zshrc ${HOME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} install/script-files/userConfigs/.p10k.zsh ${HOME}/.p10k.zsh
COPY --chown=${USERNAME}:${USERNAME} install/script-files/*.sh ${HOME}/.local/bin/

# Ensure execution permissions on scripts
RUN chmod +x ${HOME}/.local/bin/*.sh

# ==============================================================================
# STEP 10: Preparation for Custom Scripts and Configurations
# ==============================================================================
# These will be copied via post-create.sh
WORKDIR $HOME

# Set ZSH as default shell
ENV SHELL=/bin/zsh

# ==============================================================================
# STEP 11: Permissions Configuration for JetBrains Tools
# ==============================================================================
USER root

# Create directory and adjust permissions for IntelliJ IDEA
RUN mkdir -p /.jbdevcontainer/JetBrains/RemoteDev/remote-dev-worker && \
    chown -R $USERNAME:$USERNAME /.jbdevcontainer && \
    chmod -R 755 /.jbdevcontainer

USER $USERNAME

# ==============================================================================
# DEFAULT COMMAND
# ==============================================================================
CMD ["/bin/zsh"]
