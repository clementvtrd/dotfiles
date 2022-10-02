sudo apt update
sudo apt upgrade -y

sh ./fonts/install.sh     "$(pwd)/fonts"
sh ./packages/install.sh  "$(pwd)/packages"
sh ./shell/install.sh     "$(pwd)/shell"
