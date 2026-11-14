INCLUDE "data/pokemon/custom_icon_pointers.asm"

GetCustomPartyIconID::
        ld c, e
        ld hl, CustomPartyIconPointers

.loop
        ld a, [hli]
        cp $ff
        jr z, .notFound

        cp c
        jr z, .found

        ; Skip ROM bank and 2-byte graphics pointer.
        inc hl
        inc hl
        inc hl
        jr .loop

.found
        ld e, $28
        ret

.notFound
        ld e, $ff
        ret

FindCustomPartyIconGfx::
        ld c, e
        ld hl, CustomPartyIconPointers

.loop
        ld a, [hli]
        cp $ff
        jr z, .notFound

        cp c
        jr z, .found

        ; Skip bank byte and graphics pointer.
        inc hl
        inc hl
        inc hl
        jr .loop

.found
        ; Read graphics ROM bank.
        ld d, [hl]
        inc hl

        ; Read graphics address.
        ld a, [hli]
        ld h, [hl]
        ld l, a

        ; Found custom graphics.
        ld e, 1
        ret

.notFound
        xor a
        ld e, a
        ret

LoadCustomPartyIconGfxBySpecies::
        call FindCustomPartyIconGfx

        ; E = 0 if no custom icon exists
        ld a, e
        and a
        ret z

        ; D = graphics ROM bank
        ; HL = graphics address

        push de
        push hl

        ; Load first animation frame
        ld b, d
        ld d, h
        ld e, l
        ld hl, vSprites tile $28
        ld c, 4
        call CopyVideoData

        ; Load second animation frame
        pop de
        ld hl, 4 tiles
        add hl, de
        ld d, h
        ld e, l

        ; Restore graphics ROM bank
        pop bc
        ld c, 4
        ld hl, vSprites tile $68
        jp CopyVideoData

LoadFirstCustomPartyIconGfx::
        ld hl, wPartySpecies

.loop
        ld a, [hli]
        cp $ff
        ret z

        ; Preserve party position and species ID.
        push hl
        push af

        ; Check whether this species has custom graphics.
        ld e, a
        call FindCustomPartyIconGfx

        ld a, e
        and a
        jr z, .nextMon

        ; Custom graphics found.
        pop af
        ld e, a
        call LoadCustomPartyIconGfxBySpecies
        pop hl
        ret

.nextMon
        pop af
        pop hl
        jr .loop

GetCustomPartyIconSlotTile::
        ldh a, [hPartyMonIndex]

        ; Multiply party index by 4.
        add a
        add a

        add CUSTOM_PARTY_ICON_BASE_TILE
        ld e, a
        ret

GetCustomPartyIconSlotVRAMAddress::
        add a
        ld e, a
        ld d, 0

        ld hl, .slotAddresses
        add hl, de

        ld a, [hli]
        ld h, [hl]
        ld l, a
        ret

.slotAddresses
        dw vSprites tile $00
        dw vSprites tile $04
        dw vSprites tile $08
        dw vSprites tile $0c
        dw vSprites tile $10
        dw vSprites tile $14

LoadCustomPartyIconGfxIntoSlot::
        call FindCustomPartyIconGfx

        ; Check whether custom graphics exist.
        ld a, e
        and a
        ret z

        ; D = graphics ROM bank
        ; HL = graphics source address
        ld b, d

        ; Preserve source bank and address.
        push bc
        push hl

        ; Get first-frame VRAM destination.
        ldh a, [hPartyMonIndex]
        call GetCustomPartyIconSlotVRAMAddress

        ; Restore source address and bank.
        pop de
        pop bc

        ; Load first frame (4 tiles).
        push bc
        push de
        ld c, 4
        call CopyVideoData
        pop de
        pop bc

        ; Advance source to second frame.
        ld hl, 4 tiles
        add hl, de
        ld d, h
        ld e, l

        ; Preserve second-frame graphics source.
        push de

        ; Get first-frame destination again.
        ldh a, [hPartyMonIndex]
        call GetCustomPartyIconSlotVRAMAddress

        ; Restore second-frame graphics source.
        pop de

        ; Advance destination by ICONOFFSET tiles.
        ld a, h
        add HIGH(ICONOFFSET * 16)
        ld h, a

        ; Load second frame (4 tiles).
        ld c, 4
        jp CopyVideoData

; Original Gen 1 fallback icon graphics
INCLUDE "gfx/icons/fallback_icons.asm"
; Generic icon fallback pointer table
INCLUDE "data/pokemon/fallback_icon_pointers.asm"

GetFallbackPartyIconGfx::
        ; Convert category into a 2-byte pointer offset.
        ld a, e
        add a
        ld e, a
        ld d, 0

        ; Look up the graphics pointer.
        ld hl, FallbackPartyIconPointers
        add hl, de

        ; Read the graphics address.
        ld a, [hli]
        ld h, [hl]
        ld l, a

        ; All fallback icons are currently in this bank.
        ld d, BANK(FallbackMonsterIcon)
        ret

LoadFallbackPartyIconGfxIntoSlot::
        ; Look up the fallback graphics.
        call GetFallbackPartyIconGfx

        ; D = graphics ROM bank
        ; HL = graphics source address
        ld b, d

        ; Preserve the source bank and address.
        push bc
        push hl

        ; Calculate first-frame destination.
        ldh a, [hPartyMonIndex]
        call GetCustomPartyIconSlotVRAMAddress

        ; Restore source.
        pop de
        pop bc

        ; Load first frame.
        push bc
        push de
        ld c, 4
        call CopyVideoData
        pop de
        pop bc

        ; Advance source to frame 2.
        ld hl, 4 tiles
        add hl, de
        ld d, h
        ld e, l

        ; Preserve source while calculating destination.
        push de
        ldh a, [hPartyMonIndex]
        call GetCustomPartyIconSlotVRAMAddress
        pop de

        ; Advance destination to second animation region.
        ld a, h
        add HIGH(ICONOFFSET * 16)
        ld h, a

        ; Load second frame.
        ld c, 4
        jp CopyVideoData

LoadDynamicPartyIconGfxIntoSlot::
        ; Preserve the Pokemon species ID.
        push de

        ; Check if custom artwork exists.
        call FindCustomPartyIconGfx

        ld a, e
        and a
        jr z, .fallback

        ; Custom artwork found.
        pop de
        jp LoadCustomPartyIconGfxIntoSlot

.fallback
        ; Restore original species ID.
        pop de

        ; Get the Pokemon's original icon category.
        ; The result is returned through E.
        farcall GetOriginalPartyIconCategory

        ; Load the matching original icon into this slot.
        jp LoadFallbackPartyIconGfxIntoSlot

LoadAllDynamicPartyIconGfx::
        ; Preserve the caller's party index.
        ldh a, [hPartyMonIndex]
        push af

        ; Begin with party slot 0.
        xor a
        ldh [hPartyMonIndex], a

.loop
        ; Get current party slot.
        ldh a, [hPartyMonIndex]

        ; Stop after six Pokemon.
        cp PARTY_LENGTH
        jr nc, .done

        ; Find the Pokemon species at this position.
        ld hl, wPartySpecies
        ld e, a
        ld d, 0
        add hl, de

        ld a, [hl]

        ; Check for the party terminator.
        cp $ff
        jr z, .done

        ; Load the appropriate graphics.
        ld e, a
        call LoadDynamicPartyIconGfxIntoSlot

        ; Advance to the next party position.
        ldh a, [hPartyMonIndex]
        inc a
        ldh [hPartyMonIndex], a

        jr .loop

.done
        ; Restore the caller's party index.
        pop af
        ldh [hPartyMonIndex], a
        ret

RefreshDynamicPartyIconSlot::
        ; Preserve the caller's party index.
        ld b, e
        ldh a, [hPartyMonIndex]
        push af

        ; Select the party slot to refresh.
        ld a, b
        ldh [hPartyMonIndex], a

        ; Get the Pokemon species in this slot.
        ld hl, wPartySpecies
        ld e, a
        ld d, 0
        add hl, de

        ld a, [hl]
        cp $ff
        jr z, .done

        ; Load custom or fallback graphics.
        ld e, a
        call LoadDynamicPartyIconGfxIntoSlot

.done
        ; Restore the previous party index.
        pop af
        ldh [hPartyMonIndex], a
        ret
