
org 0x8000

; parameters hl = screen pointer
; modifies hl, de, bc
show_screen:				
				ld hl, simonlogo
				ld de,0x4000			
				call DecompressLZ4Data
			
				ret
				
include "libs/lz4_lib.asm"

simonlogo:
incbin "simon_logo.scr.lz4"

