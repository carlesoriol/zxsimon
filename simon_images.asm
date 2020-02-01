
slider_skill_1:
				defb	24, 8

				defb %00011011, %00000000, %00000000
				defb %00011011, %00000000, %00000000
				defb %01111011, %11000000, %00000000
				defb %11111011, %11100000, %00000000
				defb %11111111, %11100000, %00000000
				defb %11111111, %11100001, %00010001
				defb %11111111, %11101111, %11111111
				defb %00000000, %00000000, %00000000

slider_skill_2:
				defb	24, 8

				defb %00000001, %10110000, %00000000
				defb %00000001, %10110000, %00000000
				defb %00000111, %10111100, %00000000
				defb %00001111, %10111110, %00000000
				defb %00001111, %11111110, %00000000
				defb %10001111, %11111110, %00010001
				defb %11101111, %11111110, %11111111
				defb %00000000, %00000000, %00000000

slider_skill_3:
				defb	24, 8

				defb %00000000, %00011011, %00000000
				defb %00000000, %00011011, %00000000
				defb %00000000, %01111011, %11000000
				defb %00000000, %11111011, %11100000
				defb %00000000, %11111111, %11100000
				defb %10001000, %11111111, %11100001
				defb %11111110, %11111111, %11101111
				defb %00000000, %00000000, %00000000

slider_skill_4:
				defb	24, 8

				defb %00000000, %00000000, %11011000
				defb %00000000, %00000000, %11011000
				defb %00000000, %00000011, %11011110
				defb %00000000, %00000111, %11011111
				defb %00000000, %00000111, %11111111
				defb %10001000, %10000111, %11111111
				defb %11111111, %11110111, %11111111
				defb %00000000, %00000000, %00000000

slider_game_1:
				defb	16, 8

				defb %00011011, %00000000
				defb %00011011, %00000000
				defb %01111011, %11000000
				defb %11111011, %11100000
				defb %11111111, %11100000
				defb %11111111, %11100101
				defb %11111111, %11101111
				defb %00000000, %00000000

slider_game_2:
				defb	16, 8

				defb %00000110, %11000000
				defb %00000110, %11000000
				defb %00011110, %11110000
				defb %00111110, %11111000
				defb %00111111, %11111000
				defb %10111111, %11111001
				defb %10111111, %11111011
				defb %00000000, %00000000

slider_game_3:
				defb	16, 8

				defb %00000000, %11011000
				defb %00000000, %11011000
				defb %00000011, %11011110
				defb %00000111, %11011111
				defb %00000111, %11111111
				defb %10100111, %11111111
				defb %11110111, %11111111
				defb %00000000, %00000000

slider_on:
				defb	16, 8

				defb %00011011, %00000000
				defb %00011011, %00000000
				defb %01111011, %11000000
				defb %11111011, %11100000
				defb %11111111, %11100000
				defb %11111111, %11100001
				defb %11111111, %11101111
				defb %00000000, %00000000

slider_off:
				defb	16, 8

				defb %00000000, %11011000
				defb %00000000, %11011000
				defb %00000011, %11011110
				defb %00000111, %11011111
				defb %00000111, %11111111
				defb %10000111, %11111111
				defb %11110111, %11111111
				defb %00000000, %00000000

green_button_attrib:

				defb 12, 1, 3
				defb 10, 2, 5
				defb 8, 3, 7
				defb 7, 4, 8
				defb 7, 5, 8
				defb 6, 6, 9
				defb 6, 7, 7
				defb 5, 8, 7
				defb 5, 9, 6
				defb 5, 10, 6

				defb 255

red_button_attrib:

				defb 17,  1,  3
				defb 17,  2,  5				
				defb 17,  3,  7
				defb 17,  4,  8
				defb 17,  5,  8
				defb 17,  6,  9
				defb 19,  7,  7
				defb 20,  8,  7
				defb 21,  9,  6
				defb 21, 10,  6

				defb 255

cyan_button_attrib:

				defb 21, 13, 6
				defb 21, 14, 6
				defb 20, 15, 7
				defb 19, 16, 7
				defb 17, 17, 9
				defb 17, 18, 8
				defb 17, 19, 8
				defb 17, 20, 7
				defb 17, 21, 5
				defb 17, 22, 3

				defb 255
				
yellow_button_attrib:

				defb 5, 13, 6
				defb 5, 14, 6
				defb 5, 15, 7
				defb 6, 16, 7
				defb 6, 17, 9
				defb 7, 18, 8
				defb 7, 19, 8
				defb 8, 20, 7
				defb 10, 21, 5
				defb 12, 22, 3

				defb 255


button_on_colors:	

				defb	PAPER_GREEN | BLACK | BRIGHT
				defb	PAPER_RED | BLACK | BRIGHT
				defb	PAPER_CYAN | BLACK | BRIGHT
				defb	PAPER_YELLOW | BLACK | BRIGHT
				
				
button_off_colors:	

				defb	PAPER_GREEN | BLACK | NO_BRIGHT
				defb	PAPER_RED | BLACK | NO_BRIGHT
				defb	PAPER_CYAN | BLACK | NO_BRIGHT
				defb	PAPER_YELLOW | BLACK | NO_BRIGHT
				

flash_green:
				defw attributes_start + 9 + 32 * 5
				defw attributes_start + 10 + 32 * 6
				defw 0
				
				defw attributes_start + 9 + 32 * 6
				defw attributes_start + 10 + 32 * 5
				defw 0
				
				defw attributes_start + 9 + 32 * 4
				defw attributes_start + 10 + 32 * 4
				defw attributes_start + 11 + 32 * 4
				defw attributes_start + 11 + 32 * 5
				defw attributes_start + 11 + 32 * 6
				defw attributes_start + 8 + 32 * 5
				defw attributes_start + 8 + 32 * 6
				defw attributes_start + 8 + 32 * 7
				defw attributes_start + 9 + 32 * 7
				defw attributes_start + 10 + 32 * 7				
				defw 0
				
				defw attributes_start + 11 + 32 * 3
				defw attributes_start + 12 + 32 * 3
				defw attributes_start + 12 + 32 * 4
				defw attributes_start + 12 + 32 * 5	
				defw attributes_start + 7 + 32 * 7
				defw attributes_start + 7 + 32 * 8
				defw attributes_start + 8 + 32 * 8
				defw attributes_start + 9 + 32 * 8
			
				defw 0
				
				defw attributes_start + 13 + 32 * 2
				defw attributes_start + 13 + 32 * 3
				defw attributes_start + 13 + 32 * 4
				defw attributes_start + 6 + 32 * 9
				defw attributes_start + 7 + 32 * 9
				defw attributes_start + 8 + 32 * 9

				defw 0
				
flash_red:
				defw attributes_start + 21 + 32 * 5
				defw attributes_start + 22 + 32 * 6
				defw 0
				
				defw attributes_start + 22 + 32 * 5
				defw attributes_start + 21 + 32 * 6
				defw 0
				
				defw attributes_start + 20 + 32 * 4
				defw attributes_start + 21 + 32 * 4
				defw attributes_start + 22 + 32 * 4
				defw attributes_start + 20 + 32 * 5
				defw attributes_start + 20 + 32 * 6
				defw attributes_start + 23 + 32 * 5
				defw attributes_start + 23 + 32 * 6
				defw attributes_start + 21 + 32 * 7
				defw attributes_start + 22 + 32 * 7
				defw attributes_start + 23 + 32 * 7				
				defw 0
				
				
				defw attributes_start + 19 + 32 * 3
				defw attributes_start + 20 + 32 * 3
				defw attributes_start + 19 + 32 * 4
				defw attributes_start + 19 + 32 * 5
				defw attributes_start + 24 + 32 * 7
				defw attributes_start + 22 + 32 * 8
				defw attributes_start + 23 + 32 * 8
				defw attributes_start + 24 + 32 * 8				
				defw 0
				
				defw attributes_start + 18 + 32 * 2
				defw attributes_start + 18 + 32 * 3
				defw attributes_start + 18 + 32 * 4
				defw attributes_start + 23 + 32 * 9
				defw attributes_start + 24 + 32 * 9
				defw attributes_start + 25 + 32 * 9
				
				defw 0
				
flash_cyan:
				defw attributes_start + 21 + 32 * 17
				defw attributes_start + 22 + 32 * 18
				defw 0

				defw attributes_start + 21 + 32 * 18
				defw attributes_start + 22 + 32 * 17
				defw 0
				
				defw attributes_start + 21 + 32 * 16
				defw attributes_start + 22 + 32 * 16
				defw attributes_start + 23 + 32 * 16
				defw attributes_start + 23 + 32 * 17
				defw attributes_start + 23 + 32 * 18
				defw attributes_start + 20 + 32 * 17
				defw attributes_start + 20 + 32 * 18
				defw attributes_start + 20 + 32 * 19
				defw attributes_start + 21 + 32 * 19
				defw attributes_start + 22 + 32 * 19			
				defw 0
				
				
				defw attributes_start + 22 + 32 * 15
				defw attributes_start + 23 + 32 * 15
				defw attributes_start + 24 + 32 * 15
				defw attributes_start + 24 + 32 * 16
				defw attributes_start + 19 + 32 * 18
				defw attributes_start + 19 + 32 * 19
				defw attributes_start + 19 + 32 * 20
				defw attributes_start + 20 + 32 * 20
				defw 0
				
				defw attributes_start + 23 + 32 * 14
				defw attributes_start + 24 + 32 * 14
				defw attributes_start + 25 + 32 * 14
				defw attributes_start + 18 + 32 * 19
				defw attributes_start + 18 + 32 * 20
				defw attributes_start + 18 + 32 * 21
				
				defw 0
				
flash_yellow:

				defw attributes_start + 9 + 32 * 18
				defw attributes_start + 10 + 32 * 17
				defw 0
				
				defw attributes_start + 9 + 32 * 17
				defw attributes_start + 10 + 32 * 18
				defw 0
				
				defw attributes_start + 8 + 32 * 16
				defw attributes_start + 9 + 32 * 16
				defw attributes_start + 10 + 32 * 16
				defw attributes_start + 8 + 32 * 17
				defw attributes_start + 8 + 32 * 18
				defw attributes_start + 11 + 32 * 17
				defw attributes_start + 11 + 32 * 18
				defw attributes_start + 9 + 32 * 19
				defw attributes_start + 10 + 32 * 19
				defw attributes_start + 11 + 32 * 19			
				defw 0
				
				
				defw attributes_start + 7 + 32 * 15
				defw attributes_start + 8 + 32 * 15
				defw attributes_start + 9 + 32 * 15
				defw attributes_start + 7 + 32 * 16
				defw attributes_start + 12 + 32 * 18
				defw attributes_start + 12 + 32 * 19
				defw attributes_start + 12 + 32 * 20
				defw attributes_start + 11 + 32 * 20
				defw 0
				
				defw attributes_start + 6 + 32 * 14
				defw attributes_start + 7 + 32 * 14
				defw attributes_start + 8 + 32 * 14
				defw attributes_start + 13 + 32 * 19
				defw attributes_start + 13 + 32 * 20
				defw attributes_start + 13 + 32 * 21
				
				defw 0		
					
							
colors_round:	
				defb WHITE | BRIGHT				
				defb YELLOW | BRIGHT				
				defb WHITE | NO_BRIGHT								
				defb YELLOW | NO_BRIGHT
				defb BLACK | BRIGHT
				defb BLACK | BRIGHT
				defb BLACK | BRIGHT
				
				
colors_round_lost:	
				defb RED | BRIGHT				
				defb MAGENTA | BRIGHT				
				defb RED | NO_BRIGHT								
				defb MAGENTA | NO_BRIGHT
				defb BLACK | BRIGHT
				defb BLACK | BRIGHT
				defb BLACK | BRIGHT				
