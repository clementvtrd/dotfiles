local="${1:-$(pwd)/packages}"

sudo apt install -y ${local}/*.deb
