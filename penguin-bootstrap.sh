#!/bin/bash

cat << "EOF"

                              _,met$$$$$gg.
                           ,g$$$$$$$$$$$$$$$P.
                         ,g$$P""       """Y$$.".
                        ,$$P'              `$$$.
                      ',$$P       ,ggs.     `$$b:
                      `d$$'     ,$P"'   .    $$$
                       $$P      d$'     ,    $$P
                       $$:      $$.   -    ,d$$'
                       $$;      Y$b._   _,d$P'
                       Y$$.    `.`"Y$$$$P"'
                       `$$b      "-.__
                        `Y$$b
                         `Y$$.
                           `$$b.
                             `Y$$b.
                               `"Y$b._
                                   `""""             ,'`.             ,'`.
                                                    `.  ,'           `.  ,'
  ,d$$$$b. `$$,d$$$$g  ,d$$$$Pb   ,.$$$$$b    ,$P     `'     _         `'
 ,$P'    '  $$$'    ' ,$P     d$, "P'         $$       _,  `$$,d$$b.    _,
 $$'        $$        $$'     '$$ $P       'd$$$$$.  `$$'   $$$' `$$  `$$'
 $$.        $$        $$       $$ `$$$$$b.    $$      $$    $$'   $$   $$
 $$.        $$        $$.     ,$$        $P   $$      $$    $$    $$   $$
 `$$._ _.,  $$        `$$._ _.$$'     _,g$P' `$g.     $$    $$    $$   $$
  `Y$$$$P' ,$$.        `Y$$$$$Y'  $$$$$P"'    `Y$$P  ,$$.  .$$.  ,$$. ,$$.



EOF

# mv product.json product.json.bak cat product.json.bak | jq 'setpath(["extensionsGallery"]; {"serviceUrl": "http://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items"})' > product.json

echo "Let's bootstrap this container! This script will install many useful tools and programs."
read -r -p "Are you sure to continue? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  echo "First of all, let's set our password."
  sudo passwd $USER
  echo "========== Packages and programs =========="
  echo "As always, let's update and upgrade."
  sudo apt-get update
  sudo apt-get -y upgrade
  echo "First, some essential apt packages will be installed."
  echo "File, binwalk, nano, shellcheck and wget will all be installed."
  sudo apt-get install -y wget file binwalk nano shellcheck
  echo "Pip3 and tkinter will be installed..."
  sudo apt-get install -y python3-pip python3-tk
  echo "Now, let's install some pip packages."
  pip3 install pycryptodomex tqdm
  echo "Finally, we'll install terminator."
  sudo apt install -y terminator
  echo "========== SSH setup =========="
  echo "The ssh service is disabled by default. We first need to start it..."
  sudo rm /etc/ssh/sshd_not_to_be_run
  echo "Next, SSH keys for this device will be generated in a folder called SSHKeys."
  echo "These keys will provide authentication to ssh into this device."
  mkdir ~/SSHKeys
  ssh-keygen -f ~/SSHKeys/penguin -C ""
  echo "Adding these new keys to authorized_keys..."
  mkdir -p .ssh
  cat SSHKeys/penguin.pub  >> ~/.ssh/authorized_keys
  echo "Done! Copy the keys to the machine you want to ssh from to this device."
  echo "========== Command line interpreter =========="
  echo "Let's pump your command line UP! First, let's get zsh up and running."
  sudo apt install -y zsh
  echo "Time to add the main ingredient: oh my ZSH!"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh -l//')"
  echo "Done. Time to add the spaceship prompt!"
  zsh << "EOF"

  git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
  ln -s ln -s "~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "~/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

  EOF
  zsh -c "git clone https://github.com/denysdovhan/spaceship-prompt.git \"$ZSH_CUSTOM/themes/spaceship-prompt\" && ln -s \"$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme\" \"$ZSH_CUSTOM/themes/spaceship.zsh-theme\""
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="spaceship"/' ~/.zshrc
  echo "Done!"
  echo "Now, fira code and fira mono will be installed."
  bash <(curl -fsSL https://435vic.github.io/asdf/firacode.sh)
  sudo wget -O /usr/share/fonts/FiraMonoRegular-Powerline.otf https://github.com/powerline/fonts/raw/master/FiraMono/FuraMono-Regular%20Powerline.otf
  fc-cache -f
  echo "WE ARE DONE!! To finish, zsh will be launched."
  env zsh -l
else
  echo "Ok."
fi

