#!/bin/bash
# (Intended for Kali Linux)
# Even though the repo and folders say 'evilginx2,' this is actually evilginx3.
RED="\033[1;31m"
DEFAULT="\033[0m"
GREEN="\033[0;32m"
if [ "$EUID" -eq 0 ]; then
	echo -e "${RED}[-]${DEFAULT} Please run this script WITHOUT sudo. (#~$ ./Evilginx-Installer.sh)"
	echo "    You will be prompted for your password for commands that require it."
	exit 1
fi
echo ""
echo -e "${GREEN}[+]${DEFAULT} Creating management directory"
mkdir ~/Desktop/Evilginx/
cd ~/Desktop/Evilginx/
echo -e "${GREEN}[+]${DEFAULT} Installing dependencies (This will take a moment)..."
sleep 2.5
sudo apt install git make gcc libpcap-dev golang certbot -y
if [ $? -ne 0 ]; then
	echo -e "${RED}[-]${DEFAULT} installation failed. See apt message for context."
	exit 1
fi
echo ""
echo -e "${GREEN}[+]${DEFAULT} Cloning into kgretzky/evilginx repository..."
sleep 1
git clone https://github.com/kgretzky/evilginx2.git
echo ""
echo -e "${GREEN}[+]${DEFAULT} Building EvilginX binary (This will take a moment)..."
sleep 2
cd evilginx2
go build -o evilginx
echo -e "${GREEN}[+]${DEFAULT} Evilginx directory contents:"
ls
echo ""
sleep 1
echo -e "${GREEN}[+]${DEFAULT} Adding EvilginX binary to /usr/local/bin for pathless calling."
sleep 1
sudo mv evilginx /usr/local/bin
echo ""
echo -e "${GREEN}[+]${DEFAULT} Finished! To launch, ensure you are in your evilginx2 directory (Inside the Evilginx dir) and type: "
echo "#~$ evilginx -p ./phishlets"
exit 0
