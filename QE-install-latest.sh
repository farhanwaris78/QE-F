#!/bin/bash

# Update list of repositories and upgrade the system
sudo apt -y update
sudo apt -y upgrade

# Important development tools and libraries:
# Git, wget, gcc/g++/gfortran, LAPACK, FFTW, openmpi (mpirun)
sudo apt -y install git wget build-essential g++ gfortran liblapack-dev libfftw3-dev libopenmpi-dev

#Download latest git file of QE
git clone https://github.com/QEF/q-e.git
cd q-e

./configure

make all
make w90

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo 'export PATH="'"$SCRIPT_DIR"'/q-e/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Quantum ESPRESSO and Wannier90
sudo apt -y install quantum-espresso wannier90

# Additional tools
sudo apt -y install xcrysden gnuplot
sudo apt -y install python3-dev python3-pip
pip3 install numpy scipy sympy matplotlib jupyterlab
#echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
#source ~/.bashrc

# Completion message
echo "Installation finished!"
echo "Let's start our journey with QuantumESPRESSO!"
