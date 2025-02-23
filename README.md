This repo is a collection or various scripts/tools I use or am actively playing around with to aide in various penetration testing tasks. 

## Prep-Ligolo.sh
This script helps automate the process of setting up a network interface for Ligolo-NG and also lets you add routes to desired subnets in preparation for pivoting needs. 

##  Gonski's System Setup Script

This script automates the initial setup of a Kali Linux environment for penetration testing engagements. It installs essential tools, configures `tmux`, and sets up directory structures for efficient workflow management.

### Features

- **Tmux Configuration**:
  - Automatically sets up a custom `tmux` configuration for streamlined terminal management.
  - Includes plugin support and useful shortcuts for navigating windows.

- **Engagement Directory Structure**:
  - Creates a structured folder hierarchy in `/root/home` based on user input.
  - Example:
    ```
    /root/home/TIPT-Q4-2024-MB/
    ├── nmap/
    ├── hosts/
    ├── nxc/
    ├── loot/
    └── web/
    ```

- **Tool Installation**:
  - Installs `pipx` and uses it to install:
    - [`NetExec`](https://github.com/Pennyw0rth/NetExec)
    - [`Impacket`](https://github.com/SecureAuthCorp/impacket)
  - Downloads and extracts the latest release of [`Pretender`](https://github.com/RedTeamPentesting/pretender).

- **Custom Script Download**:
  - Downloads a Python tool from a GitHub Gist and renames it to `dc-lookup.py`.

- **Shell Reload**:
  - Optionally reloads the shell configuration (`zsh`).

## Prerequisites

- A fresh installation of Kali Linux.
- Root privileges to execute the script.

## Usage

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/mbb5546/Tools/Gonski-kali-setup.sh
   cd Gonski-kali-setup
   chmod +x Gonski-kali-setup.sh
   sudo ./Gonski-kali-setup.sh

## DC-Lookup.py

A simple python program used to perform Domain Controller identification/enumeration. Intended for use on penetration testing engagments when you need to identify Domain Controllers.

### Credit

The original code for this script was created by my friend @RalphDesmangles on Github. I am stealing his code and using it as a foundation as I try to get better at writing Python tools
