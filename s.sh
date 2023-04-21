!/bin/bash

# Path to the file containing server nicknames and IP addresses
server_file="/path/to/server_file"
# For WSL host
#server_file="/mnt/c/path/to/server_file"
# Check if the "s" command was executed with a nickname argument
if [[ "$1" != "" && "$1" != " " ]]; then

    # Path to the log file
    log_file="/path/to/log_file"

    # Initialize the log file with a timestamp
    echo "$(date +%Y-%m-%d\ %H:%M:%S) - Starting s command" >> "$log_file"

    if [[ -n ${1:-} ]]; then
        # Search for the nickname in the server file
        server=$(grep "^$1 " "$server_file" | awk '{print $2}')
        # If the server is found, SSH into it
        if [[ "$server" != "" && "$server" != " " ]]; then
            if [[ -n ${server:-} ]]; then
                # Check if SSH key exists
                if [[ ! -f ~/.ssh/id_rsa || ! -f ~/.ssh/id_rsa.pub ]]; then
                    # Generate SSH key
                    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
                    # Add key to local machine
                    ssh-add ~/.ssh/id_rsa
                    echo "SSH key generated and added to local machine."
                    if ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""; then
                        echo "$(date +%Y-%m-%d\ %H:%M:%S) - Generated SSH key" >> "$log_file"
                    else
                        echo "$(date +%Y-%m-%d\ %H:%M:%S) - Failed to generate SSH key" >> "$log_file"
                        exit 1
                    fi
                fi
                # Start ssh-agent and add key
                if eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa; then
                    echo "$(date +%Y-%m-%d\ %H:%M:%S) - Added SSH key to ssh-agent" >> "$log_file"
                else
                    echo "$(date +%Y-%m-%d\ %H:%M:%S) - Failed to add SSH key to ssh-agent" >> "$log_file"
                    exit 1
                fi
                # Add key to remote server
                ssh-copy-id -i ~/.ssh/id_rsa.pub "$server"
                echo "SSH key added to remote server."
                # SSH into server
                ssh "$server"
                if ssh -q "$server"; then
                    echo "$(date +%Y-%m-%d\ %H:%M:%S) - Connected to server $server" >> "$log_file"
                else
                    echo "$(date +%Y-%m-%d\ %H:%M:%S) - Failed to connect to server $server" >> "$log_file"
                    exit 1
                fi
            else
                echo "Server not found"
                echo "$(date +%Y-%m-%d\ %H:%M:%S) - Server not found" >> "$log_file"
                exit 1
            fi
        else
            echo "Server not found"
            echo "$(date +%Y-%m-%d\ %H:%M:%S) - Server not found" >> "$log_file"
            exit 1
        fi
    else
        echo "Usage: s nickname"
        echo "$(date +%Y-%m-%d\ %H:%M:%S) - Usage: s nickname" >> "$log_file"
        exit
