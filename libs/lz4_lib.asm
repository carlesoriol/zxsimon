
;from https://www.cemetech.net/forum/viewtopic.php?t=11406&start=0


;HL - Input buffer
;DE - Output buffer
DecompressLZ4Data:
;Skip header data
    ld bc,7
    add hl,bc
_decompBlocksLp:
    call _DecodeLZ4Block
    jr c,_decompBlocksLp
    ret


;Decode a block
;Returns with C if more blocks to decode, NC if end of data
_DecodeLZ4Block:
    ;Block size
    ld c,(hl)
    inc hl
    ld b,(hl) 
    inc hl

    ;Return if length == 0 (EOF)
    ld a,b
    or c
    ret z

    inc hl
    ld a,(hl)
    inc hl ;If high bit == 1, uncompressed, else compressed
    jr nc,_DecodeLZ4Block1
    ;Not compressed, do a data copy
    ldir
    scf
    ret
_DecodeLZ4Block1:
    ;Compressed, run decompression
    call _DecompressLZ4Block
    scf
    ret


;HL - Input buffer
;DE - Output buffer
;BC - Block length
_DecompressLZ4Block:
    push hl
    add hl,bc
    ex (sp),hl ; Stack = address directly after data end

_decompressLp:
    ld a,(hl)
    inc hl ;Sequence token
    push af
    ;===Decompress Literals===
    ;High 4 bits -> Low 4 bits
    rra
    rra
    rra
    rra
    call _ReadByteExtensionsIfNeeded ;BC = num literals
    ;If length is 0, no copying
    ld a,b
    or c
    jr z,_decompressLp1
    ldir
    _decompressLp1
 
    ;===
    pop af

;If we've processed the input length, return
    pop bc
    or a
    sbc hl,bc
    add hl,bc
    ret z
    push bc

    ;===Decompress Matches===
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    push bc ;Store offset from output

    call _ReadByteExtensionsIfNeeded ;BC = match length
    ;Add 4 because min is 4
    inc bc
    inc bc
    inc bc
    inc bc

    ex (sp),hl   ;HL = offset from output, (SP) = input buffer
    push de
    ex de,hl     ;HL = output, DE = offset
    or a
    sbc hl,de    ;HL = match start
    pop de       ;DE = output
    ldir
    pop hl       ;HL = input buffer
    ;===
    jr _decompressLp

;If A = 15, read & add byte extensions
;Otherwise, BC = A
_ReadByteExtensionsIfNeeded:
    and 0x0F
    ld b,0
    ld c,a
    cp 15
    ret nz
    _ReadByteExtensionsIfNeeded1:  
		ld a,(hl) 
		inc hl
        cp 255
        jr nz,_ReadByteExtensionsIfNeeded2
        add a,c
        jr nc,$+3
        inc b
        ld c,a
        jr _ReadByteExtensionsIfNeeded1
    _ReadByteExtensionsIfNeeded2:
    add a,c
    jr nc,$+3
    inc b
    ld c,a
    ret





