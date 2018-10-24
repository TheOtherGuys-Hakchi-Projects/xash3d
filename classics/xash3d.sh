#!/bin/sh

self="$(readlink -f "$0")"
name="$(basename "$self" .sh)"
cdir="$(dirname "$self")"
code="$(basename "$cdir")"
x3dsave="$cdir/valve/save"
varsave="/var/saves/$code"

[ -x "$cdir/$name" ] || chmod +x "$cdir/$name"
mkdir -p "$x3dsave" "$varsave"
[ -f "$varsave/save.sram" ] || touch "$varsave/save.sram" # Create dummy save.sram file to prevent save-state manager from removing the saves
[ "$(mount | grep "/valve/save")" ] || mount -o bind "$varsave" "$x3dsave" # Overmount /path/to/CLV-Z-XASH3D/valve/save so the saves are stocked in /var/saves/CLV-Z-XASH3D instead of the game folder
export XASH3D_BASEDIR="$cdir"
export LD_LIBRARY_PATH="$cdir"
"$cdir/$name" +set joy_index 0 fps_override 1 fps_max 59 -console -fullscreen -log > "$cdir/$name.log"
umount "$x3dsave"
