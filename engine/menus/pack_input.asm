
; Handle PACK input and update descriptions when
; the highlighted item changes.
;
; Normal menus continue using HandleMenuInput.
; PACK menus also respond to UP and DOWN.

PackHandleMenuInput::
    ld a, [wPackMenuActive]
    and a
    jp z, HandleMenuInput

.loop
    ; Remember the previous cursor position.
    ld a, [wCurrentMenuItem]
    push af

    ; Temporarily watch UP and DOWN as well.
    ld a, [wMenuWatchedKeys]
    push af
    or PAD_UP | PAD_DOWN
    ld [wMenuWatchedKeys], a

    call HandleMenuInput

    ; Save the returned button and flags.
    push af
    pop de

    ; Restore the original watched buttons.
    pop bc
    ld a, b
    ld [wMenuWatchedKeys], a

    ; Recover the previous cursor position.
    pop bc

    ; A, B and SELECT must return normally.
    ld a, d
    bit B_PAD_UP, a
    jr nz, .checkMovement
    bit B_PAD_DOWN, a
    jr z, .done

.checkMovement
    ; Did the highlighted row actually change?
    ld a, [wCurrentMenuItem]
    cp b
    jr z, .done

    ; A different item is now highlighted.
    ; Disable automatic tilemap transfers.
    xor a
    ldh [hAutoBGTransferEnabled], a

    ; Redraw the PACK and selected description.
    callfar DrawPackDescription

    ; Restore the cursor after redrawing.
    call PlaceMenuCursor

    ; Transfer the updated tilemap.
    ld a, 1
    ldh [hAutoBGTransferEnabled], a
    call Delay3

    ; Keep listening for more input.
    jr .loop

.done
    ; Restore the original button result and flags.
    push de
    pop af
    ret
