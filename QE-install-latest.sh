#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Update list of repositories and upgrade the system
sudo apt -y update
sudo apt -y upgrade

# Important development tools and libraries:
# Git, wget, gcc/g++/gfortran, LAPACK, FFTW, openmpi (mpirun)
sudo apt -y install git wget build-essential g++ gfortran liblapack-dev libfftw3-dev libopenmpi-dev

# Download latest git file of QE
git clone https://github.com/QEF/q-e.git
cd q-e

# Configure and build QE
./configure
make all
make w90

# Add QE binaries to PATH
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo 'export PATH="'"$SCRIPT_DIR"'/bin:$PATH"' >> ~/.bashrc

# Go back to the original directory
cd ..

# Additional tools
sudo apt -y install xcrysden gnuplot
sudo apt -y install python3-dev python3-pip
pip3 install numpy scipy sympy matplotlib jupyterlab

# Source .bashrc to apply changes immediately
source ~/.bashrc

# Completion message
echo "
   ______     __  __     ______     __   __     ______   __  __     __    __            
  /\  __ \   /\ \/\ \   /\  __ \   /\ \-.\ \   /\__  _\ /\ \/\ \   /\ \-./  \           
  \ \ \/\_\  \ \ \_\ \  \ \  __ \  \ \ \-.  \  \/_/\ \/ \ \ \_\ \  \ \ \-./\ \          
   \ \___\_\  \ \_____\  \ \_\ \_\  \ \_\ \\_\    \ \_\  \ \_____\  \ \_\ \ \_\         
    \/___/_/   \/_____/   \/_/\/_/   \/_/ \/_/     \/_/   \/_____/   \/_/  \/_/         
                                                                                        
   ______     ______     ______   ______     ______     ______     ______     ______    
  /\  ___\   /\  ___\   /\  == \ /\  == \   /\  ___\   /\  ___\   /\  ___\   /\  __ \   
  \ \  __\   \ \___  \  \ \  _-/ \ \  __<   \ \  __\   \ \___  \  \ \___  \  \ \ \/\ \  
   \ \_____\  \/\_____\  \ \_\    \ \_\ \_\  \ \_____\  \/\_____\  \/\_____\  \ \_____\ 
    \/_____/   \/_____/   \/_/     \/_/ /_/   \/_____/   \/_____/   \/_____/   \/_____/ 
                                                                                     "
echo "Installation finished!"
echo "Let's start our journey with the latest version of QuantumESPRESSO!"
