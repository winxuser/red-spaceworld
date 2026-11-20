; Algorithm: xorshift32 (13, 17, 5)
;
; State layout:
;   hRandomAdd      = bits  0-7
;   hRandomAdd + 1  = bits  8-15
;   hRandomLast     = bits 16-23
;   hRandomLast + 1 = bits 24-31
;
; Returns:
;   A = low byte of updated RNG state
;
; Period:
;   2^32 - 1 for any nonzero initial state
;
; No additional RAM required.
Random_::
    call .LoadState

    ; X << 8
    ld b, c
    ld c, d
    ld d, e
    ld e, 0

    ; Remaining 5-bit shift.
    ld a, 5

.shiftLeft13
    sla e
    rl d
    rl c
    rl b
    dec a
    jr nz, .shiftLeft13

    call .XorState
    call .LoadState

    ; X >> 16
    ld e, c
    ld d, b

    ; Shift the remaining 16-bit value right 1.
    srl d
    rr e

    ; Upper 16 bits of X >> 17 are zero.
    ld bc, 0

    call .XorState
    call .LoadState

    ld a, 5

.shiftLeft5
    sla e
    rl d
    rl c
    rl b
    dec a
    jr nz, .shiftLeft5

    call .XorState

    ; Return the new random byte.
    ldh a, [hRandomAdd]
    ret

.LoadState
    ld hl, hRandomAdd
    ld e, [hl]
    inc hl
    ld d, [hl]

    ld hl, hRandomLast
    ld c, [hl]
    inc hl
    ld b, [hl]
    ret

.XorState
    ; Lower 16 bits.
    ld hl, hRandomAdd

    ld a, [hl]
    xor e
    ld [hli], a

    ld a, [hl]
    xor d
    ld [hl], a

    ; Upper 16 bits.
    ld hl, hRandomLast

    ld a, [hl]
    xor c
    ld [hli], a

    ld a, [hl]
    xor b
    ld [hl], a

    ret
