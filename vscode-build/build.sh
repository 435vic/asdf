#!/bin/bash

echo "This script will download and build a patched version of VSCode."
read -r -p "Are you sure to continue? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    mkdir -p .vscodium_build
    cd .vscodium_build
    echo "Setting environment variables..."
    export CC=/usr/bin/cc
    export CXX=/usr/bin/c++
    echo "Running git clone..."
    if [ -d vscode ]; then
        echo "Found existing vscode repository. Getting it up to date..."
        cd vscode 
        git fetch --all
    else
        git clone https://github.com/Microsoft/vscode.git
        cd vscode
    fi
    echo "Detecting latest version..."
    export LATEST_MS_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
    echo "Done. Latest tag is ${LATEST_MS_TAG}"
    read -r -p "Do you want to build the latest version? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        version=${LATEST_MS_TAG}
        output=$(git branch | awk '/\*/ { print $2; }')
        if [[ $output != "${LATEST_MS_TAG}" ]]; then
            git checkout -b $LATEST_MS_TAG
        else
            echo "Already in branch. Continuing..."
        fi
    else
        read -r -p "Select a version: " version
        git checkout -b $version > /dev/null
        if [[ $? == 1 ]]; then
            echo "Invalid version. Try again or build latest release."
            exit 1
        fi
        echo "Now building from VSCode version ${version}"
    fi
    
    echo "Patching gulpfiles to build on 4 GiB device..."
    sed -i 's|require("gulp-sourcemaps");|{write:()=>gulpUtil.noop(),init:()=>gulpUtil.noop()};|' build/lib/optimize.js
    sed -i 's|--max_old_space_size=[0-9]\+|--max_old_space_size=1700|' package.json
    sed -i 's|yarnInstall..test/smoke|// &|' build/npm/postinstall.js
    echo "Node.js deps will be installed. This may take a moment..."
    yarn
    echo "Patching product.json..."
    mv product.json product.json.bak
    cat product.json.bak | jq 'setpath(["extensionsGallery"]; {"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items"})' > product.json
    cat product.json
    echo "Removing telemetry URL's..."
    TELEMETRY_URLS="(dc\.services\.visualstudio\.com)|(vortex\.data\.microsoft\.com)"
    REPLACEMENT="s/$TELEMETRY_URLS/0\.0\.0\.0/g"
    grep -rl --exclude-dir=.git -E $TELEMETRY_URLS . | xargs sed -i -E $REPLACEMENT
    echo "Done patching."
    echo "Setup is done. VSCode will be built now. This may take around 30 minutes to 1 hour."
    echo "You can build now, or build later."
    read -r -p "Do you want to build now? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        yarn run gulp vscode-linux-arm64-min
        yarn run gulp vscode-linux-arm64-build-deb
        cd VSCode-linux-arm64
        tar czf ../VSCode-linux-arm64-${version}.tar.gz .
        file="vscodium_${version}*.deb"
        cp .build/linux/deb/arm64/deb/${file} .
        echo "Done! A deb file and a tar file have been produced"
        read -r -p "Do you want to install the deb file? [y/N] " response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
            echo "Installing..."
            sudo apt install -y ./${file}
            echo "Done! Hopefully it worked, so try to open it by running vscodium on the command line or running it from your app drawer."
            exit 0
        else
            echo "If you want to install the file later, run the following command:"
            echo "sudo apt install -y ./${file}"
        fi
    else
        echo "Ok. Run the following commands in this directory:"
        echo "yarn run gulp vscode-linux-arm64-min"
        echo "yarn run gulp vscode-linux-arm64-build-deb"
        exit 0
    fi

else
    echo "Ok. You can run the script again if you want to."
fi
