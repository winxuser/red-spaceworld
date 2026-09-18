Random_::
    ; Load X[n] (hRandomAdd) into bc
    ld hl, hRandomAdd + 1
    ld a, [hld]
    ld b, a
    ld a, [hl]
    ld c, a

    ; Load X[n-1] (hRandomLast) into de
    ld hl, hRandomLast + 1
    ld a, [hld]
    ld d, a
    ld a, [hl]
    ld e, a

    ; Update X[n-1] = X[n]
    ld hl, hRandomLast
    ld a, c
    ld [hli], a
    ld [hl], b

    ; Perform Xor-Shift calculation
    ld a, c
    add a, a
    add a, a
    add a, a
    xor c
    ld c, a
    ld a, d
    add a, a
    xor d
    ld b, a
    rra
    xor b
    xor c
    ld b, e
    ld c, a

    ; Store result into X[n] (hRandomAdd)
    ld hl, hRandomAdd
    ld a, c
    ld [hli], a
    ld [hl], b

    ; Return 8-bit random value in register a
    ld a, c
    ret
