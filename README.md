# DevEnv Development Environment

![SDKMan](https://img.shields.io/badge/SDKMan!-232F3E?logo=sdkman&logoColor=white)
![Java](https://img.shields.io/badge/java-%23ED8B00.svg?logo=openjdk&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-C71A36?logo=apachemaven&logoColor=white)
![PyEnv](https://img.shields.io/badge/PyEnv-232F3E?logo=python&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?&logo=python&logoColor=ffdd54)
![NVM](https://img.shields.io/badge/NVM-232F3E?&logo=node.js&logoColor=white)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?&logo=node.js&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?&logo=docker&logoColor=white)
![Podman](https://img.shields.io/badge/Podman-892CA0?&logo=podman&logoColor=white)
![VS Code](https://img.shields.io/badge/VSCode-0078d7.svg?&logo=vscodium&logoColor=white)
![IntelliJ IDEA](https://img.shields.io/badge/IntelliJIDEA-000000.svg?&logo=intellij-idea&logoColor=white)
![Payara](https://img.shields.io/badge/Payara%20Server-004481?&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh%20+%20OMZ%20+%20Powerlevel10k-%23D0C6E8.svg?&logo=zsh&logoColor=black)

-------------------------


DevEnv is a containerized development environment designed to provide a consistent and reproducible workspace for Java, Python, and Node.js development. It leverages the Dev Container specification to ensure seamless integration with VS Code and IntelliJ IDEA.

## Features

* **Java:** Pre-installed Java 8 and 11 (managed via SDKMan).
* **Build Tools:** Maven and Gradle.
* **Node.js:** NVM installed for managing Node.js versions.
* **Python:** PyEnv installed for managing Python versions.
* **Application Server:** Automated setup for Payara Server 5.
* **Shell:** Zsh with Oh My Zsh and Powerlevel10k theme.
* **Persistence:** Docker volumes for workspace and tool persistence.

## Prerequisites

* [Docker](https://www.docker.com/) or [Podman](https://podman.io/) installed on your host machine.
* [VS Code](https://code.visualstudio.com/) with the "Dev Containers" extension OR [IntelliJ IDEA](https://www.jetbrains.com/idea/).

## Getting Started

### Installation

1. To a better experience, you should:
    * Download [Nerd Fonts - Meslo](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip) and add the package at `install\script-files\fonts\`
    * Download Payara Server and add the package at `install\tools\`

2. Clone this repository:

> ```bash
> git clone <repository-url>
> cd DevEnv
> ```

3. Open the folder in VS Code:

> ```bash
>     code .
> ```

4. When prompted, click **"Reopen in Container"**.

### Directory Structure

```text
 ./
├──  .devcontainer/
│  ├──  devcontainer.json
│  ├──  Dockerfile
│  └──  post-create.sh
├──  docs/
├──  install/
│  ├──  script-files/
│  │  ├──  fonts/
│  │  │  ├──  Meslo.zip            --> This should be provided by user!
│  │  │  └──  README.md
│  │  ├──  userConfigs/
│  │  │  ├──  .p10k.zsh
│  │  │  └── 󱆃 .zshrc
│  │  ├──  aliases.sh
│  │  ├──  dev_configs.sh
│  │  ├──  functions.sh
│  │  └──  init-environment.sh
│  ├──  ssh-files/
│  │  └──  config.example
│  └──  tools/
│     ├──  payara5.zip            --> This should be provided by user, too!
│     └──  README.md
├──  .gitignore
├──  LICENSE
└──  README.md
```

### Customizing the Environment

To install specific versions of Node.js or Python, edit the file:
`install/script-files/init-environment.sh`

Uncomment the relevant lines and rebuild the container.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.

## Authoring

This project follows the Dev Container Specification.

* **Metadata:** Defined in `.devcontainer/devcontainer.json`.
* **Lifecycle:** Uses `postCreateCommand` for environment setup.
* **User Permissions:** Configured for rootless execution (Podman compatible).