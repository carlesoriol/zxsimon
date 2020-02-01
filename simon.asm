
;				org 0x4000
				
;				logo_screen:	incbin "simon_logo.scr"

				org 0x8000
	
				jr main
				
include "libs/screen_macros.asm"
include "libs/key_macros.asm"

	
game_variables:

				counter:				defw	0
										defw	0
								
				frame_counter:			defw	0
										defw	0
								
				timeout_counter: 		defb	0
				timeout: 				defb	0
								
				onoff:					defb	0				
				game_mode: 				defb	0				
				game_skill:				defb	0				
				playing:				defb	0				
								
				current_pos:			defb	0
				win_pos:				defb 	9

				sequence:				ds		32
				long_sequence:			ds		32
				long_pos:				defb	0

				active_colours			ds		4, 1

				note_speed:				defb	6
				force_note_speed:		defb	0

				current_guess:			defb	0

				current_button:			defb	0xff

				last_button:			defb	0

				game_b_setting_note: 	defb	0

				do_cheat_transcolor:	defb 	PAPER_GREEN | GREEN
										defb 	PAPER_RED | RED
										defb 	PAPER_CYAN | CYAN
										defb 	PAPER_YELLOW | YELLOW

				last_button_light_keep:	defb 0

				win_pos_values:			defb 9,15,21,32				
	


main:
				ld a, BLUE
				out	(#fe), a ;					
				ld ($5C48), a	

;				call waitnokey
;				call waitkey
;				call waitnokey
				
				call show_help
												
				xor a
				ld (onoff), a
				call change_onoff
				
				ld de, rpsinterrupt
				call setInterruptTo		
		
		
		main_loop:						
				
				call readallkeys			

				ld hl, ks_mnb
				ld b, KEY_B
				call check_key_pressed							
				call nz, change_onoff
				
				ld hl, ks_12345
				ld b, KEY_1
				call check_key_pressed								
				call nz, change_game_mode
				
				ld hl, ks_12345
				ld b, KEY_2
				call check_key_pressed							
				call nz, change_skill
				
				ld hl, ks_12345
				ld b, KEY_3
				call check_key_pressed							
				call nz, change_table_sounds
			
			
				ld a, (onoff)
				or a
				jp z, game_skeys_end
			
			
			game_skeys:				
				
				ld hl, ks_qwert
				ld b, KEY_Q
				call check_key_pressed			
				ld a, 0					
				call nz, key_pressed

				ld hl, ks_qwert
				ld b, KEY_Q
				call check_key_released						
				ld a, 0
				call nz, key_released
				
				ld hl, ks_poiuy
				ld b, KEY_P
				call check_key_pressed								
				ld a, 1
				call nz, key_pressed

				ld hl, ks_poiuy
				ld b, KEY_P
				call check_key_released						
				ld a, 1
				call nz, key_released
				
				ld hl, ks_lkjh
				ld b, KEY_L
				call check_key_pressed								
				ld a, 2
				call nz, key_pressed

				ld hl, ks_lkjh
				ld b, KEY_L
				call check_key_released						
				ld a, 2
				call nz, key_released
								
				ld hl, ks_asdfg
				ld b, KEY_A
				call check_key_pressed								
				ld a, 3
				call nz, key_pressed

				ld hl, ks_asdfg
				ld b, KEY_A
				call check_key_released						
				ld a, 3
				call nz, key_released
				
				ld hl, ks_mnb
				ld b, KEY_SPACE
				call check_key_pressed					
				call nz, show_help
				
			game_skeys_nogame:
				
				ld a, (ks_lkjh)
				ld b, KEY_ENTER
				and b 
				call nz, start_game
				
				ld a, (ks_lkjh)
				ld b, KEY_K
				and b 
				call nz, play_razz_sequence
							
							
				ld a, (playing)								
				or a
				jr nz, game_skip_nogamekeys
				
				ld hl, ks_asdfg
				ld b, KEY_F
				call check_key_released						
				call nz, play_sequence
				
				ld hl, ks_lkjh
				ld b, KEY_H
				call check_key_released						
				call nz, play_longest_sequence
				
			game_skip_nogamekeys:
					
			game_skeys_end:
			
				ld a, (current_button)
				cp 0xff
				call nz, play_current_button
			
				ld a,(playing)	
				or a			
				jr z, game_no_timeout
				ld a, (current_button)
				cp 0xff
				jr nz, game_no_timeout
				ld a, (timeout)			
				or a
				jr z,  game_no_timeout
				
					ld a, (current_pos)
					dec a
					ld ix, sequence
					ld ($+5),a			
					ld a,(ix+0)
					ld (last_button),a
					ld (current_button), a				
					call game_lost
				
			game_no_timeout:
				
				ld hl, counter
				call inc32counter	
				
				jp main_loop
				


show_help:
				ld a, PAPER_BLUE | BLUE		; all blue to smooth stransition
				call cls_attribs


				ld hl, help_screen
				ld de,screen_start			
				call DecompressLZ4Data
			
				call waitnokey
				call waitkey
				
				ld a, PAPER_BLUE | BLUE		; all blue to smooth stransition
				call cls_attribs

				
				ld hl, main_screen
				ld de,screen_start			
				call DecompressLZ4Data		
				
				call waitnokey	
				
				ret
				

; a = key to lite (%00 to %11, green,red,cyan,yellow)
button_light_keep:

				exx		
				push af		
					ld (last_button_light_keep), a
					ld c, 0xff
					call button_light		
				pop af
				exx
								
				ret


repeat_last_flash_lights:
				exx									
				push af
					ld a, (last_button_light_keep)
					push ix
						call flash_lights							
					pop ix									
				pop af
				exx

				ret


play_current_button:
				ld a, (current_button)
				call button_sound
				ld a, (current_button)
				call flash_lights

				ret
				
								
losing_sound2:
				ld b, 20
		losing_sound2_loop:				
					push bc
					ld hl, 10387	
					ld de, 3
					call beeper				
									
					ld a,(current_button)				
					call flash_lights_lost
					
					pop bc
				djnz losing_sound2_loop
				ret
	
		
keep_longest_sequence_if_needed

				ld a, (current_pos)
				dec a					; avoid last element because or not pressed or pre-incremented
				ld b, a
				ld a, (long_pos)
				sub b
				ret z	; same length
				ret nc	; not longer
				
				ld a, b				
				ld (long_pos), a				
				
				ld hl, sequence		; and keep it
				ld de, long_sequence
				ld bc, 32
				ldir				
				
				ret

	
;a= pos
; modifies bc, a
set_note_speed:			
				ld c, a ; keep a
				
				ld a, (force_note_speed)		; if forced note speed then 												
				or a							; set this value else
				jr z, set_note_speed_cont2		; continue by sequence len

					ld (note_speed),a
					ret

		set_note_speed_cont2:
				
				ld a, c ; recover a
				
				ld b, 6
			
				;Sequence length: 1‐5, tone duration 0.42 seconds, pause between tones 0.05 seconds	6
				;Sequence length: 6‐13, tone duration 0.32 seconds, pause between tones 0.05 seconds 5
				;Sequence length: 14‐31, tone duration 0.22 seconds, pause between tones 0.05 seconds 4	 			
										
				ld a, 13				
				sub c
				jr nc, set_note_speed_j1				
					ld b, 4
					jr set_note_speed_cont					
					
			set_note_speed_j1:				
				ld a,5
				sub c
				jr nc, set_note_speed_cont							
					ld b,5
			set_note_speed_cont:

				ld a, b
				ld (note_speed), a
			
				ret				
	
	
play_longest_sequence:
				ld a, (long_pos)
				or a
				ret z ; no longest sequence yet
				
				ld b, a
				ld hl, long_sequence
			
				jr play_sequence_loop
	
	
play_razz_sequence:
						
				ld a, 2					; max note speed
				ld (force_note_speed), a
				
				ld a, win_razz_len
				ld b, a
				ld hl, win_razz
								
				call play_sequence_loop
				
				xor a
				ld (force_note_speed), a	; restore normal play speed
				
				ret
	
	
play_sequence:
				ld a, (current_pos)		

				ld b, a
				ld hl, sequence				
				
	play_sequence_loop:
				
				ld e, a ; keep a 
				ld d, b	; keep b safe
				call set_note_speed
				ld b, d
				ld a, e
				
				push hl
				push bc
				
					call get_ts_pointer		; ix points to sound table
					
					xor a
					ld (last_lights_color),a 
					
					ld a, (hl)		; add 4 x note
					
					call button_light_keep
							
					or a 					
					jr z, play_sequence_loop_mult_end
					
					ld bc, 0x0004
				play_sequence_loop_mult:					
					add ix, bc
					dec a
					jr nz, play_sequence_loop_mult
					
				play_sequence_loop_mult_end:
					
				ld a, (note_speed)
				
			play_sequence_note_loop:
					push af
					push ix
						call play_ix_sound	
						call repeat_last_flash_lights
					pop ix
					pop af
					dec a
					jr nz, play_sequence_note_loop		
									
					ld b, 4
					call delayb 
				
				call default_button_colors
				
				pop bc
				pop hl
				
				inc hl
				
				djnz play_sequence_loop
				
				xor a
				ld (timeout), a
				ld (timeout_counter), a
							
				ret
	

; Non Z if active
; a = color to check
; modifies a, ix
check_active_color:
				ld ix, active_colours
				ld ($+5),a			
				ld a,(ix+0)
				or a
				ret
	
	
add_random_to_sequence:
				
				ld a, (counter) ; random based on counter
				and %11
				
		add_random_to_sequence_loop:	
				ld b, a
			; check if color active (will always be active except in game_mode = 2)					
				call check_active_color
							
			; if active continue 				
				jr nz, add_random_to_sequence_cont
				
			; if not active get random			
				call random		; random based on seed if before is not available (game3)
				and %11		
				jr add_random_to_sequence_loop
			
			;
			add_random_to_sequence_cont:
				ld a, (current_pos)
				dec a
				ld ix, sequence
				ld ($+5),a			
				ld (ix+0), b		; ix+ a = b
				ret
	

; returns c= number of active colours, d=last active colour
get_last_colour:
				
				ld bc,0x0000
				ld hl, active_colours
				
		get_last_colour_loop:	
				ld a, (hl)
				or a
				jr z, get_last_colour_not_active
					inc c
					ld d, b
					
			get_last_colour_not_active:
				inc hl
				inc b
				ld a, 4
				cp b
				jr nz, get_last_colour_loop
				
				ret


; a = button
; b = time	in sound cycles (1 cicle = apros 15ms))

sound_button:				

				ld (sound_button_value), a ;keep button
				push bc				; keep for sound time				
					; turn light button on
					ld c, 0xff				
					call button_light			
					push af
					push ix
					exx
					ld a, (sound_button_value)
					call flash_lights
					exx
					pop ix
					pop af
				pop bc				; recover b from start 
				
		sound_button_loop:
				push bc
					ld a, (sound_button_value)											
					call button_sound				
				pop bc
				djnz sound_button_loop
				
				; turn button off
				ld a, (sound_button_value)				
				ld c, 0x00
				call button_light				
												
				ld b, 10
				call delayb
						
				ret
		
		sound_button_value:		defb 	0				
				


game_won_rotate:

				ld a, (last_button)				
				ld b, 4
			
		game_won_rotate_loop:
					push bc
					ld b, 1				
					push af
					call button_light_keep
					pop af
					inc a
					and %11
					ld b, 2
					call delayb
					pop bc
				
				djnz game_won_rotate_loop
				
				ret


game_won:
				xor a
				ld (playing), a
				
				; win animation
				
				ld b, 40		; arround 800ms
				call delayb 
				
				call game_won_rotate					
				
				ld a, (game_skill)
				sub 2				
				jr c, game_won_no_razz
					call play_razz_sequence
					call game_won_rotate					
					
			game_won_no_razz:
								
				ld a, (last_button)				
				ld b, 1
				call sound_button
				ld a, (last_button)		
				call flash_lights
				
				
				
				
				ld b, 6
			game_won_loop:
				
				push bc
				xor a
				ld (last_lights_color), a
				ld a, (last_button)				
				ld b, 3
				call sound_button	
				
				ld a, (last_button)		
				call flash_lights
				
				pop bc
				djnz game_won_loop
				
				;  show all colours agaoin
				ld a,1
				ld (active_colours), a
				ld (active_colours+1), a
				ld (active_colours+2), a
				ld (active_colours+3), a
				
				call default_button_colors
								
				call keep_longest_sequence_if_needed
				
				ld a, (current_pos)		; roll back last item for last play back
				dec a
				ld (current_pos), a
				
				ret
				
		
game_lost:		
	
				ld a, (current_button)
				ld (game_lost_keep), a
				
				call losing_sound2
				
				xor a
				ld (playing), a
				cpl
				ld (current_button), a
								
				; flash wining key
								
				call keep_longest_sequence_if_needed
				
				call default_button_colors	
				
			carles:
			; if game = 2 	
				ld a, (game_mode)
				cp 2
				ret nz
				
			; if remove lost color from active colors
				ld a, (game_lost_keep)
				ld ix, active_colours
				ld b, 0
				ld ($+5),a	
				ld (ix+0), b		
				
				call default_button_colors	
						
			; if is last color win
				call get_last_colour ; returns c= number of active colours, d=last active colour
				ld a, c
				cp 1
				jr nz, game_lost_still_playing_game2					
					ld a, d
					ld (last_button), a
					jp game_won
					
			game_lost_still_playing_game2:			
			
			; wait a little
				ld b, 30
				call delayb 	
				
			; continue to restart game	
			jr start_game_no2		
			
		game_lost_keep			defb 0			
	
	
start_game:

				ld a,1
				ld (active_colours), a
				ld (active_colours+1), a
				ld (active_colours+2), a
				ld (active_colours+3), a
				
								
		start_game_no2:
		
				ld a, 1
				ld (current_pos), a
				call add_random_to_sequence
		
				call default_button_colors

				ld a, (counter)
				call randomize
								
				ld a, 1
				ld (current_pos), a
				
				xor a
				ld (current_guess), a
				ld (timeout), a
				ld (timeout_counter), a
				cpl
				ld (current_button), a
				ld (playing), a
				ld (last_button), a				
								
				call play_sequence
				
				ret
							


; a = key pressed;
key_pressed:
				; check if game_mode 2 active color
				ld b, a				
				call check_active_color
				ld a,b
				ret z ; exit if inactive

				push af						; if current button active turn it off
				ld a, (current_button)
				cp 0xff
				jr z, key_pressed_no_current
				ld c, 0
				call button_light						
		key_pressed_no_current:				
				pop  af
				
				ld c, 0xff					; set current button and light it
				ld (current_button),a 
				ld (last_button), a
				call button_light
				
				ld a, (current_button)		; start sound
				call button_sound
				
				xor a						; start flash lights
				ld (last_lights_color),a 
				ld a, (current_button)
				call flash_lights
				
				ld a, (playing)
				or a
				ret z
				
				ld a,(game_b_setting_note)		;; if setting note in game B
				or a
				ret nz	; if so no more controls until release button
				
	check_press:
				ld a, (current_button)		
				ld b, a
				
				ld ix, sequence
				ld a, (current_guess)
				ld ($+5),a			
				ld a, (ix+0)		; ix+ a
				
				cp b
				
				jp nz, game_lost
		
			; check press ok
				
				ret
				

; a = key released;
key_released:
				; check if game_mode 2 active color
				ld b, a				
				call check_active_color
				ld a,b
				ret z ; exit if inactive

				ld (last_button), a
								
				ld c, 0				
				call button_light
				
				
				ld a, (last_button)
				ld hl, current_button
				cp (hl)
				ret nz					; avoid killing button if is not last key
				ld a, 0xff
				ld (current_button),a 		
				
				ld a, (playing)		
				or a
				ret z
				
				xor a
				ld (timeout), a
				ld (timeout_counter), a
				
				
				ld a,(game_b_setting_note)		;; if setting note in game B
				or a
				jr z, key_released_not_setting_note
				
					; register new note					
					ld a, (last_button)
					ld b, a
					ld a, (current_pos)
					dec a
					ld ix, sequence
					ld ($+5),a			
					ld (ix+0),b		; ix+ a
					
					xor a
					ld (game_b_setting_note), a
					
					call game_won_rotate
					call default_button_colors
					
					ret ; done
					
				
			key_released_not_setting_note:
				; if playing move to next note on release
				ld a, (current_guess)	
				inc a
				ld (current_guess), a
				
				; if end of current sequence part play next note
				
				ld b, a
				ld a, (current_pos)
				cp b
				
				ret nz
				
				; advance sequence 1 more tone
				ld a, (current_pos)
				inc a
				ld (current_pos), a
							
				; check if win
				ld a, (current_pos)
				ld b, a
				ld a, (win_pos)
				cp b
				jp z, game_won				
				
				
				; if not win
				; set current player played position to note 0
				xor a
				ld (current_guess), a
				
				; add new item to sequence
				ld a, (game_mode)
				cp 1
				jr nz, no_manual_add
					ld a, 0xff
					ld (game_b_setting_note), a
					ret
			no_manual_add:	
					call add_random_to_sequence			
			add_sequence_cont:
				
				; wait a litle and playing again
				ld b, 30
				call delayb 				
				call play_sequence
				
				ret		

				
change_game_mode:
				ld a, (game_mode)
				inc a
				cp 3
				jr nz, change_mode_cont
					xor a
			change_mode_cont:
			
				ld (game_mode), a
				
				ld hl, slider_game_1
				ld de, 2*8 + 2
				call minimult
								
				ld bc, 0x5868				
				call pintasprite
				
								
				call move_slider_sound								
				ld a, (game_mode)
				or a
				ret nz
				
				halt
				nop
				
				call move_slider_sound
				
				ret


							
change_skill:
				ld a, (game_skill)
				inc a
				and %11						
				ld (game_skill), a
				
				ld hl, slider_skill_1
				ld de, 3*8 + 2
				call minimult
				
				ld bc, 0x5880 
				call pintasprite
				
				
				change_skill_set_win_pos:		
				ld a, (game_skill)			; update won_pos from table
				ld ix, win_pos_values
				ld ($+5),a			
				ld a, (ix+0)				; ix+ a
				ld (win_pos), a	
				
				call move_slider_sound						
				
				ld a, (game_skill)
				or a
				ret nz			
					
				halt
				nop
				
				call move_slider_sound
				
				halt
				nop
				
				call move_slider_sound
								
				ret
		
			
default_button_colors:				
				ld ix, active_colours
				
				xor a
				
	default_button_colors_loop:
	
				push af		
				ld b, a		
				ld ($+5),a		
				ld a, (ix+0)
				or a
				ld a,b
				jr z, default_button_colors_off									
					ld c, 0
					call button_light
					jr default_button_colors_cont
					
				default_button_colors_off				
					ld c, PAPER_BLUE | BLACK | NO_BRIGHT
					call paint_button
				
			default_button_colors_cont:
								
				pop af
				inc a
				cp 4
				jr nz, default_button_colors_loop
			
				ret
	
off_button_colors:
				xor a
				
	off_button_colors_loop:
	
				push af		
					ld c, PAPER_BLUE | BLACK | NO_BRIGHT
					call paint_button
				pop af
				inc a
				cp 4
				jr nz, off_button_colors_loop
			
				ret			
				
		
change_onoff:		
				ld a, (onoff)
				cpl
				ld (onoff), a
				
				ld hl, slider_off
				or a
				jr nz, change_onoff_cont
					ld hl, slider_on
			change_onoff_cont:								
				
				ld bc, 0x7878 
				call pintasprite
				
				call move_slider_sound
								
				ld a, (onoff)
				or a			
				jr nz, game_on

		game_off:
					call off_button_colors
					ret

		game_on:		
					call default_button_colors
					ret
				

rpsinterrupt:
				ld hl, frame_counter
				call inc32counter
				
				ld a, (timeout_counter)
				inc a
				ld (timeout_counter), a
				
				cp 250	; timeout counter limit
				ret nz

				ld (timeout), a	; timeout <> 0 is timeout
				ret



				include "simon_keys.asm"
				include "simon_screen.asm"
				include "simon_sounds.asm"
				include "simon_images.asm"				
				include "simon_misc.asm"
				
				include "libs/screen_lib.asm"
				include "libs/sound_lib.asm"
				include "libs/random_lib.asm"
				include "libs/lz4_lib.asm"


main_screen:	incbin "simon.scr.lz4"
help_screen:	incbin "simon_manual_1.scr.lz4"


include 'libs/interrupt_lib.asm' ; always include last line or before org	


;run 0x8000
