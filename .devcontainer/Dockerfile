# ==============================================================================
# DevContainer para Projeto DevEnv
# Base: Ubuntu 24.04 LTS
# ==============================================================================
FROM ubuntu:24.04

# Evita prompts interativos durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# ==============================================================================
# ARGUMENTOS DE BUILD - Personalizáveis durante o build
# ==============================================================================
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# ==============================================================================
# VARIÁVEIS DE AMBIENTE GLOBAIS
# ==============================================================================
ENV HOME=/home/${USERNAME}
ENV SDKMAN_DIR=${HOME}/.sdkman
ENV NVM_DIR=${HOME}/.nvm
ENV PYENV_ROOT=${HOME}/.pyenv
ENV PATH="${HOME}/.local/bin:${PYENV_ROOT}/bin:${PATH}"

# ==============================================================================
# ETAPA 1: Atualização do Sistema e Pacotes Essenciais
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

# Gera locales para evitar problemas de encoding
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ==============================================================================
# ETAPA 2: Configuração do Usuário
# ==============================================================================
# Cria o grupo se não existir
RUN groupadd --gid $USER_GID $USERNAME || true

# Cria o usuário se não existir
RUN useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME || true

# Adiciona o usuário ao grupo sudo
RUN echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    usermod -aG sudo $USERNAME || true

# ==============================================================================
# ETAPA 3: Estrutura de Diretórios do Projeto
# ==============================================================================
USER $USERNAME
WORKDIR $HOME

# Cria a estrutura de diretórios
# NOTA: ~/Dev será montado como volume Docker (persiste entre rebuilds)
RUN mkdir -p ${HOME}/.local/bin && \
    mkdir -p ${HOME}/.ssh       && \
    mkdir -p ${HOME}/.m2        && \
    mkdir -p ${HOME}/Dev/.m2    && \
    mkdir -p ${HOME}/Dev/tools  && \
    mkdir -p ${HOME}/Dev/repos

# O volume Docker 'DevEnv-dev-home' será montado em ~/Dev
# Isso garante que TUDO em ~/Dev persiste entre rebuilds

# ==============================================================================
# ETAPA 4: Instalação do Payara (Incorporado na Imagem)
# ==============================================================================
COPY --chown=${USERNAME}:${USERNAME} install/tools/payara*.zip ${HOME}/temp/
RUN unzip -q ${HOME}/temp/payara*.zip -d ${HOME}/Dev/tools/ && \
    DIR=$(find ${HOME}/Dev/tools -maxdepth 1 -type d -name "payara*" | grep -v "payara5" | head -n 1) && \
    if [ -n "$DIR" ]; then mv "$DIR" "${HOME}/Dev/tools/payara5"; fi && \
    chmod +x ${HOME}/Dev/tools/payara5/bin/* && \
    rm -rf ${HOME}/temp/payara*.zip

# ==============================================================================
# ETAPA 5: Instalação de Fontes para Powerlevel10k
# ==============================================================================
# Cria diretório de fontes e copia as fontes do Meslo
RUN mkdir -p ${HOME}/temp
COPY --chown=${USERNAME}:${USERNAME} install/script-files/fonts/Meslo.zip ${HOME}/temp

# Descompacta e instala as fontes
RUN mkdir -p ${HOME}/.local/share/fonts/meslo && \
    unzip -q ${HOME}/temp/Meslo.zip -d ${HOME}/.local/share/fonts/meslo && \
    fc-cache -f -v && \
    rm -rf ${HOME}/temp

# ==============================================================================
# ETAPA 6: Instalação do Oh-My-Zsh, Powerlebel10k e Plugins do Oh-My-Zsh
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
# ETAPA 7: Instalação dos SDK Managers (POR ÚLTIMO)
# ==============================================================================
# NOTA: SDKMan, PyEnv e NVM são instalados por último conforme especificado
# Suas configurações específicas virão dos scripts em install/script-files/

# Instala SDKMan
RUN curl -s "https://get.sdkman.io" | bash

# Instala PyEnv (Python version manager)
# NOTA: Versões específicas do Python devem ser instaladas via scripts
RUN curl https://pyenv.run | bash

# Instala NVM (Node Version Manager)
# NOTA: Versões específicas do Node.js devem ser instaladas via scripts
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# ==============================================================================
# ETAPA 8: Instala versões do Java e Maven via SDKMan
# ==============================================================================
# ⚠️ VERSÕES MOCKADAS - EDITE CONFORME NECESSÁRIO
# ==============================================================================
# As versões abaixo são exemplos. Substitua pelas versões específicas do seu projeto.
#
# Para listar versões disponíveis:
#   sdk list java
#   sdk list maven
#
# Formato da versão Java: MAJOR.MINOR.PATCH-VENDOR
#   Exemplos: 8.0.432-tem, 11.0.25-tem, 17.0.9-tem, 21.0.1-tem
#   Vendors: tem (Temurin), amzn (Amazon Corretto), zulu, etc
# ==============================================================================
RUN bash -c "source ${SDKMAN_DIR}/bin/sdkman-init.sh \
             && sdk install java 8.0.472.fx-zulu \
             && sdk install java 11.0.29.fx-zulu \
             && sdk install maven 3.9.9 \
             && sdk default java 11.0.29.fx-zulu \
             && sdk default maven 3.9.9"

# ==============================================================================
# ETAPA 9: Configuração Básica do ZSH
# ==============================================================================
# Copia configurações do ZSH e Scripts de suporte fornecidos

COPY --chown=${USERNAME}:${USERNAME} install/script-files/userConfigs/.zshrc ${HOME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} install/script-files/userConfigs/.p10k.zsh ${HOME}/.p10k.zsh
COPY --chown=${USERNAME}:${USERNAME} install/script-files/*.sh ${HOME}/.local/bin/

# Garante permissão de execução nos scripts
RUN chmod +x ${HOME}/.local/bin/*.sh

# ==============================================================================
# ETAPA 10: Preparação para Scripts e Configurações Personalizadas
# ==============================================================================
# Estes serão copiados via post-create.sh
WORKDIR $HOME

# Define ZSH como shell padrão
ENV SHELL=/bin/zsh

# ==============================================================================
# ETAPA 11: Configuração de Permissões para JetBrains Tools
# ==============================================================================
USER root

# Cria o diretório e ajusta permissões para o IntelliJ IDEA
RUN mkdir -p /.jbdevcontainer/JetBrains/RemoteDev/remote-dev-worker && \
    chown -R $USERNAME:$USERNAME /.jbdevcontainer && \
    chmod -R 755 /.jbdevcontainer

USER $USERNAME

# ==============================================================================
# COMANDO PADRÃO
# ==============================================================================
CMD ["/bin/zsh"]
