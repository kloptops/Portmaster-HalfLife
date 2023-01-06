# Portmaster-HalfLife


This is the configuration files and the required steps to build the xash3d engine for handheld emulator devices (Anbernic RG353V, etc.) using the Portmaster scripts for launching.


# Installation


To install unzip into your `ports` folder, copy over the `valve` folder from your steam installation of the game into `ports/Half-Life/valve`.

If you want to play Half Life: Blue Shift or Half Life Opposing Forces copy over the `bshift` and/or `gearbox` folders from your steam installations of the games.

_Note: Currently it doesnt matter if you use Windows, Linux or MacOS versions of the game. On MacOS it will state that the games are incompatible if you have a newer OS, that doesnt matter, install it anyway._

# Controls


- Left Analog: Move/Strafe
- Right Analog: Look
- A_BUTTON: Use
- B_BUTTON: Jump
- X_BUTTON: Flashlight
- Y_BUTTON: Reload
- L1: Crouch
- L2: Walk
- R1: Fire
- R2: Alt-Fire
- DPAD_UP: Spray
- DPAD_LEFT: Last Weapon
- DPAD_RIGHT: Next Weapon
- DPAD_DOWN: Quick Swap
- Start: Pause
- Select + X: Menu
- Select + L1: Quick Load
- Select + R1: Quick Save
- Select + B: Screenshot
- Select + Start: Quit


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
    ./waf install --destdir=../build

    cd ..

    cd hlsdk-portable

    # Half-Life client files
    git checkout master
    ./waf configure -T release --64bit
    ./waf clean
    ./waf build
    ./waf install --destdir=../build

    # Blue shift client files
    git checkout bshift
    ./waf configure -T release --64bit
    ./waf clean
    ./waf build
    ./waf install --destdir=../build

    # Opforce client files
    git checkout opfor
    ./waf configure -T release --64bit
    ./waf clean
    ./waf build
    ./waf install --destdir=../build

    cd ..


At the end all the binary stuff is in `build`.

Finally run `./build.py` to combine the compiled files in `build` with the script/config files suitable for Portmaster distribution.

# TODO:

- [ ] Add launch scripts for Blue Shift / Opposing Forces to the ports directory when they're detected.
- [ ] Consolidate the autoexe.cfg / config.cfg / opengl.cfg files.
- [ ] Better installation instructions
