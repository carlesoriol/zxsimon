
; a = new attrib to all screen

cls_attribs:
				ld hl, attributes_start
				ld de, attributes_start + 1
				ld bc, attributes_size - 1			
				ld (hl), a
				ldir			
				ret


; BC = y, x in pixels
; torna DE
attribute_coords_pixel:	
				
				srl b
				srl b
				srl b
				srl c
				srl c
				srl c

; BC = y, x in chars
; torna DE
; modifica bc, de, a			
attribute_coords:	
	
				ld a, b		
				rrca
				rrca
				rrca
				ld e, a
				and %00000011
				or  %01011000
				ld d, a
				ld a,e
				and %11100000
				add a, c
				ld e, a
				
				ret			


; hl = attribs pointer - Array of  X,Y,WIDTH,  X,Y,WIDTH, ...  255 terminated
; a = value

paint_attribtues:
	
				ld (paint_attribtues_dopaint+1), a	; modify code

		paint_attribtues_loop:		
				ld a, (hl)
				cp 255
				ret z
				
				ld c, a
				inc hl
				ld b, (hl)
				
				call attribute_coords	; BC (YX) converted to DE pointer
				
				inc hl
				ld b, (hl)
				
			paint_attribtues_dopaint:	
				ld a, 0					; 0 modified ay begining
			paint_attribtues_dopaint_loop:
				ld (de), a
				inc de
				djnz paint_attribtues_dopaint_loop
				
				inc hl
				jr paint_attribtues_loop
	
	
; a = button
; c = color
; modifies hl, de, a
paint_button:
				ld hl, green_button_attrib
				ld de, red_button_attrib - green_button_attrib
			
				or a 
				jr z, paint_button_mult_end
				
			paint_button_mult:	
				add hl, de
				dec a
				jr nz, paint_button_mult
			paint_button_mult_end:		
					
				ld a, c
				call paint_attribtues
				
				ret
				
				
; a = key to lite (%00 to %11, green,red,yellow,cyan)
; c = 0 released 1 pressed 
button_light:					
				ld b, a					; keep a
				
				ld de, button_off_colors	; button_on_colors + a
				ld a, c
				or a
				jr z, button_key_cont
					ld de, button_on_colors	; button_on_colors + a
				
			button_key_cont:
				
				ld a, b
				add a, e
				ld e, a					; de points to on color
				
				jr nc, button_light_cont
					inc d
			button_light_cont:
			
				ld a, (de)				
				ld c, a					; paint_button c=color
				
				ld a,b					; recover a	paint_button a=nbutton
				
				call paint_button										
										
				ret
		
; hl = pointer to structure	array of attrib_pointer, attirb_ponter...  0 terminated
; b = color

add_attribtues_light:	

				ld a, (hl)
				ld e, a
				inc hl
				ld a, (hl)			
				ld d, a
				inc hl
				or e
				ret z
							
				ld a,(de)	
				and %00111000		
				or b
				ld (de), a
				jr add_attribtues_light
					
	last_lights_color defb 0

next_lights_color:			; iterates attributes flashing light element

				ld a, (last_lights_color)
				inc a								
				cp 6
				jr nz, next_lights_color_cont
					xor a
			next_lights_color_cont:
				ld (last_lights_color), a
				ret
					



flash_lights_lost:					; flash lights lose
			ld ix, colors_round_lost
			
			jr flash_lights_enter	; skips ix win asignation in flash lights

; a = color button 
; modifies ix, hl, a, bc, de
flash_lights:						; flash lights win
			
			ld ix, colors_round	
			
		flash_lights_enter:
			or a
			jr nz, flash_lights_nogreen
				ld hl, flash_green
				jr flash_lights_cont
		flash_lights_nogreen:
		
			cp 1
			jr nz, flash_lights_nored
				ld hl, flash_red
				jr flash_lights_cont
		flash_lights_nored:
		
			cp 2
			jr nz, flash_lights_nocyan
				ld hl, flash_cyan
				jr flash_lights_cont
		flash_lights_nocyan:
		
			ld hl, flash_yellow		
		
		flash_lights_cont:
			
			ld c, 5
			
	flash_lights_loop:
			
			call next_lights_color
			ld ($+5),a			
			ld a, (ix+0)		; ix+ a
			ld b, a
			call add_attribtues_light
			
			dec c
			jr nz, flash_lights_loop
			
				
			ret
			
				
				
				
				
				
				
				
				

