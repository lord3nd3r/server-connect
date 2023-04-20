#!/bin/bash

# Path to the file containing server nicknames and IP addresses
server_file="/path/to/server_file"

# Check if the "s" command was executed with a nickname argument
if [[ "$1" != "" && "$1" != " " ]]; then
    # Search for the nickname in the server file
    server=$(grep "^$1 " "$server_file" | awk '{print $2}')
    # If the server is found, SSH into it
    if [[ "$server" != "" && "$server" != " " ]]; then
        # Check if SSH key exists
        if [[ ! -f ~/.ssh/id_rsa ]]; then
            # Generate SSH key
            ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
            # Add key to local machine
            ssh-add ~/.ssh/id_rsa
            echo "SSH key generated and added to local machine."
        fi
        # Add key to remote server
        ssh-copy-id -i ~/.ssh/id_rsa.pub "$server"
        echo "SSH key added to remote server."
        # SSH into server
        ssh "$server"
    else
        echo "Server not found"
    fi
else
    echo "Usage: s nickname"
fi
