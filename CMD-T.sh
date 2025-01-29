#!/bin/bash
# CMD-T BASH CODE V:3.1.0 PRE-BETA SOURCE CODE

USER_FILE="usr/usr.txt"

# بررسی وجود فایل
if [ ! -f "$USER_FILE" ]; then
    touch "$USER_FILE"
    chmod 600 "$USER_FILE" # محدودیت دسترسی فقط برای کاربر جاری
fi


hash_password() {
    echo -n "$1" | openssl dgst -sha256 | awk '{print $2}'
}

red="\e[31m"
green="\e[32m"
blue="\e[34m"
yellow="\e[33m"
cyan="\e[36m"
purple="\e[35m"
reset="\e[0m"

# تنظیم خطاها
trap 'echo -e "${red}An unexpected error occurred!${reset}"' ERR

# نمایش بنر
clear
echo -e "${cyan}"
toilet -f big "CMD-T" || echo -e "${cyan}CMD-T${reset}"
echo -e "${reset}"
echo -e "${blue}Welcome to CMD-T Linux!${reset}"
echo -e "Version: 3.1.0 | Author: T7280H | Date: $(date)"
echo -e "${yellow}Type 'help' for a list of available commands.${reset}"

# توابع عمومی

show_error() {
    echo -e "${red}[ERROR] $1${reset}"
}

show_success() {
    echo -e "${green}[SUCCESS] $1${reset}"
}

log_command() {
    local log_file="$HOME/cmd-t.log"
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Command: $1" >> "$log_file"
}

# تابع لودینگ چرخشی
loading() {
    spin='-\|/'
    i=0
    while [ "$i" -le 10 ]; do
        i=$((i+1))
        printf "\rLoading ${spin:i%4:1}"
        sleep 0.1
    done
    printf "\rLoading Done!\n"
}
# تابع برای ورود کاربران

register_user() {
    echo -n "Enter a username: "
    read -r username

    # بررسی تکراری نبودن نام کاربری
    if grep -q "^$username:" "$USER_FILE"; then
        show_error "Username already exists. Please choose another."
        return
    fi

    echo -n "Enter a password: "
    read -r -s password
    echo

    hashed_password=$(hash_password "$password")

    # ذخیره کاربر
    echo "$username:$hashed_password" >> "$USER_FILE"
    show_success "User registered successfully!"
}

# تابع ورود کاربر
authenticate_user() {
    echo -n "Enter your username: "
    read -r username

    echo -n "Enter your password: "
    read -r -s password
    echo

    hashed_password=$(hash_password "$password")

    # بررسی اطلاعات کاربر
    if grep -q "^$username:$hashed_password$" "$USER_FILE"; then
        show_success "Authentication successful. Welcome, $username!"
    else
        show_error "Authentication failed. Please check your username or password."
    fi
}

# تابع نمایش لیست کاربران (فقط برای مدیر)
show_users() {
    echo "Registered users:"
    awk -F: '{print $1}' "$USER_FILE"
}
# تابع تایمر شمارشی (شمارش ثانیه)
timer() {
    log_command "timer"
    echo -e "${yellow}Enter the number of seconds for the timer:${reset}"
    read seconds

    if ! [[ "$seconds" =~ ^[0-9]+$ ]]; then
        show_error "Invalid input. Please enter a valid number of seconds."
        return
    fi

    echo -e "${blue}Starting timer for $seconds seconds...${reset}"
    for ((i = 0; i < seconds; i++)); do
        sleep 1
        echo -n "$i "
    done
    echo -e "${green}Timer ended!${reset}"
}

dir() {
    log_command "dir"
    ls -lha || show_error "Failed to list directory contents."
}

etf() {
    log_command "etf $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a folder name."
        return
    fi
    cd "$1" 2>/dev/null && pwd || show_error "Folder '$1' not found."
}

caf() {
    log_command "caf $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a folder name."
        return
    fi
    mkdir -p "$1" && show_success "Folder '$1' created." || show_error "Failed to create folder '$1'."
}

rmf() {
    log_command "rmf $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a file or folder name."
        return
    fi
    read -p "Are you sure you want to delete '$1'? (y/n): " confirm
    if [[ $confirm =~ ^[yY]$ ]]; then
        rm -rf "$1" && show_success "'$1' deleted." || show_error "Failed to delete '$1'."
    else
        echo "Operation canceled."
    fi
}

test() {
    log_command "test $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a host or IP to ping."
        return
    fi
    ping -c 4 "$1" || show_error "Failed to ping '$1'."
}

install() {
    log_command "install $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a package name to install."
        return
    fi
    loading
    pkg install "$1" && show_success "Package '$1' installed successfully." || show_error "Failed to install package '$1'."
}

uninstall() {
    log_command "uninstall $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a package name to uninstall."
        return
    fi
    loading
    pkg uninstall "$1" && show_success "Package '$1' uninstalled successfully." || show_error "Failed to uninstall package '$1'."
}

edit() {
    log_command "edit $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a file name to edit."
        return
    fi
    if command -v nano > /dev/null; then
        nano "$1" || show_error "Failed to open '$1' for editing."
    else
        show_error "Editor 'nano' not found."
    fi
}

calc() {
    log_command "calc"
    echo -e "${yellow}Enter a mathematical expression (e.g., 5+3*2):${reset}"
    read expression
    result=$(echo "$expression" | bc -l 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo -e "${green}Result: $result${reset}"
    else
        show_error "Invalid mathematical expression."
    fi
}

# دستورات جدید
times() {
    log_command "date_time"
    echo -e "${green}Current Date and Time: $(date)${reset}"
}

find_file() {
    log_command "find_file $1"
    if [ -z "${1:-}" ]; then
        show_error "Please provide a filename to search for."
        return
    fi
    find / -name "$1" -print 2>/dev/null || show_error "File '$1' not found."
}

sysinfo() {
    log_command "sysinfo"
    echo -e "${yellow}System Information:${reset}"
    uname -a
    echo -e "${yellow}CPU Information:${reset}"
    lscpu
    echo -e "${yellow}Memory Information:${reset}"
    free -h
    echo -e "${yellow}Disk Usage:${reset}"
    df -h
}

cls() {
    log_command "clear_screen"
    clear
}

help() {
    echo -e "${yellow}Available commands:${reset}"
    echo -e "${green}dir${reset}: List files and folders"
    echo -e "${green}etf${reset}: Enter a folder (usage: etf <folder>)"
    echo -e "${green}caf${reset}: Create a folder (usage: caf <folder>)"
    echo -e "${green}rmf${reset}: Remove files or folders (with confirmation)"
    echo -e "${green}test${reset}: Ping a host or IP (usage: test <host>)"
    echo -e "${green}install${reset}: Install a package (usage: install <package>)"
    echo -e "${green}uninstall${reset}: Uninstall a package (usage: uninstall <package>)"
    echo -e "${green}edit${reset}: Open a file in nano editor (usage: edit <file>)"
    echo -e "${green}calc${reset}: Simple calculator"
    echo -e "${green}times${reset}: Show current date and time"
    echo -e "${green}find_file${reset}: Find a file (usage: find_file <filename>)"
    echo -e "${green}sysinfo${reset}: Show system information"
    echo -e "${green}cls${reset}: Clear the screen"
    echo -e "${green}help${reset}: Show this help menu"
    echo -e "${green}ver${reset}: Show the Version CMD-T"
    echo -e "${green}sigin${reset}: Create an account"
    echo -e "${green}login${reset}: Login to your Account"
    echo -e "${green}git_d${reset}: Download from Github"
    echo -e "${green}usr_list${reset}: Show the User list"
    echo -e "${green}ghp${reset}: Show folder path"
    echo -e "${green}pls${reset}: Play Sound (usage: pls <file.mp3>)"
    echo -e "${green}battery${reset}: Show the Battery Infomation"
    echo -e "${green}timer${reset}: Set the Timer"
    echo -e "${green}exit${reset}: Exit CMD-T"
}
# تابع برای پخش صدای صوتی
playsound() {
    if [ -z "$1" ]; then
        echo "Please provide a filename to play."
        return 1
    fi

    if ! command -v mpv > /dev/null; then
        echo "MPV is not installed. Please install it to use this function."
        return 1
    fi

    mpv "$1"
}
ver() {
    echo -e "${blue}COMMAND LINE T-LINUX${reset}"
    echo -e "${green}VERSION 3.1.0 PRE-BETA${reset}"
    echo -e "${red}CREATED BY T7280H${reset}"
}
git_download() {
    echo -n "Enter the Git repository URL: "
    read -r repo_url

    if [ -z "$repo_url" ]; then
        show_error "Please provide a valid Git repository URL."
        return
    fi

    echo -n "Enter destination folder: "
    read -r dest_folder

    if [ -z "$dest_folder" ]; then
        show_error "Please provide a destination folder."
        return
    fi

    # احراز هویت (اختیاری)
    echo -n "Enter your username (press Enter to skip): "
    read -r username

    echo -n "Enter your password (press Enter to skip): "
    read -r -s password
    echo

    # ساختن دستور گیت
    if [ -n "$username" ] && [ -n "$password" ]; then
        git_command="git clone https://$username:$password@${repo_url#https://} $dest_folder"
    else
        git_command="git clone $repo_url $dest_folder"
    fi

    # اجرای دستور گیت
    eval "$git_command" && show_success "Repository downloaded successfully." || show_error "Failed to download repository."
}
ghp(){
    title="Your Folder Path: "
    echo -e "${purple}$title${reset}" && pwd
}
# تابع برای نمایش اطلاعات باتری
battery() {
    if command -v upower > /dev/null; then
        upower -i $(upower -e | grep 'battery') | grep --color=auto -E 'state|to\ full|percentage'
    else
        show_error "upower command not found. Please install it to use this function."
    fi
}
exiting() {
    spin='-\|/'
    i=0
    while [ "$i" -le 10 ]; do
        i=$((i+1))
        printf "\rEXITING ${spin:i%4:1}"
        sleep 0.1
    done
    printf "\rTHE PROGRAM EXITED!\n"
}

loading

# حلقه اصلی
while true; do
    echo -ne "${blue}CMD-T>${reset} "
    read -ra input
    command="${input[0]}"
    args="${input[@]:1}"

    case $command in
        dir) dir ;;
        etf) etf $args ;;
        caf) caf $args ;;
        rmf) rmf $args ;;
        test) test $args ;;
        install) install $args ;;
        uninstall) uninstall $args ;;
        edit) edit $args ;;
        calc) calc ;;
        times) times ;;
        find_file) find_file $args ;;
        sysinfo) sysinfo ;;
        cls) cls ;;
        ver) ver ;;
        sigin) register_user ;;
        login) authenticate_user ;;
        usr_list) show_users ;;
        git_d) git_download ;;
        ghp) ghp ;;
        pls) playsound $args ;;
        timer) timer ;;
        battery) battery ;;
        help) help ;;
        exit)
            echo -e "${green}Goodbye!${reset}"
            exiting
            break
            ;;
        *)
            show_error "Command not found: $command"
            ;;
    esac
done
