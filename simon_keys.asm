
ks_map:

ks_mnb:			defb 	0
ks_lkjh:		defb 	0
ks_poiuy:		defb	0
ks_09876:		defb	0
ks_12345:		defb	0
ks_qwert:		defb	0
ks_asdfg:		defb	0
ks_zxcv:		defb	0

ks_debouncers:

ks_db_mnb:		defb 	0
ks_db_lkjh:		defb 	0
ks_db_poiuy:	defb	0
ks_db_09876:	defb	0
ks_db_12345:	defb	0
ks_db_qwert:	defb	0
ks_db_asdfg:	defb	0
ks_db_zxcv:		defb	0


; reads all keys map
; modifies	a, hl, bc, de
readallkeys:

				ld b, %01111111
				ld hl, ks_mnb
				ld de, ks_db_mnb

	readallkeys_loop:
				ld a, (hl)
				ld (de), a
	
				xor a
				ld c, #fe
				in a,(c)
				cpl
				ld (hl), a
				
				inc hl
				inc de
								
				rrc b
				bit 7, b
				jr nz, readallkeys_loop
				
				ret
				
; hl=segment pointer
; b=key
check_key_pressed:				
				ld a, (hl)				
				and b
				ret z
				
				ld de, 8
				add hl, de
				
				ld a, (hl)				
				cpl 
				and b
				ret 

; hl=segment pointer
; b=key
check_key_released:				
				ld a, (hl)				
				cpl
				and b
				ret z
				
				ld de, 8
				add hl, de
				
				ld a, (hl)								
				and b
				ret 
				
waitnokey:
				xor a
				in a,(#fe)
				cpl
				and %00111111
				jr	nz, waitnokey
				ret

waitkey:
				xor a
				in a,(#fe)
				cpl
				and %00111111
				jr	z, waitkey
				ret

