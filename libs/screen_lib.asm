; modified from https://zxasm.wordpress.com/2016/05/28/zx-spectrum-screen-memory-layout/

; Get screen address
; D = Y pixel position
; E = X pixel position
; Returns address in BC and pixel position within character in A
; modifica bc, hl, a, de
get_pixel_addressDE:	

				LD A,B			; Calculate Y2,Y1,Y0
				AND %00000111	; Mask out unwanted bits
				OR %01000000	; Set base address of screen
				LD D,A			; Store in H
				LD A,B			; Calculate Y7,Y6
				RRA				; Shift to position
				RRA
				RRA
				AND %00011000	; Mask out unwanted bits
				OR D			; OR with Y2,Y1,Y0
				LD D,A			; Store in H
				LD A,B			; Calculate Y5,Y4,Y3
				RLA				; Shift to position
				RLA
				AND %11100000	; Mask out unwanted bits
				LD E,A			; Store in L
				LD A,C			; Calculate X4,X3,X2,X1,X0
				RRA				; Shift into position
				RRA
				RRA
				AND %00011111	; Mask out unwanted bits
				OR E			; OR with Y5,Y4,Y3
				LD E,A			; Store in L
				
				LD A,C			; keep offset in a
				AND 7
				RET
				
; screen position DE calculates 1 pixel down position
; modifies de, a
Pixel_Address_Down_DE:
					
				INC D			; Go down onto the next pixel line
				LD A,D			; Check if we have gone onto next character boundary
				AND 7
				RET NZ			; No, so skip the next bit
				LD A,E			; Go onto the next character line
				ADD A,32
				LD E,A
				RET C			; Check if we have gone onto next third of screen
				LD A,D			; Yes, so go onto next third
				SUB 8
				LD D,A
				RET


; bc = y x
; hl = sprite structure
; no mask no bit op
; modifies bc, hl, a, de, af'
pintasprite:

				call get_pixel_addressDE
				
				ld a, (hl)
				srl a
				srl a
				srl a
				ld (pintasprite_keepx+1), a	
				
				inc hl
				ld a, (hl)				
				inc hl
													
			pintasprite_loopy:
				push de
			pintasprite_keepx:
				ld b, 0x00			; dynamically modified
				ex af, af'
			pintasprite_loopx:
				ld a,(hl)				
				ld (de), a
				inc de
				inc hl
				djnz pintasprite_loopx
				
				pop de
				call Pixel_Address_Down_DE				
				ex af, af'
				dec a
				jr nz, pintasprite_loopy				
			
				ret

