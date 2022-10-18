local="${1:-$(pwd)/shell}"

# Create required directory
mkdir -p ~/.config/alacritty
rm -rf ~/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Create symlink
ln -s ${local}/alacritty.yml      ~/.config/alacritty/alacritty.yml
ln -s ${local}/.p10k.zsh          ~/.p10k.zsh
ln -s ${local}/.zshrc             ~/.zshrc
ln -s ${local}/.zsh_profile.zsh   ~/.zsh_profile.zsh
ln -s ${local}/.zsh_alias.zsh     ~/.zsh_alias.zsh

# Install dependencies
sudo apt install -y zsh exa

# Change current shell
chsh --shell $(which zsh)
sudo chsh --shell $(which zsh)
