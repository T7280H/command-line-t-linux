# CMD-T Linux Shell Script Version 3.1.0

This is a bash shell script named CMD-T, providing a simple command-line interface with various utilities.  It's designed for Linux systems and offers features like file management, package management, system information, and more.

## Features

* **File Management:** `dir`, `etf` (enter folder), `caf` (create folder), `rmf` (remove file/folder), `ghp` (show folder path).
* **Package Management:** `install`, `uninstall`.
* **System Information:** `sysinfo`, `battery`.
* **Network:** `test` (ping).
* **Text Editing:** `edit` (using nano).
* **Calculator:** `calc`.
* **Utilities:** `times` (date/time), `find_file`, `cls` (clear screen), `pls` (play sound - requires `mpv`), `timer`.
* **User Management:** `sigin` (register), `login`, `usr_list` (show users - admin only).
* **Git Integration:** `git_d` (download from GitHub).
* **Help:** `help` (displays available commands).
* **Version Info:** `ver`.
* **Exit:** `exit`.
* **Logging:** Commands are logged to `~/cmd-t.log`.
* **User Authentication:**  Uses a simple file-based authentication system. Passwords are hashed using SHA256.
* **Loading Animation:** A spinning animation is displayed during loading periods.
* **Colored Output:** Uses ANSI escape codes for colored text output.
* **Error Handling:** Includes basic error handling and displays informative messages.

## Installation

1.  **Clone the repository (or download the script):**

    ```bash
    git clone <repository_url>
    ```

    Or if you downloaded the script directly:

    ```bash
    wget <url_of_the_script> -O cmd-t.sh
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x cmd-t.sh
    ```

3.  **(Optional) Move the script to a directory in your PATH (e.g., `/usr/local/bin`):**

    ```bash
    sudo mv cmd-t.sh /usr/local/bin/cmd-t
    ```

    If you don't move it to your PATH, you'll need to run it from the directory where it's located (e.g., `./cmd-t.sh`).

## Usage

Run the script from your terminal:

```bash
cmd-t  # If in PATH
./cmd-t.sh # If not in PATH
