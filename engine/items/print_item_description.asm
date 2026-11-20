GetItemDescription::
    cp MASTER_BALL
    jr c, .unknown

    cp MAX_ELIXER + 1
    jr nc, .unknown

    ; Convert item ID to zero-based table index.
    dec a
    add a
    ld c, a
    ld b, 0

    ld hl, ItemDescriptions
    add hl, bc

    ld a, [hli]
    ld d, [hl]
    ld e, a
    ret

.unknown
    ld de, UnknownItemDescription
    ret


PrintItemDescription::
    ; Check for HM01-HM05.
    cp HM01
    jr c, .normalItem

    cp TM01
    jr c, .hm

    ; Check for TM01-TM50.
    cp TM01 + NUM_TMS
    jr nc, .normalItem

    ; Convert TM item ID to machine number 1-50.
    sub TM01
    inc a
    jr .machine

.hm
    ; Convert HM item ID to machine number 51-55.
    sub HM01
    add NUM_TMS + 1

.machine
    jp PrintMachineDescription

.normalItem
    push hl
    call GetItemDescription
    pop hl
    jp PlaceString

PrintMachineDescription::
    push hl
    ld c, a

    ; Save the temporary machine value.
    ld a, [wTempTMHM]
    push af

    ; Save the current named object.
    ld a, [wNamedObjectIndex]
    push af

    ; Convert machine number to move ID.
    ld a, c
    ld [wTempTMHM], a
    predef TMToMove

    ; Retrieve the move's name.
    ld a, [wTempTMHM]
    ld [wNamedObjectIndex], a
    call GetMoveName

    ; DE now points to wNameBuffer.
    ; Print the move name on the second line.
    hlcoord 1, 16
    call PlaceString

    ; Restore the original named object.
    pop af
    ld [wNamedObjectIndex], a

    ; Restore the temporary machine value.
    pop af
    ld [wTempTMHM], a

    ; Print the first description line.
    pop hl
    ld de, MachineDescriptionText
    jp PlaceString


MachineDescriptionText:
    db "Teaches the move@"

UpdateItemDescription::
    push af

    ; Draw a textbox in the bottom six tile rows.
    hlcoord 0, 12
    ld b, 4
    ld c, 18
    call TextBoxBorder

    ; Print the selected item's description.
    pop af
    hlcoord 1, 14
    call PrintItemDescription
    ret


DrawPackDescription::
    ; Clear the entire screen tilemap.
    hlcoord 0, 0
    ld b, SCREEN_HEIGHT
    ld c, SCREEN_WIDTH
    call ClearScreenArea

    ; Draw the full-width PACK item-list frame.
    call DrawPackFrame

    call PrintListMenuEntries

    ; Move item names and swap markers to the left.
    call MovePackEntriesLeft
    ; Draw category icons for all visible items.
    call DrawPackItemIcons
    ; Move the menu cursor to column 1.
    ld a, 1
    ld [wTopMenuItemX], a

    ; Draw the PACK title.
    call DrawPackTitle

    ; Calculate the selected inventory index.
    ld a, [wCurrentMenuItem]
    ld b, a
    ld a, [wListScrollOffset]
    add b
    ld c, a

    ; Do not read beyond the inventory list.
    ld a, [wListCount]
    cp c
    jr z, .emptyDescription
    jr c, .emptyDescription

    ; Load the inventory list pointer.
    ld a, [wListPointer]
    ld l, a
    ld a, [wListPointer + 1]
    ld h, a

    ; Skip the item count.
    inc hl

    ; Every inventory entry is two bytes:
    ; item ID, then quantity.
    ld a, c
    add a
    ld c, a
    ld b, 0
    add hl, bc

    ; Read the selected item's ID.
    ld a, [hl]
    cp $ff
    jr z, .emptyDescription

    ; Draw its description.
    jp UpdateItemDescription

.emptyDescription
    ; Clear the old description when CANCEL is selected.
    hlcoord 0, 12
    ld b, 4
    ld c, 18
    call TextBoxBorder
    ret

MovePackEntriesLeft::
    hlcoord 5, 4
    decoord 1, 4
    call .moveRow

    hlcoord 5, 6
    decoord 1, 6
    call .moveRow

    hlcoord 5, 8
    decoord 1, 8
    call .moveRow

    hlcoord 5, 10
    decoord 1, 10
    call .moveRow
    ret

.moveRow
    ; Copy the existing text four columns left.
    ld bc, 14
    rst _CopyData

    ; Clear the old trailing columns.
    ld a, ' '
    REPT 4
        ld [de], a
        inc de
    ENDR
    ret

DrawPackItemIcons::
    ; Find the first visible inventory entry.
    ld a, [wListPointer]
    ld e, a
    ld a, [wListPointer + 1]
    ld d, a
    inc de

    ld a, [wListScrollOffset]
    add a
    add e
    ld e, a
    jr nc, .noCarry
    inc d
.noCarry

    ; First icon position.
    hlcoord 18, 4
    ld b, 4

.loop
    ; Stop at CANCEL.
    ld a, [de]
    cp $ff
    ret z

    ; Preserve the list position and row counter.
    push bc
    push de
    push hl

    ; Get the category icon for this item.
    call GetPackItemIcon

    ; C = icon tile ID, or zero for no icon.
    pop hl
    ld a, c
    and a
    jr z, .skipIcon
    ld [hl], a

.skipIcon
    pop de
    pop bc

    ; Advance to the next item (ID + quantity).
    inc de
    inc de

    ; Advance two tile rows.
    push bc
    ld bc, 2 * SCREEN_WIDTH
    add hl, bc
    pop bc

    dec b
    jr nz, .loop
    ret

GetPackItemIcon::
    ; Check HM01-HM05 and TM01-TM50.
    cp HM01
    jr c, .normalItem

    cp TM01 + NUM_TMS
    jr nc, .noIcon

    ld c, $40
    ret

.normalItem
    ; Only standard items $01-$53 use the table.
    cp MASTER_BALL
    jr c, .noIcon

    cp MAX_ELIXER + 1
    jr nc, .noIcon

    ; Convert item ID to zero-based index.
    dec a
    ld e, a
    ld d, 0

    ld hl, PackItemIconTable
    add hl, de
    ld c, [hl]
    ret

.noIcon
    ld c, 0
    ret

PackItemIconTable::
    db $42 ; $01 MASTER_BALL
    db $42 ; $02 ULTRA_BALL
    db $42 ; $03 GREAT_BALL
    db $42 ; $04 POKE_BALL
    db $41 ; $05 TOWN_MAP
    db $41 ; $06 BICYCLE
    db $41 ; $07 SURFBOARD
    db $42 ; $08 SAFARI_BALL
    db $41 ; $09 POKEDEX
    db $49 ; $0A MOON_STONE
    db $49 ; $0B ANTIDOTE
    db $49 ; $0C BURN_HEAL
    db $49 ; $0D ICE_HEAL
    db $49 ; $0E AWAKENING
    db $49 ; $0F PARLYZ_HEAL
    db $49 ; $10 FULL_RESTORE
    db $49 ; $11 MAX_POTION
    db $49 ; $12 HYPER_POTION
    db $49 ; $13 SUPER_POTION
    db $49 ; $14 POTION

    ; Badge item IDs (special-use).
    db $41 ; $15 BOULDERBADGE
    db $41 ; $16 CASCADEBADGE
    db $41 ; $17 THUNDERBADGE
    db $41 ; $18 RAINBOWBADGE
    db $41 ; $19 SOULBADGE
    db $41 ; $1A MARSHBADGE
    db $41 ; $1B VOLCANOBADGE
    db $41 ; $1C EARTHBADGE

    db $49 ; $1D ESCAPE_ROPE
    db $49 ; $1E REPEL
    db $41 ; $1F OLD_AMBER
    db $49 ; $20 FIRE_STONE
    db $49 ; $21 THUNDER_STONE
    db $49 ; $22 WATER_STONE
    db $49 ; $23 HP_UP
    db $49 ; $24 PROTEIN
    db $49 ; $25 IRON
    db $49 ; $26 CARBOS
    db $49 ; $27 CALCIUM
    db $49 ; $28 RARE_CANDY
    db $41 ; $29 DOME_FOSSIL
    db $41 ; $2A HELIX_FOSSIL
    db $41 ; $2B SECRET_KEY
    db $41 ; $2C SKATEBOARD
    db $41 ; $2D BIKE_VOUCHER
    db $49 ; $2E X_ACCURACY
    db $49 ; $2F LEAF_STONE
    db $41 ; $30 CARD_KEY
    db $41 ; $31 NUGGET
    db $00 ; $32 ITEM_32
    db $49 ; $33 POKE_DOLL
    db $49 ; $34 FULL_HEAL
    db $49 ; $35 REVIVE
    db $49 ; $36 MAX_REVIVE
    db $49 ; $37 GUARD_SPEC
    db $49 ; $38 SUPER_REPEL
    db $49 ; $39 MAX_REPEL
    db $49 ; $3A DIRE_HIT
    db $41 ; $3B COIN
    db $49 ; $3C FRESH_WATER
    db $49 ; $3D SODA_POP
    db $49 ; $3E LEMONADE
    db $41 ; $3F S_S_TICKET
    db $41 ; $40 GOLD_TEETH
    db $49 ; $41 X_ATTACK
    db $49 ; $42 X_DEFEND
    db $49 ; $43 X_SPEED
    db $49 ; $44 X_SPECIAL
    db $41 ; $45 COIN_CASE
    db $41 ; $46 OAKS_PARCEL
    db $41 ; $47 ITEMFINDER
    db $41 ; $48 SILPH_SCOPE
    db $41 ; $49 POKE_FLUTE
    db $41 ; $4A LIFT_KEY
    db $41 ; $4B EXP_ALL
    db $41 ; $4C OLD_ROD
    db $41 ; $4D GOOD_ROD
    db $41 ; $4E SUPER_ROD
    db $49 ; $4F PP_UP
    db $49 ; $50 ETHER
    db $49 ; $51 MAX_ETHER
    db $49 ; $52 ELIXER
    db $49 ; $53 MAX_ELIXER

PackItemIconTableEnd::

ASSERT PackItemIconTableEnd - PackItemIconTable == NUM_ITEMS

DrawPackFrame::
    ; Full-width PACK item list.
    ; Rows 2-12, sharing the bottom border
    ; with the description panel.

    hlcoord 0, 2
    ld b, 9
    ld c, 18
    call TextBoxBorder
    ret

DrawPackTitle::
    ld a, 'P'
    ldcoord_a 6, 1
    ld a, 'A'
    ldcoord_a 7, 1
    ld a, 'C'
    ldcoord_a 8, 1
    ld a, 'K'
    ldcoord_a 9, 1
    ret


INCLUDE "data/items/descriptions.asm"

LoadPackGraphics::
    ld de, PackIconGFX
    ld hl, vChars2 tile $40
    lb bc, BANK(PackIconGFX), 15
    jp CopyVideoData

PackIconGFX::
    INCBIN "gfx/pack/pack_icons.2bpp"
PackIconGFXEnd::

PackCursorGFX::
    INCBIN "gfx/pack/black_tile_cursor.1bpp"
PackCursorGFXEnd::

ASSERT PackIconGFXEnd - PackIconGFX == 15 * TILE_SIZE
ASSERT PackCursorGFXEnd - PackCursorGFX == 2 * TILE_1BPP_SIZE
