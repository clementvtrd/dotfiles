local="${1:-$(pwd)/fonts}"

sudo cp -r ${local}/JetBrainsMono /usr/share/fonts/truetype
sudo cp -r ${local}/MesloLGS /usr/share/fonts/truetype

fc-cache