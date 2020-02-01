; increments 32bits counter pointed by hl
; must be in 2 low byte align 
; modifies hl				
inc32counter:

				inc (hl)
				ret nz
				inc hl	
				inc (hl)
				ret nz
				inc hl	
				inc (hl)
				ret nz
				inc hl	
				inc (hl)
							
				ret


; delay b 1/50seg (20ms))
delayb:
				halt
				nop
				djnz delayb			
				ret
			
; hl 
; de = to add
; a = times				
; don't use for real multiplications just easy indexes'
minimult:
				cp 0
				ret z
				add hl, de
				dec a
				jr minimult
