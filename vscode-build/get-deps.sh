echo "updating and upgrading..."
sudo apt update
sudo apt upgrade
echo "Installing apt packages..."
sudo apt install -y libsecret-1-dev git python2.7 clang make libx11-dev libxkbfile-dev fakeroot rpm
echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
echo "Sourcing scripts..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
echo "Downloading node 8..."
nvm install 8
echo "Changing to node 8..."
nvm use 8
echo "Installing yarn..."
npm install -g yarn
echo "Done!"
