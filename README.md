# server-connect
Easily connect to servers that you work on


Here's how the script works:

The script first checks if an SSH key already exists on the local machine, by looking for the id_rsa private key file in the ~/.ssh/ directory. If the file doesn't exist, the script generates a new SSH key using the ssh-keygen command.
Once the key is generated, the script adds it to the local SSH agent using the ssh-add command, so that the user is not prompted for a password each time they connect to the remote server.
The script then uses the ssh-copy-id command to add the public key to the authorized_keys file on the remote server, so that the user can log in without a password.
Finally, the script logs into the remote server using the ssh command.
To use the updated script, save it to a file (e.g. s.sh), make it executable with chmod +x s.sh, and then add the directory containing the script to your $PATH environment variable. You can then execute the script by typing s nickname in the terminal, where nickname is the nickname of the server you want to connect to. The script will generate an SSH key, add it to both the local machine and the remote server, and then log in to the remote server using the key.

The order of the fields in the server file matters, as long as the fields are separated by whitespace (e.g. spaces or tabs) and each line contains only one server entry.

For example, you could set up the server file like this:

server01 192.168.1.100

server02 192.168.1.101

server03 10.0.0.2


When you run the s command with a nickname argument (e.g. s myserver), the script will search the server file for a line that starts with the nickname followed by a space, and extract the IP address from the second field of that line. If a matching server entry is found, the script will use the extracted IP address to SSH into the server.

So as long as each server entry contains an IP address and a nickname, in any order and separated by whitespace, the script should work correctly.

To run the script, use s.sh server-nickname (which is in the server file next to the IP/host)
