SpaceworldTrainerCard_LoadPlayerPic::
    ; Select the player's portrait.
    ld de, RedPicFront
    ld a, BANK(RedPicFront)

    ; Check player gender.
    push af
    ld a, [wPlayerGender]
    and a
    jr z, .male

    pop af
    ld de, GreenPicFront
    ld a, BANK(GreenPicFront)
    jr .decompress

.male
    pop af

.decompress
    ; Decompress the 7x7 trainer picture.
    call UncompressSpriteFromDE

    ; Copy the decompressed sprite buffer.
    ld hl, sSpriteBuffer1
    ld de, sSpriteBuffer0
    ld bc, 2 * SPRITEBUFFERSIZE
    rst _CopyData

    ; Interlace and upload 49 tiles to VRAM.
    ; Tile $30 corresponds to $9300.
    ld de, vChars2 tile $30
    jp InterlaceMergeSpriteBuffers

SpaceworldTrainerCard_LoadMainGFX::
    ld hl, SpaceworldTrainerCardGFX
    ld de, vChars2
    ld bc, SpaceworldTrainerCardGFXEnd - SpaceworldTrainerCardGFX
    ld a, BANK(SpaceworldTrainerCardGFX)
    jp FarCopyData

SpaceworldTrainerCard_LoadBadgeGFX::
    ld hl, SpaceworldTrainerCardLeadersGFX
    ld de, vChars2
    ld bc, SpaceworldTrainerCardLeadersGFXEnd - SpaceworldTrainerCardLeadersGFX
    ld a, BANK(SpaceworldTrainerCardLeadersGFX)
    jp FarCopyData

SpaceworldTrainerCard_PlaceTiles::
    ; DE = tile data terminated by $FF
    ; HL = destination in wTileMap
.loop
    ld a, [de]
    cp $ff
    ret z
    ld [hli], a
    inc de
    jr .loop

SpaceworldTrainerCard_DrawBackground::
    ; HL = starting tilemap coordinate
    ; D  = number of interior rows

    ; Draw the top checkerboard row.
    ld e, SCREEN_WIDTH
.top
    ld a, $07
    ld [hli], a
    dec e
    jr nz, .top

    ; Draw the upper border.
    ld a, $07
    ld [hli], a
    ld e, $11
.skipTop
    inc hl
    dec e
    jr nz, .skipTop

    ld a, $09
    ld [hli], a
    ld a, $07
    ld [hli], a

    ; Draw the side borders.
.outer
    ld a, $07
    ld [hli], a
    ld e, $12
.inner
    inc hl
    dec e
    jr nz, .inner

    ld a, $07
    ld [hli], a

    dec d
    jr nz, .outer

    ; Draw the bottom border.
    ld a, $07
    ld [hli], a
    ld a, $08
    ld [hli], a

    ld e, $11
.skipBottom
    inc hl
    dec e
    jr nz, .skipBottom

    ld a, $07
    ld [hli], a

    ld e, SCREEN_WIDTH
.last
    ld a, $07
    ld [hli], a
    dec e
    jr nz, .last
    ret

SpaceworldTrainerCard_NameTiles:
    db $0a, $0c, $0d, $0e, $0f, $ff

SpaceworldTrainerCard_IDTiles:
    db $22, $23, $ff

SpaceworldTrainerCard_NameUnderline:
    db $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $0b, $ff

SpaceworldTrainerCard_StatusTiles:
    db $0a, $10, $11, $12, $13, $ff

SpaceworldTrainerCard_BadgesOutline:
    db $03, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $02, $7f, $14, $15, $16, $17, $18, $19, $1a, $1b
    db $1c, $1d, $7f, $7f, $7f, $fe, $ba, $7f, $7f, $7f
    db $05, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $ff

SpaceworldTrainerCard_BadgesText:
    db $1e, $1f, $20, $7f, $7f, $7f, $7f, $1b, $1c, $1d, $ff

SpaceworldTrainerCard_DrawMainPage::
    ; Draw NAME section background.
    hlcoord 0, 0
    ld d, 5
    call SpaceworldTrainerCard_DrawBackground

    ; Draw STATUS section background.
    hlcoord 0, 8
    ld d, 6
    call SpaceworldTrainerCard_DrawBackground

    hlcoord 13, 1
    ld a, $30
    ld b, 6
    ld de, SCREEN_WIDTH

.portraitColumn
    push bc
    push hl
    ld c, 7

.portraitTile
    ld [hl], a
    inc a
    add hl, de
    dec c
    jr nz, .portraitTile

    pop hl
    inc hl
    pop bc
    dec b
    jr nz, .portraitColumn

    ; NAME heading.
    hlcoord 1, 0
    ld de, SpaceworldTrainerCard_NameTiles
    call SpaceworldTrainerCard_PlaceTiles

    ; Display the player's name.
    hlcoord 6, 2
    ld de, wPlayerName
    call PlaceString

    ; Decorative line below the name.
    hlcoord 1, 3
    ld de, SpaceworldTrainerCard_NameUnderline
    call SpaceworldTrainerCard_PlaceTiles

    ; Restore the decorative arrow at the end of the name underline.
    hlcoord 13, 3
    ld a, $0b
    ld [hl], a

    ; ID No. graphics.
    hlcoord 2, 4
    ld de, SpaceworldTrainerCard_IDTiles
    call SpaceworldTrainerCard_PlaceTiles

    ; Display the player's Trainer ID.
    hlcoord 5, 4
    ld de, wPlayerID
    lb bc, 2, 5
    call PrintNumber

    ; Display the MONEY label.
    hlcoord 2, 6
    ld de, SpaceworldTrainerCard_MoneyText
    call PlaceString

    ; Display the player's current money.
    hlcoord 9, 6
    ld de, wPlayerMoney
    ld c, 3 | LEADING_ZEROES | LEFT_ALIGN | MONEY_SIGN
    call PrintBCDNumber

    ; STATUS heading.
    hlcoord 1, 8
    ld de, SpaceworldTrainerCard_StatusTiles
    call SpaceworldTrainerCard_PlaceTiles
    ; Display the POKEDEX label.
    hlcoord 2, 10
    ld de, SpaceworldTrainerCard_PokedexText
    call PlaceString

    ; Count the player's caught Pokemon.
    ld hl, wPokedexOwned
    ld b, wPokedexOwnedEnd - wPokedexOwned
    call CountSetBits

    ; Display the number caught.
    hlcoord 13, 10
    ld de, wNumSetBits
    lb bc, 1, 3
    call PrintNumber

    ; Display the TIME label.
    hlcoord 2, 12
    ld de, SpaceworldTrainerCard_TimeText
    call PlaceString

    ; Display play time hours.
    hlcoord 10, 12
    ld de, wPlayTimeHours
    lb bc, LEFT_ALIGN | 1, 3
    call PrintNumber

    ; Display the time separator.
    ld [hl], ':'
    inc hl

    ; Display play time minutes.
    ld de, wPlayTimeMinutes
    lb bc, LEADING_ZEROES | 1, 2
    call PrintNumber

    ; Badge-count section outline.
    ; Draw each row separately to prevent wrapping.

    ; Top border.
    hlcoord 0, 13
    ld de, SpaceworldTrainerCard_BadgesOutline
    ld c, SCREEN_WIDTH
    call SpaceworldTrainerCard_CopyRow

    ; Middle row.
    hlcoord 0, 14
    ld de, SpaceworldTrainerCard_BadgesOutline + SCREEN_WIDTH
    ld c, SCREEN_WIDTH
    call SpaceworldTrainerCard_CopyRow

    ; Bottom border.
    hlcoord 0, 15
    ld de, SpaceworldTrainerCard_BadgesOutline + (SCREEN_WIDTH * 2)
    ld c, SCREEN_WIDTH
    call SpaceworldTrainerCard_CopyRow

    ; Preserve the surrounding box borders.
    hlcoord 1, 14
    ld b, 18
    ld a, $7f

.clearBadgeText
    ld [hli], a
    dec b
    jr nz, .clearBadgeText

    ; Display the English badge label.
    hlcoord 2, 14
    ld de, SpaceworldTrainerCard_LeagueBadgesText
    call PlaceString

    ; Count the player's earned badges.
    ld hl, wObtainedBadges
    ld b, (NUM_BADGES + 7) / 8
    call CountSetBits

    ; Display the badge count.
    hlcoord 16, 14
    ld de, wNumSetBits
    lb bc, 1, 2
    call PrintNumber

    hlcoord 4, 16
    ld b, 12
    ld a, $7f

.clearNavigation
    ld [hli], a
    dec b
    jr nz, .clearNavigation

    ; Left option: RETURN.
    hlcoord 4, 16
    ld de, SpaceworldTrainerCard_ReturnText
    call PlaceString

    ; Right option: BADGES.
    hlcoord 12, 16
    ld de, SpaceworldTrainerCard_BadgesNavText
    call PlaceString

    ; Selection arrow.
    hlcoord 3, 16
    ld [hl], '▶'

    hlcoord 19, 1
    ld b, 7
    ld de, SCREEN_WIDTH

.restoreRightBorder
    ld a, $07
    ld [hl], a
    add hl, de
    dec b
    jr nz, .restoreRightBorder

    ret

SpaceworldTrainerCard_MainPage::

    ; Save the current overworld tile animation state.
    ldh a, [hTileAnimations]
    push af

    ; Disable overworld tile animations.
    xor a
    ldh [hTileAnimations], a

.mainPage
    ; Clear the screen and overworld sprites.
    call ClearScreen
    call ClearSprites
    call UpdateSprites

    ; Load the selected male/female player portrait.
    call SpaceworldTrainerCard_LoadPlayerPic

    ; Load the original Spaceworld graphics.
    call DisableLCD
    call SpaceworldTrainerCard_LoadMainGFX
    call EnableLCD

    ; Draw the NAME/STATUS page.
    call SpaceworldTrainerCard_DrawMainPage

    ; Apply the existing trainer card palette.
    ld b, SET_PAL_TRAINER_CARD
    call RunPaletteCommand

    ; Keep portrait palette correction disabled for now.
    call SpaceworldTrainerCard_SetPortraitPalette

    ; Display the screen.
    call GBPalNormal

    ; Handle RETURN / BADGES selection.
    call SpaceworldTrainerCard_MainInput

    ; RETURN or B exits.
    and a
    jr z, .done

    ; Open the Spaceworld badge page.
    call SpaceworldTrainerCard_ShowBadgePage

    ; A or B on the badge page returns to the main page.
    jr .mainPage

.done
    ; Restore the original overworld tile animation state.
    pop af
    ldh [hTileAnimations], a
    ret

SpaceworldTrainerCard_CopyRow::
.loop
    ld a, [de]
    ld [hli], a
    inc de
    dec c
    jr nz, .loop
    ret

SpaceworldTrainerCard_MoneyText:
    db "MONEY/@"

SpaceworldTrainerCard_PokedexText:
    db "POKéDEX@"

SpaceworldTrainerCard_TimeText:
    db "TIME/@"

SpaceworldTrainerCard_LeagueBadgesText:
    db "LEAGUE BADGES@"

SpaceworldTrainerCard_ReturnText:
    db "RETURN@"

SpaceworldTrainerCard_BadgesNavText:
    db "BADGES@"

SpaceworldTrainerCard_SetPortraitPalette::
    ; Save BC before switching WRAM banks.
    push bc

    ; Remember the current WRAM bank in C.
    ldh a, [rWBK]
    ld c, a

    ; Switch to WRAM bank 2.
    ld a, 2
    ldh [rWBK], a

    ; Assign palette 4 to portrait tiles $30-$60.
    ld hl, W2_TilesetPaletteMap + $30
    ld b, PIC_SIZE

.loop
    ld a, 4
    ld [hli], a
    dec b
    jr nz, .loop

    ld a, c
    ldh [rWBK], a

    pop bc
    ret

SpaceworldTrainerCard_MainInput::
    ; Start with RETURN selected.
    ld c, 0

.loop
    ; Draw the arrow at the selected option.
    push bc
    call SpaceworldTrainerCard_DrawArrows
    pop bc

    ; Wait for the next frame before checking input.
    push bc
    call DelayFrame
    call JoypadLowSensitivity
    ldh a, [hJoy5]
    pop bc

    ; RIGHT selects BADGES.
    bit B_PAD_RIGHT, a
    jr nz, .right

    ; LEFT selects RETURN.
    bit B_PAD_LEFT, a
    jr nz, .left

    ; B exits.
    bit B_PAD_B, a
    jr nz, .exit

    ; A confirms.
    bit B_PAD_A, a
    jr nz, .confirm

    jr .loop

.right
    ld c, 1
    jr .loop

.left
    ld c, 0
    jr .loop

.exit
    xor a
    ret

.confirm
    ld a, c
    ret

SpaceworldTrainerCard_DrawArrows::
    ; Remove both arrows.
    hlcoord 3, 16
    ld [hl], $7f

    hlcoord 11, 16
    ld [hl], $7f

    ; Check selected option.
    ld a, c
    and a
    jr nz, .badges

    ; Arrow beside RETURN.
    hlcoord 3, 16
    jr .draw

.badges
    ; Arrow beside BADGES.
    hlcoord 11, 16

.draw
    ld [hl], '▶'
    ret

SpaceworldTrainerCard_ShowBadgePage::
    ; Hide the previous screen.
    call GBPalWhiteOut

    ; Load the original Spaceworld badge graphics.
    call DisableLCD
    call SpaceworldTrainerCard_LoadBadgeGFX
    call EnableLCD

    ; Clear the previous trainer card's tilemap.
    call ClearScreen

    ; Draw the badge page.
    call SpaceworldTrainerCard_DrawBadgePage

    ; Apply the trainer card palette.
    ld b, SET_PAL_TRAINER_CARD
    call RunPaletteCommand

    ; Show the badge page.
    call GBPalNormal

    ; Temporarily wait for A or B to leave.
    call WaitForTextScrollButtonPress
    ret

SpaceworldTrainerCard_DrawBadgePage::
    ; Draw the original checkerboard background.
    hlcoord 0, 0
    ld d, $0e
    call SpaceworldTrainerCard_DrawBackground

    ; Draw the original badge-page heading graphics.
    hlcoord 1, 0
    ld de, SpaceworldTrainerCard_BadgesHeadingTiles
    call SpaceworldTrainerCard_PlaceTiles

    ; Draw the original Gym Leader silhouettes and badges.
    hlcoord 0, 3
    ld de, SpaceworldTrainerCard_BadgeSilhouettesTiles
    call SpaceworldTrainerCard_PlaceTiles

    ; Hide badges that the player has not earned.
    call SpaceworldTrainerCard_UpdateEarnedBadges

    ; Display English heading.
    hlcoord 4, 2
    ld de, SpaceworldTrainerCard_BadgePageText
    call PlaceString

    ret

SpaceworldTrainerCard_UpdateEarnedBadges::
    ; Read the player's badge flags.
    ld a, [wObtainedBadges]
    ld b, a

    ; Eight badges.
    ld c, NUM_BADGES

    ; First badge icon at column 3, row 14.
    hlcoord 2, 14

.loop
    ; Shift the next badge bit into carry.
    srl b
    jr c, .earned

    ; Badge not earned: hide its icon.
    ld a, $7f
    ld [hl], a

.earned
    ; Advance two columns to the next badge.
    inc hl
    inc hl

    dec c
    jr nz, .loop
    ret

SpaceworldTrainerCard_BadgesHeadingTiles:
    db $0a, $0b, $0c, $0d, $0e, $ff

SpaceworldTrainerCard_BadgePageText:
    db "LEAGUE BADGES@"

; Original Spaceworld 1997 badge-page tile layout.
SpaceworldTrainerCard_BadgeSilhouettesTiles:
	db $07, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $07, $07, $02, $18, $58, $59, $5A, $19, $5B, $5C, $5D, $1A, $6B, $6C, $6D, $1B, $78, $79, $7A, $7F, $07, $07, $02, $7F, $20, $21, $22, $7F, $23, $24, $25, $7F, $26, $27, $28, $7F, $29, $2A, $2B, $7F, $07, $07, $02, $7F, $30, $31, $32, $7F, $33, $34, $35, $7F, $36, $37, $38, $7F, $39, $3A, $3B, $7F, $07, $07, $02, $7F, $40, $41, $42, $7F, $43, $44, $45, $7F, $46, $47, $48, $7F, $49, $4A, $4B, $7F, $07, $07, $05, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $04, $07, $07, $7F, $1C, $68, $69, $6A, $1D, $7E, $6F, $6F, $1E, $5E, $5F, $6E, $1F, $7B, $7C, $7D, $02, $07, $07, $7F, $7F, $2C, $2D, $2E, $7F, $2F, $50, $51, $7F, $52, $53, $54, $7F, $55, $56, $57, $02, $07, $07, $7F, $7F, $3C, $3D, $3E, $7F, $3F, $60, $61, $7F, $62, $63, $64, $7F, $65, $66, $67, $02, $07, $07, $7F, $7F, $4C, $4D, $4E, $7F, $4F, $70, $71, $7F, $72, $73, $74, $7F, $75, $76, $77, $02, $07, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $07, $7F, $7F, $10, $7F, $11, $7F, $12, $7F, $13, $7F, $14, $7F, $15, $7F, $16, $7F, $17, $7F, $02, $07, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $06, $07, $FF
