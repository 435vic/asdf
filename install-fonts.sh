echo "getting Fira Mono for Powerline..."
sudo mkdir -p /usr/share/fonts/opentype
curl -L https://github.com/powerline/fonts/raw/master/FiraMono/FuraMono-Regular%20Powerline.otf | sudo tee /usr/share/fonts/opentype/FuraMono-Powerline.otf
echo "getting Fira Code..."
mkdir -p ~/tmp/firacode
curl -L https://github.com/tonsky/FiraCode/releases/download/1.206/FiraCode_1.206.zip > ~/tmp/FiraCode_1.206.zip
unzip ~/tmp/FiraCode_1.206.zip -d ~/tmp/firacode
sudo cp ~/tmp/firacode/ttf/FiraCode-Retina.ttf /usr/share/fonts/truetype/
sudo cp ~/tmp/firacode/ttf/FiraCode-Regular.ttf /usr/share/fonts/truetype/
echo "cleaning up..."
rm -r ~/tmp/firacode ~/tmp/FiraCode*.zip
echo "Done!"
