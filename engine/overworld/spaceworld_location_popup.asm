SECTION "Spaceworld Location Popup", ROMX

SpaceworldLocation_GetCurrentMapName::
    ld a, [wCurMap]
    ld c, a

    ; Search manually configured locations first.
    ld hl, SpaceworldLocation_SpecialMaps

.searchSpecial
    ld a, [hli]
    cp $ff
    jr z, .checkOutdoor

    cp c
    jr z, .foundSpecial

    ; Skip bank byte and 2-byte name pointer.
    inc hl
    inc hl
    inc hl
    jr .searchSpecial

.foundSpecial
    ; Read the ROM bank.
    ld a, [hli]
    ld b, a

    ; Read the name pointer into HL.
    ld a, [hli]
    ld h, [hl]
    ld l, a

    ld a, b
    jr .copyName

.checkOutdoor
    ; Unknown indoor maps have no automatic banner.
    ld a, c
    cp FIRST_INDOOR_MAP
    ret nc

    ; Outdoor maps use existing Town Map entries.
    ld b, 0
    ld hl, ExternalMapEntries + 1
    add hl, bc
    add hl, bc
    add hl, bc

    ; Read the outdoor location's name pointer.
    ld de, wNameBuffer
    ld bc, 2
    ld a, BANK(ExternalMapEntries)
    call FarCopyData

    ld a, [wNameBuffer]
    ld l, a
    ld a, [wNameBuffer + 1]
    ld h, a

    ld a, BANK(ExternalMapEntries)

.copyName
    ; Copy the selected name to WRAM.
    ld de, wNameBuffer
    ld bc, 14
    call FarCopyData

    ld a, '@'
    ld [wNameBuffer + 14], a
    ret

SpaceworldLocation_GetNameColumn::
    ld hl, wNameBuffer
    ld b, 14
    ld c, 0

.countCharacters
    ld a, [hli]
    cp '@'
    jr z, .calculate

    inc c
    dec b
    jr nz, .countCharacters

.calculate
    ; Starting column = (20 - name length) / 2.
    ld a, SCREEN_WIDTH
    sub c
    srl a
    ret

SpaceworldLocation_IsEligible::
    ld a, [wCurMap]

    ; All outdoor maps are eligible.
    cp FIRST_INDOOR_MAP
    jr c, .yes

    ; Search the manual location table.
    ld c, a
    ld hl, SpaceworldLocation_SpecialMaps

.search
    ld a, [hli]
    cp $ff
    jr z, .no

    cp c
    jr z, .yes

    inc hl
    inc hl
    inc hl
    jr .search

.yes
    scf
    ret

.no
    and a
    ret

SpaceworldLocation_LoadFont::
    ; Select VRAM bank 1.
    ld a, 1
    ldh [rVBK], a

    ; Load the complete Gen 2 font into VRAM bank 1.
    ld hl, FontGraphics
    ld de, vFont
    ld bc, FontGraphicsEnd - FontGraphics
    ld a, BANK(FontGraphics)
    call FarCopyDataDouble

    ; Load the Gold/Silver textbox border graphics
    ; into VRAM bank 1 as well.
    ld hl, TextBoxGraphics
    ld de, vChars2 tile $60
    ld bc, TextBoxGraphicsEnd - TextBoxGraphics
    ld a, BANK(TextBoxGraphics)
    call FarCopyData2

    ; Restore VRAM bank 0.
    xor a
    ldh [rVBK], a
    ret

SpaceworldLocation_PrepareBanner::
    ; Only prepare banners for eligible maps.
    call SpaceworldLocation_IsEligible
    ret nc

    ; Get the location name.
    call SpaceworldLocation_GetCurrentMapName

    ; Select VRAM bank 0 for tile numbers.
    xor a
    ldh [rVBK], a

    ; Clear three rows of the window tilemap.
    ld hl, vBGMap1
    ld bc, 3 * TILEMAP_WIDTH
    ld a, ' '
    call FillMemory

    ; Top border
    ld hl, vBGMap1

    ld a, '┌'
    ld [hli], a

    ld b, 18
.topBorder
    ld a, '─'
    ld [hli], a
    dec b
    jr nz, .topBorder

    ld a, '┐'
    ld [hl], a

    ; Middle row
    ld hl, vBGMap1 + TILEMAP_WIDTH

    ld a, '│'
    ld [hl], a

    ld hl, vBGMap1 + TILEMAP_WIDTH + 19
    ld [hl], a

    ; Bottom border
    ld hl, vBGMap1 + 2 * TILEMAP_WIDTH

    ld a, '└'
    ld [hli], a

    ld b, 18
.bottomBorder
    ld a, '─'
    ld [hli], a
    dec b
    jr nz, .bottomBorder

    ld a, '┘'
    ld [hl], a

    ; Calculate the centred starting column.
    call SpaceworldLocation_GetNameColumn

    ; Calculate the destination in the middle window row.
    ld e, a
    ld d, 0
    ld hl, vBGMap1 + TILEMAP_WIDTH
    add hl, de

    ; DE = destination in window tilemap.
    ld d, h
    ld e, l

    ; HL = location name.
    ld hl, wNameBuffer
    ld b, 14

.copyName
    ld a, [hli]
    cp '@'
    jr z, .writeAttributes

    ld [de], a
    inc de

    dec b
    jr nz, .copyName

.writeAttributes
    ; Select VRAM bank 1 for tile attributes.
    ld a, 1
    ldh [rVBK], a

    ; Attribute $08 selects VRAM bank 1,
    ; containing our Gen 2 font and borders.
    ld hl, vBGMap1
    ld bc, 3 * TILEMAP_WIDTH
    ld a, $08
    call FillMemory

    ; Restore VRAM bank 0.
    xor a
    ldh [rVBK], a
    ret

SpaceworldLocation_DrawConnectedBanner::
    ; Only use the window if it's hidden or already ours.
    ldh a, [hWY]
    cp 120
    jr z, .windowAvailable
    cp SCREEN_HEIGHT_PX
    ret nz

.windowAvailable
    ; Hide the window while preparing the new banner.
    ld a, SCREEN_HEIGHT_PX
    ldh [hWY], a
    ldh [rWY], a

    ; Get the new location name.
    call SpaceworldLocation_GetCurrentMapName

    ; Clear three window rows.
    ld b, 0
    ld hl, vBGMap1
    ld d, 3 * TILEMAP_WIDTH

.clearTiles
    ld a, ' '
    call SpaceworldLocation_WriteVRAM
    dec d
    jr nz, .clearTiles

    ; Top border.
    ld hl, vBGMap1

    ld a, '┌'
    call SpaceworldLocation_WriteVRAM

    ld d, 18

.topBorder
    ld a, '─'
    call SpaceworldLocation_WriteVRAM
    dec d
    jr nz, .topBorder

    ld a, '┐'
    call SpaceworldLocation_WriteVRAM

    ; Middle border.
    ld hl, vBGMap1 + TILEMAP_WIDTH

    ld a, '│'
    call SpaceworldLocation_WriteVRAM

    ld hl, vBGMap1 + TILEMAP_WIDTH + 19

    ld a, '│'
    call SpaceworldLocation_WriteVRAM

    ; Bottom border.
    ld hl, vBGMap1 + 2 * TILEMAP_WIDTH

    ld a, '└'
    call SpaceworldLocation_WriteVRAM

    ld d, 18

.bottomBorder
    ld a, '─'
    call SpaceworldLocation_WriteVRAM
    dec d
    jr nz, .bottomBorder

    ld a, '┘'
    call SpaceworldLocation_WriteVRAM

    ; Calculate the centred starting column.
    call SpaceworldLocation_GetNameColumn

    ; Calculate the destination in the middle window row.
    ld e, a
    ld d, 0
    ld hl, vBGMap1 + TILEMAP_WIDTH
    add hl, de

    ; DE = location name.
    ld de, wNameBuffer

    ; B = VRAM bank 0
    ; C = maximum name length.
    ld bc, 14

.copyName
    ld a, [de]
    cp '@'
    jr z, .writeAttributes

    inc de

    ; Preserve the counter because WriteVRAM uses C.
    push bc
    call SpaceworldLocation_WriteVRAM
    pop bc

    dec c
    jr nz, .copyName

.writeAttributes
    ; Apply VRAM bank 1 attributes.
    ld b, 1
    ld hl, vBGMap1
    ld d, 3 * TILEMAP_WIDTH

.attributeLoop
    ld a, $08
    call SpaceworldLocation_WriteVRAM
    dec d
    jr nz, .attributeLoop

    ; Display the finished banner.
    call SpaceworldLocation_TestBanner
    ret

SpaceworldLocation_InitMapSpritesAndFont::
    farcall InitMapSprites
    call SpaceworldLocation_LoadFont
    call SpaceworldLocation_PrepareBanner
    ret

SpaceworldLocation_TestBanner::
    call SpaceworldLocation_IsEligible
    ret nc

    ld a, 120
    ldh [hWY], a
    ldh [rWY], a

    ; Keep the popup active for 60 overworld updates.
    ld a, 60
    ld [wSpaceworldLocationTimer], a
    ret

SpaceworldLocation_Update::
    ld a, [wSpaceworldLocationTimer]
    and a
    ret z

    ; If another system has moved the window,
    ; stop controlling it.
    ldh a, [hWY]
    cp 120
    jr nz, .cancel

    ; Decrease the remaining display time.
    ld hl, wSpaceworldLocationTimer
    dec [hl]
    ret nz

    ; Timer finished: hide the window.
    ld a, SCREEN_HEIGHT_PX
    ldh [hWY], a
    ldh [rWY], a
    ret

.cancel
    xor a
    ld [wSpaceworldLocationTimer], a
    ret

SpaceworldLocation_UpdateAndCheckTimeOfDay::
    farcall CheckOverworldTimeOfDay

    ; Has a connected-map transition requested a popup?
    ld a, [wSpaceworldLocationPending]
    and a
    jr z, .updateTimer

    call SpaceworldLocation_IsEligible
    jr nc, .clearPending

    ; Draw the new location banner.
    ; If another system owns the window, leave it pending.
    ldh a, [hWY]
    cp 128
    jr z, .draw
    cp SCREEN_HEIGHT_PX
    jr nz, .updateTimer

.draw
    call SpaceworldLocation_DrawConnectedBanner

.clearPending
    xor a
    ld [wSpaceworldLocationPending], a

.updateTimer
    call SpaceworldLocation_Update
    ret

SpaceworldLocation_ClearVariablesAndTestBanner::
    farcall ClearVariablesOnEnterMap

    ; Cancel any previous popup or pending request.
    xor a
    ld [wSpaceworldLocationTimer], a
    ld [wSpaceworldLocationPending], a

    ; Restore normal palettes.
    call LoadGBPal

    ; Do not show a new location banner after battle.
    ld a, [wStatusFlags4]
    bit BIT_BATTLE_OVER_OR_BLACKOUT, a
    ret nz

    ; Start the popup on normal map entry.
    call SpaceworldLocation_TestBanner
    ret

SpaceworldLocation_InitConnectedMapSprites::
    ; Preserve normal sprite initialisation.
    farcall InitMapSprites

    call SpaceworldLocation_IsEligible
    ret nc

    ; The LCD is enabled here.
    ; Do not prepare window graphics yet.
    ld a, 1
    ld [wSpaceworldLocationPending], a
    ret

SpaceworldLocation_WriteVRAM::
    ld c, a

    ; Prevent interrupts from changing rVBK
    ; between checking VRAM and writing.
    di

    ld a, b
    ldh [rVBK], a

.wait
    ldh a, [rSTAT]
    and %00000011
    cp 2
    jr nc, .wait

    ld a, c
    ld [hli], a

    ; Restore normal overworld VRAM bank.
    xor a
    ldh [rVBK], a

    ei
    ret

SpaceworldLocation_SpecialMaps:
    db SILENT_HILLS, BANK(SilentHillsName)
    dw SilentHillsName

    db $ff ; End of table
