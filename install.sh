sudo apt update
sudo apt upgrade -y

sh ./git/install.sh       "$(pwd)/git"
sh ./fonts/install.sh     "$(pwd)/fonts"
sh ./shell/install.sh     "$(pwd)/shell"
