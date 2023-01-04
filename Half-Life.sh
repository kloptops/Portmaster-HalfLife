#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/tasksetter

get_controls
## TODO: add a help wiki link here?
HELP_WIKI_LINK="HELP_WIKI_LINK"

GAMEDIR="/$directory/ports/Half-Life"
cd $GAMEDIR

# Grab text output...
$ESUDO chmod 666 /dev/tty0
printf "\033c" > /dev/tty0

# First time run
if [[ -f "${GAMEDIR}/binaries/first_run" ]]; then
  if [[ ! -f "valve/halflife.wad" ]]; then
    echo "No game files found, check $HELP_WIKI_LINK for details on installing game files."
    exit 1
  fi

  echo "Copying handheld binaries/config files." > /dev/tty0 2>&1

  $ESUDO cp -rfv "${GAMEDIR}/binaries/valve" "${GAMEDIR}/" > /dev/tty0 2>&1

  # Mark step as done
  $ESUDO rm -f "${GAMEDIR}/binaries/first_run"
fi

$ESUDO chmod 666 /dev/tty1
$ESUDO chmod 666 /dev/uinput
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib32:$GAMEDIR/valve/dlls:$GAMEDIR/valve/cl_dlls"

$GPTOKEYB "xash3d" &
$TASKSET ./xash3d -ref gles2 -fullscreen -console 2>&1 | tee -a ./log.txt

$ESUDO kill -9 $(pidof gptokeyb)
unset LD_LIBRARY_PATH
unset SDL_GAMECONTROLLERCONFIG
$ESUDO systemctl restart oga_events &

# Disable console
printf "\033c" >> /dev/tty1
