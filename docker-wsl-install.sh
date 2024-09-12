#!/bin/bash

# Define color variables for styling
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

# Function to check if the previous command failed and show a red error message
check_failure() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}An error occurred. Please check the previous step and try again.${RESET}"
        exit 1
    fi
}

# Function to stop Docker services in WSL2
stop_docker_services() {
    echo -e "${CYAN}Stopping Docker services and killing any running Docker processes...${RESET}"
    
    # Stop Docker services using service instead of systemctl for WSL2
    sudo service docker stop
    sudo service containerd stop

    # Kill Docker and containerd processes manually in WSL2
    if pgrep -x "docker" > /dev/null; then
        echo -e "${YELLOW}Killing Docker processes...${RESET}"
        sudo pkill -f docker
    fi
    if pgrep -x "containerd" > /dev/null; then
        echo -e "${YELLOW}Killing containerd processes...${RESET}"
        sudo pkill -f containerd
    fi

    # Try unmounting /var/lib/docker, forcefully if needed
    if mount | grep /var/lib/docker > /dev/null; then
        echo -e "${YELLOW}/var/lib/docker is mounted, attempting to unmount it...${RESET}"
        sudo fuser -k /var/lib/docker   # Kill any processes using the directory
        sudo umount -l /var/lib/docker  # Lazy unmount to avoid the "target is busy" error
        check_failure
    fi
}

# Function to completely uninstall Docker
uninstall_docker() {
    echo -e "${CYAN}Removing Docker and all its components...${RESET}"

    # Stop Docker services manually
    stop_docker_services

    # Attempt to remove Docker packages
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras || true

    # Fix any broken packages
    sudo apt --fix-broken install -y

    # Remove residual data and directories
    sudo apt-get autoremove -y --purge
    sudo rm -rf /var/lib/docker /etc/docker /var/lib/containerd /run/docker.sock
    check_failure

    echo -e "${GREEN}Docker successfully removed.${RESET}"
}

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo -e "${CYAN}Docker is already installed.${RESET}"
    
    # Ask the user if they want to reinstall Docker from scratch
    read -p "Do you want to reinstall Docker from scratch? This will erase all configurations and containers. [y/N]: " reinstall_choice
    if [[ "$reinstall_choice" =~ ^[yY](es)?$ ]]; then
        uninstall_docker
    else
        echo -e "${YELLOW}Reinstallation canceled. Exiting.${RESET}"
        exit 0
    fi
fi

# Docker installation process
echo -e "${CYAN}Installing Docker and dependencies...${RESET}"
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg-agent
check_failure

# Add Docker's GPG key and configure Docker's official APT repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
check_failure

# Add Docker repository to the APT sources list
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF
check_failure

# Install Docker Engine and containerd
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
check_failure

echo -e "${GREEN}Docker successfully installed.${RESET}"

# Add the current user to the Docker group if not already a member
if ! groups $USER | grep &>/dev/null '\bdocker\b'; then
    echo -e "${CYAN}Adding the current user to the 'docker' group to run Docker without sudo...${RESET}"
    sudo usermod -aG docker $USER
    check_failure
    echo -e "${YELLOW}Please log out and log back in or restart your WSL2 session for the group change to take effect.${RESET}"
fi

# Install Docker Compose if not already installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${CYAN}Installing Docker Compose...${RESET}"
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    check_failure

    # Make Docker Compose executable
    sudo chmod +x /usr/local/bin/docker-compose
    check_failure

    echo -e "${GREEN}Docker Compose successfully installed.${RESET}"
else
    echo -e "${YELLOW}Docker Compose is already installed.${RESET}"
fi

# Display message in green for next steps
echo -e "${GREEN}To apply changes, please run the following command from **Windows** Command Prompt or PowerShell:${RESET}"
echo -e "${GREEN}'wsl.exe --shutdown'${RESET}"
echo -e "${GREEN}Alternatively, you can close your WSL2 terminal and restart it manually.${RESET}"
