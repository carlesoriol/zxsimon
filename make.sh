#!/bin/sh

zmakebas -a 10 -n "ZXSimon" -o loader.tap simon.bas

lz4 -12 -k -f simon.scr
lz4 -12 -k -f simon_logo.scr
lz4 -12 -k -f simon_manual_1.scr

pasmo --tap --name screen simon_logo_lz4.asm simon_logo_lz4.tap 
pasmo -d --tap simon.asm main.tap

cat loader.tap simon_logo_lz4.tap main.tap > simon.tap

cp simon.tap bin/

#fuse-gtk --no-confirm-actions -m 48 -t simon.tap 
#fuse-sdl --no-confirm-actions -m 48 -t simon.tap --full-screen

#RetroVirtualMachine -width=32768 -boot=zx48k -i simon.tap -play -c='j ""\n'
RetroVirtualMachine -boot=zx48k -i simon.tap -play -c='j ""\n'
