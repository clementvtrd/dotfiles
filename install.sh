sudo apt update
sudo apt upgrade -y

sh ./fonts/install.sh     "$(pwd)/fonts"
sh ./shell/install.sh     "$(pwd)/shell"
