# By 3nd3r and JohnnySin 2023
#!/bin/bash

# Path to the file containing server nicknames and IP addresses
server_file="server.conf"
# For WSL host
#server_file="/mnt/c/path/to/server_file"

# Path to the log file
log_file="s.log"

# Check if the "s" command was executed with a nickname argument
if [[ -n "$1" ]]; then
    # Search for the nickname in the server file
    server=$(grep "^$1 " "$server_file" | awk '{print $2}')
    # If the server is found, SSH into it
    if [[ -n "$server" ]]; then
        # Check if SSH key exists
        if [[ ! -f ~/.ssh/id_rsa || ! -f ~/.ssh/id_rsa.pub ]]; then
            # Generate SSH key
            ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
            # Add key to local machine
            ssh-add ~/.ssh/id_rsa
            echo "SSH key generated and added to local machine."
            echo "$(date +%Y-%m-%d\ %H:%M:%S) - Generated and added SSH key to local machine." >> "$log_file"
        fi
        # Start ssh-agent and add key
        if eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa; then
            echo "SSH key added to ssh-agent."
            echo "$(date +%Y-%m-%d\ %H:%M:%S) - Added SSH key to ssh-agent." >> "$log_file"
        else
            echo "Failed to add SSH key to ssh-agent."
            echo "$(date +%Y-%m-%d\ %H:%M:%S) - Failed to add SSH key to ssh-agent." >> "$log_file"
            exit 1
        fi
        # Add key to remote server
        ssh-copy-id -i ~/.ssh/id_rsa.pub "$server"
        echo "SSH key added to remote server."
        # SSH into server
        if ssh -q "$server"; then
            echo "Connected to server $server."
            echo "$(date +%Y-%m-%d\ %H:%M:%S) - Connected to server $server." >> "$log_file"
        else
            echo "Failed to connect to server $server."
            echo "$(date +%Y-%m-%d\ %H:%M:%S) - Failed to connect to server $server." >> "$log_file"
            exit 1
        fi
    else
        echo "Server not found."
        echo "$(date +%Y-%m-%d\ %H:%M:%S) - Server not found." >> "$log_file"
        exit 1
    fi
else
    echo "Usage: s nickname"
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - Usage: s nickname" >> "$log_file"
    exit 1
fi
