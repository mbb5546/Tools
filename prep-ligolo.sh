#Bash script that runs some of the prep work needed when wanting to use Ligolo-ng for pivoting

#!/bin/bash

# Function to display current routes with bold text and spacing
display_current_routes() {
  printf "\n\e[1mCurrent Routes:\e[0m\n\n"  # Bold text with multiple newlines
  ip route show | awk '{print $1, $3}'
  echo
}

# Function to check if ligolo interface exists
ligolo_interface_exists() {
  # Check if ligolo interface exists
  if ip link show ligolo &> /dev/null; then
    echo -e "\e[1mInterface 'ligolo' already exists.\e[0m"
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
    echo -e "\e[1mTun interface 'ligolo' created successfully.\e[0m"
  else
    echo -e "\e[1mFailed to create tun interface. Check for errors.\e[0m"
    exit 1
  fi

  # Turn on ligolo interface
  sudo ip link set ligolo up

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo -e "\e[1mInterface 'ligolo' turned on successfully.\e[0m"
  else
    echo -e "\e[1mFailed to turn on interface 'ligolo'. Check for errors.\e[0m"
    exit 1
  fi
}

# Function to add route for desired subnet with bold text and spacing
add_subnet_route() {
  # Display current routes
  display_current_routes

  # Prompt the user for the desired subnet
  read -p "Enter the desired subnet you want to pivot to (e.g., 192.168.1.0/24): " user_subnet

  # Add route for the specified subnet
  sudo ip route add $user_subnet dev ligolo

  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo -e "\n\e[1mRoute added successfully for subnet $user_subnet.\e[0m"
  else
    echo -e "\n\e[1mFailed to add route. Check for errors.\e[0m"
    exit 1
  fi

  # Display updated routes
  printf "\n\e[1mUpdated routes:\e[0m\n"
  ip route show | awk '{print $1, $3}'
}

# Display tool header with bold text
echo -e "\e[1m============================================================\e[0m"
echo -e "\e[1m        Welcome to 'prep-ligolo.sh' - Version 1.0         \e[0m"
echo -e "\e[1m============================================================\e[0m"
echo

# Display menu options with bold text
echo -e "\e[1mSelect an option:\e[0m"
echo -e "\e[1m1. Add tun interface 'ligolo' and turn it on\e[0m"
echo -e "\e[1m2. Add route for desired subnet you want to pivot to\e[0m"

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
    echo -e "\e[1mInvalid choice. Exiting.\e[0m"
    exit 1
    ;;
esac
