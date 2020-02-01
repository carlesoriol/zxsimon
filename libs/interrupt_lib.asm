

setInterruptTo:

;de interrupt pointer
		ld hl, interruptcallfunction
		inc hl
		ld (hl), e
		inc hl
		ld (hl), d		

; move interrupt routine to $FCFC
		ld hl, IM2Routine
		ld de, $FCFC
		ld bc, IM2RoutineEnd - IM2Routine + 1
		ldir
		
; Setup the 128 entry vector table
		di

		ld            hl, $FA00		; VectorTable FA00 to FB02 acopied by VectorTable
		ld            de, $FCFC; IM2Routine
		ld            b, 129

		; Setup the I register (the high byte of the table)
		ld            a, h
		ld            i, a

		; Loop to set all 128 entries in the table
		_Setup:
		ld            (hl), e
		inc           hl
		ld            (hl), d
		inc           hl
		djnz          _Setup

		; Setup IM2 mode
		im            2
		ei
		ret


       			
		;ORG           $FCFC
IM2Routine:   
		push af             ; preserve registers.
		push bc
		push hl
		push de
		push ix
interruptcallfunction:
		call #0000          ;	:replaced as SetInterruptTo
		;rst 56              ; ROM routine, read keys and update clock.
		pop ix              ; restore registers.
		pop de
		pop hl
		pop bc
		pop af
		ei                  ; always re-enable interrupts before returning.
		reti                ; done.		
		
IM2RoutineEnd:  

; Make sure this is on a 256 byte boundary
;              ORG           $F000
; align 256 
;VectorTable:
;              defs          258



