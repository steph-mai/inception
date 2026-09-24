*This project has been created as part of the 42 curriculum by stmaire.*

<div align="center">
<br>
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQPzuYKu7n0cWUYa5Kbg0_LrlEQAIURWeo9A&s" alt="42 Logo" width="400" />
  <br>
</div>

# Inception

![Static Badge](https://img.shields.io/badge/System_administration-green)
![Static Badge](https://img.shields.io/badge/Network-green)
![Static Badge](https://img.shields.io/badge/Rigor-pink)

## 🔵 Description

### ✳️ Goal

The Inception project is a system administration exercise focused on containerization and infrastructure deployment. The main objective is to run a complete web infrastructure inside a virtual machine using Docker and Docker Compose.

### Key Learning Objectives:
*   Building custom containers with Dockerfiles and shell entrypoints.
*   Designing a secure architecture where only NGINX is exposed to the outside world.
*   Managing persistent data with Docker volumes.
*   Configuring HTTPS with self-signed certificates.
*   Following security best practices, such as avoiding root execution when possible and keeping sensitive data out of the repository.

### ✳️ Overview

This infrastructure is made of independent containers, each responsible for one service:

*   NGINX: The only entry point. It handles HTTPS on port 443 and forwards requests to the backend services.
*   WordPress (PHP-FPM): The main application, installed and configured at runtime with WP-CLI.
*   MariaDB: The database service, isolated from the host and accessible only by internal containers.
*   Adminer (Bonus): A lightweight database management interface, exposed through a dedicated route.

The system uses a custom Docker network named inception to allow secure communication between containers. Data is stored in Docker volumes to keep files and databases safe even after container restarts or removals.

## 🔵 Instructions

### ✳️ Prerequisites

To run this project, the machine must have the following tools installed:

*   **Docker:** The core containerization engine.
*   **Docker Compose (v2):** The orchestration tool for multi-container applications (using the `docker compose` command).
*   **Make:** GNU Make to execute the provided Makefile rules.
*   **Git:** To clone the repository.

**DNS Resolution:**
Before running the project, map the local loopback address (or the VM's IP) to the custom domain name required by the subject.
Open the host machine's `/etc/hosts` file (with `sudo` privileges) and add the following line:
```text
127.0.0.1   stmaire.42.fr
````

### ✳️ Installation

Clone the repository and go to the project directory:

```bash
git clone <your_repository_url> inception
cd inception
```

### ✳️ Execution

A Makefile is included to simplify the deployment process.

#### Main commands

```bash
make all
```

Starts the full project in detached mode.

```bash
make down
```

Stops and removes the containers and network, while keeping Docker images and volumes.

```bash
make clean
```

Stops the project and removes containers, images, and volumes.

```bash
make fclean
```

Removes the project data stored in `/home/stmaire/data/*`.

```bash
make re
```

Performs a full rebuild from a clean state.

#### Useful commands

```bash
make logs
```

Displays live logs for all services.

```bash
make logs-wordpress
```

Displays the logs for a specific container.

```bash
make in-mariadb
```

Opens a shell inside the MariaDB container.

```bash
make psa
```

Lists all Docker containers.

#### Manual execution

If you prefer not to use the Makefile, you can run the project with Docker Compose manually.

```bash
mkdir -p /home/stmaire/data/wordpress
mkdir -p /home/stmaire/data/mariadb
docker compose -f srcs/docker-compose.yml up -d --build
```

To stop it:

```bash
docker compose -f srcs/docker-compose.yml down
```

To view logs:

```bash
docker compose -f srcs/docker-compose.yml logs -f wordpress
```

To open a shell in a running container:

```bash
docker exec -it mariadb bash
```

## 🔵 Project description

### ✳️ Design choices

Several technical decisions were made to follow the project constraints while keeping the setup secure and practical:

*   GUI-enabled virtual machine: A desktop environment was used to make testing and visual validation easier.
*   Local SSH server: SSH was configured to allow remote access from the host machine.
*   SSH tunneling: Used to test the project through a browser in a more native environment.
*   Debian Bookworm as the base image: Chosen for stability, documentation, and compatibility with PHP-related extensions.
*   Strict HTTPS setup: NGINX accepts only TLSv1.2 and TLSv1.3, blocking older insecure protocols.

### ✳️ Virtual Machines vs Docker

Both provide isolation, but they work differently:

*   A virtual machine includes a full operating system and uses more RAM and CPU.
*   Docker shares the host kernel and runs applications as lightweight containers.
*   Docker is faster to start and generally lighter than a VM.
*   Docker is also more portable and easier to deploy consistently across environments.

### ✳️ Secrets vs Environment Variables

Sensitive values such as passwords and credentials must never be hardcoded in the project repository.

*   Hardcoding secrets in Dockerfiles or compose files is a major security issue.
*   The recommended approach is to store them in a local `.env` file or dedicated configuration files on the host machine.
*   These files must be ignored by Git to prevent them from being pushed.

> Docker secrets exist, but for a simple single-node setup like this one, `.env` files are the most practical and appropriate method.

### ✳️ Docker Network vs Host Network

Network isolation is a key part of this project:

*   `network_mode: "host"` shares the host network directly and removes container isolation.
*   This is not allowed for this task.
*   A custom Docker bridge network is used instead, keeping containers isolated while allowing internal communication.

Only NGINX exposes a port to the outside world, acting as the single entry point.

### ✳️ Docker Volumes vs Bind Mounts

To keep data safe, Docker volumes are used for persistent storage.

*   Bind mounts directly link a host folder to a container folder.
*   Docker volumes are managed by Docker and are easier to maintain.
*   The project requires data to be stored under `/home/stmaire/data/`, so the setup uses local volumes with the required device paths.

This keeps the data persistent while respecting the subject constraints.

## 🔵 Resources

### ✳️ References

*   **Official Documentations:**
    *   [Docker Documentation](https://docs.docker.com/)
    *   [NGINX Official Documentation](https://nginx.org/en/docs/)
    *   [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
    *   [WP-CLI Documentation (WordPress)](https://make.wordpress.org/cli/handbook/)
*   **Project Tutorials & Guides:**
    *   [GradeMe - Inception Tutorial](https://grademe.fr/inception) *(A standard reference for 42 students to understand the project's specific workflow and constraints).*
    *   [SQL Tutorial](https://www.w3schools.com/sql/) *(Essential for mastering database initialization, user creation, and privilege management commands).*
*   **In-depth Container Theory:**
    *   [Stéphane Robert Blog - Docker](https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/) *(An excellent French resource for thoroughly understanding the underlying mechanics of containerization, cgroups, namespaces, and Docker daemon architecture).*

### ✳️ AI Usage

Artificial Intelligence was utilized as a pedagogical assistant and technical sounding board during the development of this project, strictly adhering to the school's learning principles. Its contributions include:

*   **Concept Clarification & Docker Mechanics:** Breaking down the fundamental principles of containerization, including how Docker interacts with the Linux kernel (namespaces, cgroups), network isolation, and the architectural differences compared to traditional Virtual Machines.
*   **Implementation Review:** Acting as an automated technical reviewer to audit the infrastructure. This included challenging design choices, validating security practices (such as proper PID 1 handling and credential isolation), and ensuring the setup strictly respected the project's constraints.
*   **Documentation Translation:** Assisting in the translation and refinement of this README from French into professional English, ensuring technical terminology was accurate and clearly conveyed.


