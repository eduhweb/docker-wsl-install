# Docker WSL Install Script (`docker-wsl-install.sh`)

This script automates the installation, reinstallation, or uninstallation of Docker in **WSL2** (Windows Subsystem for Linux 2). It simplifies managing Docker services, installing Docker Compose, and handling Docker configurations specifically for WSL2 environments.

## Features

- Install or uninstall Docker and its dependencies.
- Option to reinstall Docker from scratch, removing all data and configurations.
- Install Docker Compose if not already installed.
- Adds the current user to the Docker group for running Docker without `sudo`.

## Quick Installation

You can directly execute the script from this repository using `curl`:

```bash
curl -fsSL https://raw.githubusercontent.com/eduhweb/docker-wsl-install/docker-wsl-install.sh | bash
```

## Usage

1. **Run the Script**:
   - The script will check if Docker is installed and offer the option to reinstall if found.
   - If Docker is not installed, it proceeds with the full installation.
   
2. **Follow Prompts**:
   - If prompted to reinstall Docker, press `y` to confirm or `n` to cancel.

3. **Post-Installation**:
   - After installation, restart your WSL2 session with:
     ```bash
     wsl.exe --shutdown
     ```
   - Or manually restart your WSL2 terminal.

## Requirements

- WSL2 with Ubuntu or other Linux distros supported by WSL.
- Internet connection for downloading packages.

### Hyper-V and Docker in WSL2

For running Docker on Linux distributions other than Ubuntu (e.g., Debian, Fedora, Alpine) within WSL2, it is essential to ensure that the **Hyper-V** virtualization features are enabled on your Windows machine. Docker on WSL2 leverages the **Hyper-V** technology, which is built into Windows, to support containers and virtualized environments.

#### To enable **Hyper-V**:

1. Open **Control Panel** and go to **Programs** -> **Turn Windows features on or off**.
2. Ensure **Hyper-V** and **Windows Hypervisor Platform** are both checked.
3. Click **OK** and restart your system.

Enabling **Hyper-V** is required to run WSL2 efficiently with Docker, regardless of the Linux distribution used.