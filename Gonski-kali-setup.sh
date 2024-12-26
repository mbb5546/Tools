#!/bin/bash

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Variables
TMUX_CONF=".tmux.conf"
ENGAGEMENT_BASE="/root"
TOOLS_DIR="${ENGAGEMENT_BASE}/tools"
PRETENDER_URL="https://github.com/RedTeamPentesting/pretender/releases/download/v1.2.0/pretender_Linux_arm64.tar.gz"
RALPH_SCRIPT_URL="https://gist.github.com/RalphDesmangles/c95f623106a43c8069dc123f2000f015/raw"

# Step 1: Setup Tmux Configuration
echo "Setting up Tmux configuration..."
cat <<'EOF' > ~/${TMUX_CONF}
# Default Shell
set-option -g default-shell /bin/zsh

# Increase history size (Be careful making this too large)
set -g history-limit 30000

# List of plugins
# to enable a plugin, use the 'set -g @plugin' syntax:
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-logging'

# Shift arrow to shift windows
bind -n S-Left previous-window
bind -n S-Right next-window

# Set window title list colors
set-window-option -g window-status-style fg=brightblue,bg=colour237,dim

# Active window title colors
set-window-option -g window-status-current-style fg=brightgreen,bg=colour237,bright

# Show host name and IP address on right side of status bar
set -g status-right-length 70
set -g status-bg colour237
set -g status-fg white
set -g status-right "#[fg=white]Host: #[fg=green]#h#[fg=white] LAN: #[fg=green]#(ip addr show dev eth0 | grep "inet[^6]" | awk '{print $2}')#[fg=white] VPN: #[fg=green]#(ip addr show dev tun0 | grep "inet[^6]" | awk '{print $2}')"

# Scroll with mouse
setw -g mouse on
set -g terminal-overrides 'xterm*:smcup@:rmcup@'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF
echo "Tmux configuration saved as ~/${TMUX_CONF}."

# Step 2: Create Engagement Folder Structure
read -p "Enter Component Name (e.g., TIPT, CIPT, CPPT): " COMPONENT
read -p "Enter Quarter (e.g., Q1, Q2, Q3, Q4): " QUARTER
read -p "Enter Initials (e.g., MB): " INITIALS
YEAR=$(date +%Y)
ENGAGEMENT_DIR="${ENGAGEMENT_BASE}/${COMPONENT}-${QUARTER}-${YEAR}-${INITIALS}"

echo "Creating engagement directory structure at ${ENGAGEMENT_DIR}..."
mkdir -p "${ENGAGEMENT_DIR}"/{nmap,hosts,nxc,loot,web}
echo "Engagement directories created."

# Step 3: Ensure Tools Directory Exists
echo "Ensuring tools directory exists at ${TOOLS_DIR}..."
mkdir -p "${TOOLS_DIR}"
echo "Tools directory is ready."

# Step 4: Install pipx
echo "Installing pipx..."
apt update && apt install -y python3-pip python3-venv
python3 -m pip install --user pipx
python3 -m pipx ensurepath
echo "pipx installed."

# Step 5: Install nxc and impacket using pipx
echo "Installing NetExec (nxc) from GitHub..."
pipx install git+https://github.com/Pennyw0rth/NetExec
echo "NetExec (nxc) installed."

echo "Installing impacket..."
pipx install impacket
echo "impacket installed."

# Step 6: Install Pretender
echo "Installing Pretender..."
wget -O "${TOOLS_DIR}/pretender.tar.gz" "${PRETENDER_URL}"
tar -xzf "${TOOLS_DIR}/pretender.tar.gz" -C "${TOOLS_DIR}"
rm "${TOOLS_DIR}/pretender.tar.gz"
chmod +x "${TOOLS_DIR}/pretender"
echo "Pretender installed to ${TOOLS_DIR}."

# Step 7: Download Ralph's Python Script and Rename to dc-lookup.py
echo "Downloading Ralph's Python script and renaming to dc-lookup.py..."
wget -O "${TOOLS_DIR}/dc-lookup.py" "${RALPH_SCRIPT_URL}"
if [ $? -eq 0 ]; then
  echo "Ralph's Python script downloaded and renamed to dc-lookup.py in ${TOOLS_DIR}."
else
  echo "Failed to download Ralph's Python script. Please check the URL or your connection."
fi

# Step 8: Reload zshrc (optional, as requested)
echo "Reloading shell configuration..."
source ~/.zshrc || echo "Shell configuration reloaded."

# Final Notes
echo "Setup complete. Manual steps remaining:"
echo "1. Open tmux and hit CTRL+B Shift+I to load the tmux configuration."
echo "2. Begin your engagement in the newly created directory: ${ENGAGEMENT_DIR}"
