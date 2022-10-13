local="${1:-$(pwd)/git}"

cp ${local}/.gitconfig   ~/.gitconfig
ln -s ${local}/.gitignore   ~/.gitignore
