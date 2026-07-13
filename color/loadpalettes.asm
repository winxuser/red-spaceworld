INCLUDE "color/data/map_palettes.asm"
INCLUDE "color/data/map_palettes_morning.asm"
INCLUDE "color/data/map_palettes_night.asm"
INCLUDE "color/data/map_palette_sets.asm"
INCLUDE "color/data/map_palette_assignments.asm"
INCLUDE "color/data/roofpalettes.asm"
INCLUDE "color/data/roofpalettes_morning.asm"
INCLUDE "color/data/roofpalettes_night.asm"

DEF TILESET_SIZE EQU $60

; Load colors for new map and tile placement
LoadTilesetPalette:
	push bc
	push de
	push hl
	ldh a, [rWBK]
	ld d, a
	xor a
	ldh [rWBK], a
	ld a, [wCurMapTileset] ; Located in wram bank 1
	ld b, a
	ld a, $02
	ldh [rWBK], a
	push de ; push previous wram bank

	ld a, 1
	ld [W2_TileBasedPalettes], a

	ld a, b ; Get wCurMapTileset
	push af
	ld hl, MapPaletteSets
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, W2_BgPaletteData ; palette data to be copied to wram at hl
	ld b, $08
.nextPalette
	ld c, $08
	ld a, [de] ; # at de is the palette index for MapPalettes
	inc de
	push de
	ld d, 0
	ld e, a
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	push hl

; Only swap tables for specific tilesets
	xor a
	ldh [rWBK], a
	ld a, [wCurMapTileset]
	ld h, a
	ld a, 2
	ldh [rWBK], a
	ld a, h

	and a             ; Is it tileset 0 (OVERWORLD)?
	jr z, .checkTime
	cp PLATEAU
	jr z, .checkTime
	cp OLD_CITY_TS
	jr z, .checkTime
	cp SILENT_HILLS
	jr z, .checkTime

	; If it isn't any of the above, skip to day palettes
	jr .dayPalettes

.checkTime
	call GetTimeOfDayStage
	and a
	jr z, .dayPalettes
	dec a
	jr nz, .nightPalettes

	; Morning
	ld hl, MapPalettesMorning
	jr .applyOffset

.nightPalettes
	ld hl, MapPalettesNight
	jr .applyOffset

.dayPalettes
	ld hl, MapPalettes

.applyOffset
	add hl, de
	ld d, h
	ld e, l ; de now points to map's palette data
	pop hl
.nextColor
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .nextColor
	pop de
	dec b
	jr nz, .nextPalette

	; Start copying palette assignments
	pop af ; Retrieve wCurMapTileset
	ld hl, MapPaletteAssignments
	ld b, 0
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, W2_TilesetPaletteMap
	ld b, TILESET_SIZE
.copyLoop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .copyLoop

	; Set the remaining values to 7 for text
	ld b, $100 - TILESET_SIZE
	ld a, 7
.fillLoop
	ld [hli], a
	dec b
	jr nz, .fillLoop

	; Switch to wram bank 1 just to read wCurMap
	xor a
	ldh [rWBK], a
	ld a, [wCurMap]
	ld b, a
	ld a, 2
	ldh [rWBK], a

	; Check for celadon mart roof (make the "outside" blue)
	ld a, b
	cp CELADON_MART_ROOF
	jr nz, .notCeladonRoof
	ld a, PAL_BG_WATER
	ld hl, W2_TilesetPaletteMap + $4b
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
.notCeladonRoof
	; Check for celadon 1st floor (change bench color from blue to yellow)
	ld a, b
	cp CELADON_MART_1F
	jr nz, .notCeladon1st
	ld hl, W2_TilesetPaletteMap + $07
	ld a, PAL_BG_YELLOW
	ld [hli], a
	ld [hli], a
	ld l, $17
	ld [hli], a
	ld [hli], a
.notCeladon1st

; Retrieve former wram bank
	pop af
	ld b, a

	xor a
	ldh [rWBK], a
	ld a, [wCurMapTileset]
	ld c, a

	ld a, b
	ldh [rWBK], a ; Restore previous wram bank

	ld a, c
	and a ; Check whether tileset 0 is loaded
	call z, LoadTownPalette
	cp PLATEAU ; tileset 0 isn't the only outside tileset
	call z, LoadTownPalette

	; Add your new outdoor tilesets here!
	cp OLD_CITY_TS
	call z, LoadTownPalette
	cp SILENT_HILLS
	call z, LoadTownPalette

	pop hl
	pop de
	pop bc
	ret

; Towns have different roof colors while using the same tileset
LoadTownPalette:
	ldh a, [rWBK]
	ld b, a
	xor a
	ldh [rWBK], a

	; Get the current map.
	ld a, [wCurMap]
	ld c, a
	cp ROUTE_6 ; Route 6 has 2 rows in saffron city; check if player is there or not.
	jr nz, .notRoute6
	ld a, [wYCoord]
	cp 2
	jr nc, .notRoute6
	ld c, SAFFRON_CITY
.notRoute6
	ld a, c
	add a
	ld c, a

	ld a, $02
	ldh [rWBK], a
	push bc ; push previous wram bank

	push de
	push hl

	call GetTimeOfDayStage
	and a
	jr z, .dayRoofs
	dec a
	jr nz, .nightRoofs

	ld hl, RoofPalettesMorning
	jr .applyRoofOffset

.nightRoofs
	ld hl, RoofPalettesNight
	jr .applyRoofOffset

.dayRoofs
	ld hl, RoofPalettes

.applyRoofOffset
	ld b, 0
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, W2_BgPaletteData + $32
	ld b, $04
.copyLoop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .copyLoop
	pop hl
	pop de

	ld a, [wCurMap]
	ld [W2_TownMapLoaded], a

	pop af
	ldh [rWBK], a ; Restore wram bank
	ret

GetTimeOfDayStage::
    push af
    jr .night        ; <-- ADD THIS LINE FOR DEBUGGING

    ld a, [wRTCHours]

    ; NEW GAME FAIL-SAFE:
    ; If the hour is 0, we treat it as 7 (Morning)
    ; because 0 is likely just uninitialized memory.
    and a            ; Is it 0?
    jr nz, .check_time
    ld a, 7          ; Default to 7 if 0

.check_time
    cp 4
    jr c, .night    ; 0-3 = Night
    cp 10
    jr c, .morning  ; 4-9 = Morning
    cp 18
    jr c, .day      ; 10-17 = Day

.night
    pop af
    ld a, 2
    ret
.morning
    pop af
    ld a, 1
    ret
.day
    pop af
    xor a
    ret
