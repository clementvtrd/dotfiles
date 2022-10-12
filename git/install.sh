local="${1:-$(pwd)/git}"

ln -s ${local}/.gitconfig   ~/.gitconfig
ln -s ${local}/.gitignore   ~/.gitignore
