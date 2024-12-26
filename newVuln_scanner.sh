#!/bin/bash

# Check if required tools are installed
if ! command -v nmap &> /dev/null; then
    echo "nmap is not installed. Please install it to continue."
    exit 1
fi

if ! command -v sqlmap &> /dev/null; then
    echo "sqlmap is not installed. Please install it to continue."
    exit 1
fi

if ! command -v msfconsole &> /dev/null; then
    echo "metasploit-framework is not installed. Please install it to continue."
    exit 1
fi

# Function to perform nmap scan
perform_nmap_scan() {
    local target=$1
    local ports=$2
    local options=$3

    echo "Performing nmap scan on $target..."
    nmap $options -p $ports $target
}

# Function to perform sqlmap scan
perform_sqlmap_scan() {
    local target=$1
    local options=$2

    echo "Performing sqlmap scan on $target..."
    sqlmap $options $target
}

# Function to perform metasploit scan
perform_metasploit_scan() {
    local target=$1
    local options=$2

    echo "Performing metasploit scan on $target..."
    msfconsole -x "use auxiliary/scanner/portscan/tcp; set RHOSTS $target; run; exit"
}

# Main menu using dialog
while true; do
    choice=$(dialog --clear --title "Agent-less Scanner" --menu "Select an option:" 15 40 4 \
        1 "Nmap Scan" \
        2 "SQLmap Scan" \
        3 "Metasploit Scan" \
        4 "Exit" 3>&1 1>&2 2>&3)

    case $choice in
        1)
            target=$(dialog --inputbox "Enter the target IP or hostname:" 8 40 3>&1 1>&2 2>&3)
            ports=$(dialog --inputbox "Enter the ports to scan (e.g., 22,80,443):" 8 40 3>&1 1>&2 2>&3)
            options=$(dialog --inputbox "Enter additional nmap options:" 8 40 3>&1 1>&2 2>&3)
            perform_nmap_scan "$target" "$ports" "$options"
            ;;
        2)
            target=$(dialog --inputbox "Enter the target URL:" 8 40 3>&1 1>&2 2>&3)
            options=$(dialog --inputbox "Enter additional sqlmap options:" 8 40 3>&1 1>&2 2>&3)
            perform_sqlmap_scan "$target" "$options"
            ;;
        3)
            target=$(dialog --inputbox "Enter the target IP or hostname:" 8 40 3>&1 1>&2 2>&3)
            options=$(dialog --inputbox "Enter additional metasploit options:" 8 40 3>&1 1>&2 2>&3)
            perform_metasploit_scan "$target" "$options"
            ;;
        4)
            break
            ;;
    esac
done
