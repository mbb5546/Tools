# prep-ligolo is a simple script that simplifies the process for setting up Ligolo-NG on your system. 
# This script will create a tun interface for you and will also prompt you to add routes to networks/subnets of your choice in preparation for setting up pivots/tunnels with ligolo
#You can find the main tool Ligolo-NG here: https://github.com/nicocha30/ligolo-ng
#Here's a video I made on Ligolo-NG usage: https://www.youtube.com/watch?v=DM1B8S80EvQ

#!/bin/bash

# Function to display current routes
display_current_routes() {
  echo "Current routes:"
  ip route show | awk '{print $1, $3}'
  echo
}

# Function to check if ligolo interface exists
ligolo_interface_exists() {
  # Check if ligolo interface exists
  if ip link show ligolo &> /dev/null; then
    echo "Interface 'ligolo' already exists."
    return 0
  else
    return 1
  fi
}

# Function to add tun interface and turn it on
add_tun_interface() {
  # Check if ligolo interface already exists
  if ligolo_interface_exists; then
    exit 1
  fi

  # Add tun interface for ligolo
  sudo ip tuntap add user kali mode tun ligolo

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Tun interface 'ligolo' created successfully."
  else
    echo "Failed to create tun interface. Check for errors."
    exit 1
  fi

  # Turn on ligolo interface
  sudo ip link set ligolo up

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Interface 'ligolo' turned on successfully."
  else
    echo "Failed to turn on interface 'ligolo'. Check for errors."
    exit 1
  fi
}

# Function to add route for desired subnet
add_subnet_route() {
  # Display current routes
  display_current_routes

  # Prompt the user for the desired subnet
  read -p "Enter the desired subnet to access (e.g., 192.168.1.0/24): " user_subnet

  # Add route for the specified subnet
  sudo ip route add $user_subnet dev ligolo

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Route added successfully for subnet $user_subnet."
  else
    echo "Failed to add route. Check for errors."
    exit 1
  fi

  # Display updated routes
  echo
  echo "Updated routes:"
  ip route show | awk '{print $1, $3}'
}

# Display menu options
echo "Select an option:"
echo "1. Add tun interface 'ligolo' and turn it on"
echo "2. Add route for desired subnet"

# Prompt user for choice
read -p "Enter your choice (1 or 2): " user_choice

# Perform the selected action
case $user_choice in
  1)
    add_tun_interface
    ;;
  2)
    add_subnet_route
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac
