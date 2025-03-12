#!/bin/bash
# (Intended for ParrotSec OS)
# === THIS SCRIPT REQUIRES SUDO PERMISSIONS TO RUN! ===
# This script installs dependencies for the Havoc C2 Framework and deploys the Teamserver & Client. 
# To execute the Havoc Client interface after installation, please enter the /Havoc directory and run the following command:
# ./havoc client
#
# Download this script and execute it in your Desktop with sudo permissions.
# 
###
echo ""
echo '_____________________________________________ '
echo '          _______           _______  _______ '
echo '|\     /|(  ___  )|\     /|(  ___  )(  ____ \'
echo '| )   ( || (   ) || )   ( || (   ) || (    \/'
echo '| (___) || (___) || |   | || |   | || |      '
echo '|  ___  ||  ___  |( (   ) )| |   | || |      '
echo '| (   ) || (   ) | \ \_/ / | |   | || |      '
echo '| )   ( || )   ( |  \   /  | (___) || (____/\'
echo '|/     \||/     \|   \_/   (_______)(_______/'
echo '============== INSTALLER SCRIPT ============== '
###
echo "Verifying sudo permissions..."
if [ "$EUID" -ne 0 ]
  then echo "[-] Please re-run this script as root ('sudo ./HavocC2-Helper.sh')"
  exit
fi
echo ""
echo "[+] Creating Havoc Setup directory..."
sleep 2
mkdir Havoc-Setup
cd Havoc-Setup
#Cloning into Havoc Github
echo "[+] Cloning Havoc C2 github contents into our local setup directory..."
git clone https://github.com/HavocFramework/Havoc.git
cd Havoc
echo "Havoc directory contents:"
ls
### Primary dependencies for Havoc
echo ""
echo "[+] Dont worry about the incoming errors. We solve those in a second."
sleep 4
sudo apt install -y git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev python3-dev libboost-all-dev mingw-w64 nasm
# Install remaining
echo ""
sudo apt install libdrm2
sudo apt install libdrm2-intel1
sudo apt install libdrm2-dev
### End primary dependencies for Havoc
echo ""
echo "[+] BE PATIENT. This next section will take a moment. It won't show anything on-screen, but it's building a lot in the background. Just let it do its thing."
sleep 4
echo ""
cd teamserver/
echo "Teamserver directory contents:"
ls
echo ""
echo "[+] Installing Teamserver requisites"
go mod download golang.org/x/sys
cd ..
make ts-build
echo ""
#Dependency handling for cmake
echo "[+] Running Initial Update..."
sudo apt update
echo ""
echo "[+] Installing remaining Havoc-Client dependencies..."
sudo apt install -y qtbase5-dev qtdeclarative5-dev libqt5websockets5 libqt5websockets5-dev cmake
echo ''
sudo make client-build
echo ""
echo "[+] Finished!"
echo "[NOTE] Changed directory to /Havoc directory. Havoc commands will need to be run within this directory to succeed."
echo ""
echo "=== Connection information ==="
echo "- Name: CIS460 TeamServer"
echo "- Host: 172.16.0.165"
echo "- Port: 40056"
echo "- User: (Given in class)"
echo "- Pass: (Given in class)"
echo "=============================="
echo ""
echo "[+] To launch your Havoc C2 interactive client, run the following command:"
echo "'./havoc client'"
echo ""
echo "[NOTE]Your professor manages whitelisted users. He will give you your username & password for login. Please wait!"
echo "[NOTE] By the way, everything everyone does in the Teamserver is recorded via logging!"
