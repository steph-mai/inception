# DEV_DOC — Developer Documentation

This document explains how to configure, run and understand the Inception project infrastructure.

## 1. Prerequisites
- Linux system (Debian Bookworm recommended).
- docker and docker-compose installed.
- make installed.
- Root access to edit /etc/hosts.

## 2. Local DNS configuration
To access the local domain, add the following line to `/etc/hosts` (requires sudo):
```bash
sudo nano /etc/hosts
# add:
127.0.0.1 stmaire.42.fr
```

## 3. Configuration files & secrets
No secrets are committed. Create the environment file before starting:

Path: `srcs/.env`

Template:
```env
# Domain
DOMAIN_NAME=stmaire.42.fr

# Database
SQL_DATABASE=wordpress
SQL_USER=wp_user
SQL_PASSWORD=your_secure_db_password
SQL_ROOT_PASSWORD=your_secure_root_password

# WordPress Admin
WP_ADMIN_USER=your_name
WP_ADMIN_PASSWORD=your_secure_admin_password
WP_ADMIN_EMAIL=your_name@student.42.fr

# WordPress Standard User
WP_USER=your_name
WP_USER_PASSWORD=your_secure_user_password
WP_USER_EMAIL=your_name@student.42.fr
```
Note: This file is excluded by `.gitignore` to prevent leaking secrets.

## 4. Build and run
The project is orchestrated with Docker Compose and controlled via a Makefile at the repository root.

Start (build + detached):
```bash
make all
# or
make
```

Stop cleanly (preserving data):
```bash
make down
```

View live logs:
```bash
make logs
```

List containers (status):
```bash
make psa
```

## 5. Important Make targets
- `make all` / `make` : build and start services.
- `make down` : stop and remove containers (persistent volumes remain).
- `make clean` : stop and remove images and Docker-managed volumes.
- `make fclean` : `clean` + remove physical data folders (e.g. `/home/stmaire/data/`) — destructive.
- `make re` : stop, `fclean`, rebuild and restart.
- `make logs` : stream logs.
- `make psa` : show container status.

Useful native Docker commands:
```bash
docker compose ps
docker compose logs -f
docker ps -a
```

## 6. Data storage and persistence
Data is persisted on the host to survive redeployments.

Host paths:
- `/home/stmaire/data/mariadb/` — raw MariaDB files
- `/home/stmaire/data/wordpress/` — WordPress files (core, themes, plugins, uploads)

The `docker-compose.yml` mounts local volumes to these paths. Example:
```yaml
volumes:
  wordpress_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/stmaire/data/wordpress
```
This ensures the volume is bound to the specified absolute path on the host.

## 7. Quick tips
- To change `.env`: stop the project (`make down`), edit `srcs/.env`, then restart (`make all`).
- Backup DB: dump MariaDB from the container or back up `/home/stmaire/data/mariadb/`.
- For debugging: `make logs` or `docker compose logs -f <service>`.

