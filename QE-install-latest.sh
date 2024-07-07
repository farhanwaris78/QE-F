#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.
set -u  # Treat unset variables as an error when substituting.

# Function to print colored output
print_colored() {
    echo -e "\e[1;34m$1\e[0m"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update list of repositories and upgrade the system
print_colored "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

# Install important development tools and libraries
print_colored "Installing development tools and libraries..."
sudo apt install -y git wget build-essential g++ gfortran liblapack-dev libfftw3-dev libopenmpi-dev

# Download latest git file of QE
print_colored "Cloning Quantum ESPRESSO repository..."
git clone --depth 1 https://github.com/QEF/q-e.git
cd q-e

# Configure and build QE
print_colored "Configuring Quantum ESPRESSO..."
./configure

print_colored "Building Quantum ESPRESSO..."
make -j$(nproc) all
make -j$(nproc) w90

# Add QE binaries to PATH
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo 'export PATH="'"$SCRIPT_DIR"'/q-e/bin:$PATH"' >> ~/.bashrc

# Go back to the original directory
cd ..

# Install PWgui
print_colored "Installing PWgui..."
PWGUI_VERSION="7.0"
PWGUI_FILE="pwgui-${PWGUI_VERSION}-linux-x86_64.tgz"
wget "http://www-k3.ijs.si/kokalj/pwgui/download/${PWGUI_FILE}"
tar zxvf "$PWGUI_FILE"
rm "$PWGUI_FILE"

# Add PWgui to PATH
echo 'export PATH="'"$PWD"':$PATH"' >> ~/.bashrc

# Create symlink for pwgui
sudo ln -sf "$PWD/pwgui" /usr/local/bin/pwgui

# Install additional tools
print_colored "Installing additional tools..."
sudo apt install -y xcrysden gnuplot python3-dev python3-pip
pip3 install --upgrade pip
pip3 install numpy scipy sympy matplotlib jupyterlab

# Source .bashrc to apply changes immediately
source ~/.bashrc

# Completion message
print_colored "
   ______     __  __     ______     _    __     ______   __  __     __    __            
  /\  __ \   /\ \/\ \   /\  __ \   /\ `-.\ \   /\__  _\ /\ \/\ \   /\ `-./  \           
  \ \ \/\_\  \ \ \_\ \  \ \  __ \  \ \ \_ ` \  \/_/\ \/ \ \ \_\ \  \ \ \-./\ \          
   \ \___\_\  \ \_____\  \ \_\ \_\  \ \_\ \\_\    \ \_\  \ \_____\  \ \_\ \ \_\         
    \/___/_/   \/_____/   \/_/\/_/   \/_/ \/_/     \/_/   \/_____/   \/_/  \/_/         
                                                                                        
   ______     ______     ______   ______     ______     ______     ______     ______    
  /\  ___\   /\  ___\   /\  == \ /\  == \   /\  ___\   /\  ___\   /\  ___\   /\  __ \   
  \ \  __\   \ \___  \  \ \  _-/ \ \  __<   \ \  __\   \ \___  \  \ \___  \  \ \ \/\ \  
   \ \_____\  \/\_____\  \ \_\    \ \_\ \_\  \ \_____\  \/\_____\  \/\_____\  \ \_____\ 
    \/_____/   \/_____/   \/_/     \/_/ /_/   \/_____/   \/_____/   \/_____/   \/_____/ 
                                                                                     
print_colored "Installation finished!"
print_colored "Lets start our journey with the latest version of QuantumESPRESSO!"
