

move_slider_sound:
				ld hl, #20	
				ld de, 1			
				call beeper				
				ret

get_ts_pointer:
				ld ix, sounds_tables
				ld a, (sound_table)
				sla a
				sla a
				sla a
				sla a
				ld b, 0
				ld c, a
				add ix, bc
				ret

; a = button
button_sound:	
				ld d, a
				call get_ts_pointer		; ix points to sound table
				ld a,d
				
				ld bc, 0x0004
				or a
				jr z, play_ix_sound
				
	button_sound_mult:					
				add ix, bc
				dec a
				jr nz, button_sound_mult				
				
	play_ix_sound:
				ld l, (ix+0)
				ld h, (ix+1)
				ld e, (ix+2)
				ld d, (ix+3)				
				call beeper            
				ret
	

losing_sound:
				ld hl, 10387	
				ld de, 50		
				call beeper				
				ret


change_table_sounds:
				ld a, (sound_table)
				inc a
				and %11						
				ld (sound_table), a
				ret
		

win_razz:		defb 	0, 1, 3, 2, 2
				defb 	0, 1, 3, 2, 2
				defb 	0, 1, 3, 2, 2
				defb 	3, 2, 2, 2, 2
win_razz_end:

win_razz_len:	equ 	win_razz_end-win_razz


sound_table:			defb 	0

sounds_tables:		

sound_v1:		
sound_v1_green:			defw	2335, 15
sound_v1_red:			defw	1742, 20
sound_v1_cyan:			defw	1152, 30
sound_v1_yellow:		defw	1376, 25


sound_pocket:		
sound_pocket_green:		defw	2063, 13
sound_pocket_red:		defw	1706, 15
sound_pocket_cyan:		defw	1024, 25
sound_pocket_yellow:	defw	1381, 19


sound_v2:		
sound_v2_green:			defw	2202, 12
sound_v2_red:			defw	1642, 16
sound_v2_cyan:			defw	1086, 24
sound_v2_yellow:		defw	1297, 20


sound_v4:		
sound_v4_green:			defw	1024, 25
sound_v4_red:			defw	1381, 19
sound_v4_cyan:			defw	2063, 13
sound_v4_yellow:		defw	1706, 15












