# Portmaster-HalfLife


This is the configuration files and the required steps to build the xash3d engine for handheld emulator devices (Anbernic RG353V, etc.) using the Portmaster scripts for launching.


# Half Life Xash3d


To install unzip into your Ports folder, copy over the `valve` folder from your steam copy of the game. You have to make sure to not overwrite the included files in `valve`.


## Build Environment


I currently use docker to build it, this is optional

    git clone --recursive https://github.com/RetroGFX/UnofficialOS.git


add "libfontconfig1-dev" to the Dockerfile, as it is the one missing dependancy

    make docker-image-build


My UnofficialOS & Half Life stuff is currently in `~/Half-Life`, so to run the docker image I do:


    docker run  -it --init --env-file .env --rm --user 1000:1000  -v $HOME/Half-Life:$HOME/Half-Life -w $HOME/Half-Life  "justenoughlinuxos/jelos-build:latest" bash


## Building

    git clone --recursive https://github.com/FWGS/hlsdk-portable.git
    git clone --recursive https://github.com/FWGS/xash3d-fwgs.git

    # Build main engine
    cd xash3d-fwgs

    ## requires --enable-static-gl to work.
    ./waf configure -T release --enable-gles2 --enable-static-gl
    ./waf clean
    ./waf build
    ./waf install --destdir=../output

    cd ..

    cd hlsdk-portable

    # Half-Life client files
    git checkout master
    ./waf configure -T release --64bit
    ./waf clean
    ./waf build
    ./waf install --destdir=../output

    # Blue shift client files
    git checkout bshift
    ./waf configure -T release --64bit
    ./waf clean
    ./waf build
    ./waf install --destdir=../output

    cd ..


At the end all your fun stuff is in `output`.

