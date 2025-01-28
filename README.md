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
    git clone https://github.com/T7280H/command-line-t-linux.git

2. **And run the Shell script**
   ```bash
   cd command_line_t-linux && bash CMD-T.sh
