# Create required directory
mkdir -p ~/.config/alacritty
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Create symlink
ln -s ./alacritty.yml  ~/.config/alacritty.yml
ln -s ./.p10k.zsh      ~/.p10k.zsh
ln -s ./.zshrc         ~/.zshrc

# Install dependencies
sudo apt install -y zsh alacritty

# Change current shell
chsh --shell $(which zsh)
sudo chsh --shell $(which zsh)
