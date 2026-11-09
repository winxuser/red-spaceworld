; Check whether a Pokemon has shiny DVs.
;
; Input:
;   DE = address of the Pokemon's two DV bytes
;
; Output:
;   Carry set   = shiny
;   Carry clear = not shiny
;
; Preserves BC, DE and HL.

CheckShininess::
    push bc
    push de
    push hl

    ; Defense DV must be 10.
    ld a, [de]
    and $0f
    cp $0a
    jr nz, .notShiny

    ; Speed and Special DVs must both be 10.
    inc de
    ld a, [de]
    cp $aa
    jr nz, .notShiny

    ; Valid Attack DVs: 2, 3, 6, 7, 10, 11, 14, 15.
    dec de
    ld a, [de]
    and $f0
    cp $20
    jr z, .shiny
    cp $30
    jr z, .shiny
    cp $60
    jr z, .shiny
    cp $70
    jr z, .shiny
    cp $a0
    jr z, .shiny
    cp $b0
    jr z, .shiny
    cp $e0
    jr z, .shiny
    cp $f0
    jr z, .shiny

.notShiny
    pop hl
    pop de
    pop bc
    and a          ; clear carry
    ret

.shiny
    pop hl
    pop de
    pop bc
    scf            ; set carry
    ret
