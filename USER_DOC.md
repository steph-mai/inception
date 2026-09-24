# USER_DOC - User & Administrator Documentation

This document explains how to interact with the Inception infrastructure from an end-user and administrator perspective.

## 1. Services Provided by the Stack
This infrastructure automatically deploys a complete, secure web ecosystem:
*   **Web Server (NGINX):** The only entry point to the system, serving the website securely over HTTPS (TLSv1.2/1.3).
*   **Website (WordPress):** A fully configured Content Management System ready to publish articles.
*   **Database (MariaDB):** A robust SQL database running securely in the background to store website data.

## 2. How to Start and Stop the Project
The project uses a `Makefile` to simplify operations. Open a terminal at the root of the repository:

*   **To start the infrastructure in the background:**
    ```bash
    make all
    ```
*   **To stop the infrastructure safely (without losing data):**
    ```bash
    make down
    ```

## 3. Accessing the Website and Administration Panel
Before accessing the site, ensure your local DNS resolves the domain name. If accessing locally, add this line to your `/etc/hosts` file: `127.0.0.1 stmaire.42.fr`.

*   **Public Website:** Open your browser and navigate to `https://stmaire.42.fr`
*   **WordPress Admin Panel:** Navigate to `https://stmaire.42.fr/wp-admin`
*(Note: Your browser may display a security warning because the SSL certificate is self-signed. You must accept the risk to proceed).*

## 4. Locating and Managing Credentials
For security reasons, no passwords are hardcoded in the source code. All credentials and configuration variables are strictly managed locally via a hidden environment file.

*   **Location:** The file must be created at `srcs/.env`.
*   **Management:** This file defines the database passwords, the WordPress administrator account, and the standard user account. If you need to change a password, stop the project (`make down`), edit the `.env` file, and restart (`make all`).

## 5. Checking Service Health
To verify that all services are running correctly:

*   **Check container status:**
    ```bash
    make psa
    ```
    *All containers should display a status of "Up".*
*   **View live server logs (to spot errors):**
    ```bash
    make logs
    ```
