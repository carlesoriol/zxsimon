; Fast RND
;
; An 8-bit pseudo-random number generator,
; using a similar method to the Spectrum ROM,
; - without the overhead of the Spectrum ROM.
;
; R = random number seed
; an integer in the range [1, 256]
;
; R -> (33*R) mod 257
;
; S = R - 1
; an 8-bit unsigned integer


;modifies c, a

random:

	 ld a, (random_seed)
	 ld c, a 
	  
	 rrca ; multiply by 32
	 rrca
	 rrca
	 xor 0x1f

	 add a, c
	 sbc a, 255 ; carry

	 ld (random_seed), a
	 ret

; a= random seed
randomize:
	ld (random_seed), a
	ret

random_seed:	defb	0


