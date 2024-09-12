# Docker WSL Install Script
This script automates the installation, reinstallation, or uninstallation of Docker in **WSL2** (Windows Subsystem for Linux 2). It simplifies managing Docker services, installing Docker Compose, and handling Docker configurations specifically for WSL2 environments.

## Features

- Install or uninstall Docker and its dependencies.
- Option to reinstall Docker from scratch, removing all data and configurations.
- Install Docker Compose if not already installed.
- Adds the current user to the Docker group for running Docker without `sudo`.

## Quick Installation

You can directly execute the script from this repository using `curl`:

```bash
curl -fsSL https://raw.githubusercontent.com/eduhweb/docker-wsl-install/main/docker-wsl-install.sh -o docker-wsl-install.sh && chmod +x docker-wsl-install.sh && bash docker-wsl-install.sh
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


## How to Use the Docker Compose Setup for WordPress

This repository includes a Docker Compose file for setting up a local WordPress environment with MySQL and phpMyAdmin. Follow the steps below to install and run the WordPress Docker setup.

### 1. Clone the Repository

If you haven't already, clone the repository:

```bash
git clone https://github.com/<your-repo>/docker-wsl-install.git
cd docker-wsl-install/images/wordpress
```

### 2. Modify the `docker-compose.yml` (Optional)

The `docker-compose.yml` file includes default images for WordPress, MySQL, and phpMyAdmin. You can customize these images based on your specific needs:

- **WordPress:** You can choose between different PHP versions (e.g., PHP 7.4, PHP 8.0, or the latest PHP 8.1).
  
  Example options:
  ```yaml
  image: wordpress:php8.1-apache  # Replace this line with your desired WordPress version
  ```

- **MySQL or MariaDB:** You can switch between MySQL or MariaDB by changing the `image` value in the `db` service.

  Example options:
  ```yaml
  image: mariadb:10.5  # Replace this line with your desired MariaDB or MySQL version
  ```

### 3. Start the Docker Containers

After making any necessary modifications, start the containers by running the following command inside the `wordpress` folder:

```bash
docker-compose up -d
```

This command will:
- Start the WordPress service on port `8080`.
- Start the MySQL database.
- Launch phpMyAdmin on port `8081` for database management.

### 4. Accessing WordPress

Once the containers are running, you can access your local WordPress instance:

- **WordPress:** Open your browser and go to `http://localhost:8080`. You will see the WordPress setup screen.
  
- **phpMyAdmin:** Access `http://localhost:8081` to manage your MySQL database using phpMyAdmin. The login credentials will be:
  - Username: `root`
  - Password: `root_password` (or the value you set in the `docker-compose.yml` file).

### 5. Stopping the Containers

To stop the containers, use:

```bash
docker-compose down
```

This will stop and remove the containers but keep the volumes and data intact. You can restart them later with `docker-compose up -d`.

### 6. Data Persistence

The MySQL data is stored in a Docker volume (`db_data`). This ensures that your database persists even when containers are stopped or removed. If you want to start fresh, you can delete the volume using:

```bash
docker-compose down -v
```

This will remove all containers and delete the associated volumes.

### 7. Customizing the Environment

You can customize various environment variables in the `docker-compose.yml` file:

- **WordPress Environment Variables:**
  - `WORDPRESS_DB_HOST`: Hostname of the database (default: `db`).
  - `WORDPRESS_DB_USER`: MySQL user for WordPress (default: `wordpress_user`).
  - `WORDPRESS_DB_PASSWORD`: Password for the MySQL user (default: `wordpress_password`).
  - `WORDPRESS_DB_NAME`: Name of the WordPress database (default: `wordpress_db`).

- **MySQL/MariaDB Environment Variables:**
  - `MYSQL_DATABASE`: The database name (default: `wordpress_db`).
  - `MYSQL_USER`: MySQL username (default: `wordpress_user`).
  - `MYSQL_PASSWORD`: Password for the MySQL user (default: `wordpress_password`).
  - `MYSQL_ROOT_PASSWORD`: Password for the MySQL root user (default: `root_password`).

---

By following these steps, you can easily deploy a local WordPress environment with MySQL and phpMyAdmin using Docker Compose.
