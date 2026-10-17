DrawHP:
; Draws the HP bar in the stats screen
	call GetPredefRegisters
	ld a, $1
	jr DrawHP_

DrawHP2:
; Draws the HP bar in the party screen
	call GetPredefRegisters
	ld a, $2

DrawHP_:
	ld [wHPBarType], a
	push hl
	ld a, [wLoadedMonHP]
	ld b, a
	ld a, [wLoadedMonHP + 1]
	ld c, a
	or b
	jr nz, .nonzeroHP
	xor a
	ld c, a
	ld e, a
	ld a, $6
	ld d, a
	jr .drawHPBarAndPrintFraction

.nonzeroHP
	ld a, [wLoadedMonMaxHP]
	ld d, a
	ld a, [wLoadedMonMaxHP + 1]
	ld e, a
	predef HPBarLength
	ld a, $6
	ld d, a
	ld c, a

.drawHPBarAndPrintFraction
	pop hl
	push de
	push hl
	push hl
	call DrawHPBar
	pop hl
	ldh a, [hUILayoutFlags]
	bit BIT_PARTY_MENU_HP_BAR, a
	jr z, .printFractionBelowBar
	ld bc, $9 ; right of bar
	jr .printFraction

.printFractionBelowBar
	ld bc, SCREEN_WIDTH + 1 ; below bar

.printFraction
	add hl, bc
	ld de, wLoadedMonHP
	lb bc, 2, 3
	call PrintNumber
	ld a, '/'
	ld [hli], a
	ld de, wLoadedMonMaxHP
	lb bc, 2, 3
	call PrintNumber
	pop hl
	pop de
	ret

; Draws a line starting from hl high b and wide c
DrawLineBox:
	ld de, SCREEN_WIDTH ; New line
.PrintVerticalLine
	ld [hl], $78 ; │
	add hl, de
	dec b
	jr nz, .PrintVerticalLine
	ld [hl], $77 ; ┘
	dec hl
.PrintHorizLine
	ld [hl], $6f ; ← (halfarrow ending)
	dec hl
	dec c
	jr nz, .PrintHorizLine
	ret

StatusScreen:
	call LoadMonData
	ld a, [wMonDataLocation]
	cp BOX_DATA
	jr c, .DontRecalculate
	; Mon is in a box or daycare
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
	ld [wCurEnemyLevel], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats

.DontRecalculate
	ld hl, wStatusFlags2
	set BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $33
	ldh [rAUDVOL], a ; Reduce volume
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	call LoadHpBarAndStatusTilePatterns

	; Load HUD and font tile graphics
	call .LoadStatusScreenGraphics

	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a

	xor a
	ld [wCurrentMenuItem], a ; Page 0 = Status, Page 1 = Stats, Page 2 = Moves

.pageLoop
	call ClearScreen

	hlcoord 0, 0
	call LoadFlippedFrontSpriteByMonIndex ; Draw Pokémon picture

	hlcoord 9, 0
	ld [hl], '<DOT>'
	dec hl
	ld [hl], '№'

	ld a, [wMonHIndex]
	ld [wPokedexNum], a
	ld [wCurSpecies], a
	predef IndexToPokedex
	hlcoord 10, 0
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; Pokémon no.

	ld hl, NamePointers2
	call .GetStringPointer
	ld d, h
	ld e, l
	hlcoord 9, 2
	call PlaceString ; Pokémon name

	ld a, [wLoadedMonSpecies]
	ld [wGenderTemp], a
	call PrintGenderStatusScreen

	hlcoord 14, 0
	call PrintLevel

	hlcoord 0, 7
	ld c, SCREEN_WIDTH
	ld a, $76
.drawRow7LineLoop
	ld [hli], a
	dec c
	jr nz, .drawRow7LineLoop

	ld a, [wCurrentMenuItem]
	and a
	jr z, .drawPage1
	cp 1
	jp z, .drawPage2
	jp .drawPage3

.drawPage1
	hlcoord 0, 9
	predef DrawHP

	ld hl, wStatusScreenHPBarColor
	call GetHealthBarColor
	ld b, SET_PAL_STATUS_SCREEN
	call RunPaletteCommand

	call DrawVerticalDivider

	decoord 18, 16
	ld a, [wBattleMonLevel]
	push af
	ld a, [wLoadedMonLevel]
	ld [wBattleMonLevel], a
	farcall PrintEXPBar
	pop af
	ld [wBattleMonLevel], a

	hlcoord 0, 14
	ld de, TypesText
	call PlaceString
	hlcoord 1, 15
	predef PrintMonType

	hlcoord 0, 12
	ld de, StatusText
	call PlaceString

	hlcoord 7, 13
	ld de, wLoadedMonStatus
	call PrintStatusCondition
	jr nz, .expDisplay
	hlcoord 4, 13
	ld de, OKText
	call PlaceString

.expDisplay
	hlcoord 10, 10
	ld de, StatusScreenExpText
	call PlaceString

	ld de, wLoadedMonExp
	hlcoord 13, 13
	lb bc, 3, 7
	call PrintNumber

	ld a, [wLoadedMonExp]
	push af
	ld a, [wLoadedMonExp + 1]
	push af
	ld a, [wLoadedMonExp + 2]
	push af

	call CalcExpToLevelUp
	ld de, wLoadedMonExp
	hlcoord 13, 11
	lb bc, 3, 7
	call PrintNumber

	pop af
	ld [wLoadedMonExp + 2], a
	pop af
	ld [wLoadedMonExp + 1], a
	pop af
	ld [wLoadedMonExp], a

	ld a, [wLoadedMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .atMaxLevelGoal
	inc a
	ld [wLoadedMonLevel], a

.atMaxLevelGoal
	hlcoord 14, 15
	ld [hl], '<to>'
	inc hl
	call PrintLevel
	pop af
	ld [wLoadedMonLevel], a
	jp .waitForInput

.drawPage2
	hlcoord 0, 8
	lb bc, 10, 20
	call ClearScreenArea

	ld bc, NUM_MOVES + 1
	ld hl, wMoves
	call FillMemory
	ld hl, wLoadedMonMoves
	ld de, wMoves
	ld bc, NUM_MOVES
	rst _CopyData
	callfar FormatMovesString

	hlcoord 3, 9
	ld de, wMovesString
	call PlaceString

	hlcoord 11, 10
	ld de, SCREEN_WIDTH * 2
	ld a, '<BOLD_P>'
	ld c, NUM_MOVES
	call StatusScreen_PrintPP

	ld hl, wLoadedMonMoves
	decoord 14, 10
	ld b, 0

.printMovePPLoop
	ld a, [hli]
	and a
	jr z, .ppPrintingDone
	push bc
	push hl
	push de

	ld hl, wCurrentMenuItem
	ld a, [hl]
	push af
	ld a, b
	ld [hl], a
	push hl
	callfar GetMaxPP
	pop hl
	pop af
	ld [hl], a

	pop de
	pop hl
	push hl
	ld bc, MON_PP - MON_MOVES - 1
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ld [wStatusScreenCurrentPP], a
	ld h, d
	ld l, e
	push hl
	ld de, wStatusScreenCurrentPP
	lb bc, 1, 2
	call PrintNumber
	ld a, '/'
	ld [hli], a
	ld de, wMaxPP
	lb bc, 1, 2
	call PrintNumber

	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .printMovePPLoop

.ppPrintingDone
	jp .waitForInput

.drawPage3
	call DrawVerticalDivider
	hlcoord 1, 10
	ld de, IDNoText
	call PlaceString
	hlcoord 2, 11
	ld de, wLoadedMonOTID
	lb bc, LEADING_ZEROES | 2, 5
	call PrintNumber

	hlcoord 1, 13
	ld de, OTText
	call PlaceString
	ld hl, OTPointers
	call .GetStringPointer
	ld d, h
	ld e, l
	hlcoord 2, 14
	call PlaceString

	ld d, STATUS_SCREEN_STATS_BOX
	call PrintStatsBox
	jr .waitForInput

.waitForInput
	call Delay3
	call GBPalNormal
	ld a, [wCheckFor180DegreeTurn]
	and a
	jr nz, .skipCry
	ld a, [wCurPartySpecies]
	call PlayCry
	ld a, 1
	ld [wCheckFor180DegreeTurn], a

.skipCry
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit B_PAD_A, a
	jr nz, .exitStatus
	bit B_PAD_B, a
	jr nz, .exitStatus
	bit B_PAD_RIGHT, a
	jr nz, .pressedRight
	bit B_PAD_LEFT, a
	jr nz, .pressedLeft
	jr .waitForInput

.pressedRight
	ld a, [wCurrentMenuItem]
	inc a
	cp 3
	jr nz, .savePage
	xor a
	jr .savePage

.pressedLeft
	ld a, [wCurrentMenuItem]
	dec a
	cp -1
	jr nz, .savePage
	ld a, 2

.savePage
	ld [wCurrentMenuItem], a
	jp .pageLoop

.exitStatus
	xor a
	ld [wCheckFor180DegreeTurn], a
	pop af
	ldh [hTileAnimations], a
	ld hl, wStatusFlags2
	res BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $77
	ldh [rAUDVOL], a
	call GBPalWhiteOut
	call ClearScreen
	ret

.GetStringPointer
	ld a, [wMonDataLocation]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	ret z
	ld a, [wWhichPokemon]
	jp SkipFixedLengthTextEntries

.LoadStatusScreenGraphics:
	ld de, BattleHudTiles1
	ld hl, vChars2 tile $6d
	lb bc, BANK(BattleHudTiles1), 3
	call CopyVideoDataDouble
	ld de, BattleHudTiles2
	ld hl, vChars2 tile $78
	lb bc, BANK(BattleHudTiles2), 1
	call CopyVideoDataDouble
	ld de, BattleHudTiles3
	ld hl, vChars2 tile $76
	lb bc, BANK(BattleHudTiles3), 2
	call CopyVideoDataDouble
	ld de, PTile
	ld hl, vChars2 tile $72
	lb bc, BANK(PTile), 1
	jp CopyVideoDataDouble

PrintStatsBox:
	ld a, d
	ASSERT STATUS_SCREEN_STATS_BOX == 0
	and a
	jr nz, .LevelUpStatsBox

	hlcoord 11, 9
	ld de, .StatsText
	call PlaceString
	hlcoord 16, 10
	jr .printStatValues

.LevelUpStatsBox
	push de
	hlcoord 9, 2
	ld b, 8
	ld c, 9
	call TextBoxBorder
	pop de

	hlcoord 11, 3
	ld de, .StatsText
	call PlaceString
	hlcoord 16, 4

.printStatValues
	ld de, wLoadedMonAttack
	lb bc, 2, 3
	call .PrintStat
	ld de, wLoadedMonDefense
	call .PrintStat
	ld de, wLoadedMonSpeed
	call .PrintStat
	ld de, wLoadedMonSpecial
	jp PrintNumber

.PrintStat:
	push hl
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

.StatsText:
	db   "ATTACK"
	next "DEFENSE"
	next "SPEED"
	next "SPECIAL@"

CalcExpToLevelUp:
	ld a, [wLoadedMonLevel]
	cp MAX_LEVEL
	jr z, .atMaxLevel
	inc a
	ld d, a
	callfar CalcExperience
	ld hl, wLoadedMonExp + 2
	ldh a, [hExperience + 2]
	sub [hl]
	ld [hld], a
	ldh a, [hExperience + 1]
	sbc [hl]
	ld [hld], a
	ldh a, [hExperience]
	sbc [hl]
	ld [hld], a
	ret

.atMaxLevel
	ld hl, wLoadedMonExp
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

StatusScreen_ClearName:
	ld bc, NAME_LENGTH - 1
	ld a, ' '
	jp FillMemory

StatusScreen_PrintPP:
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, StatusScreen_PrintPP
	ret

DrawVerticalDivider:
	hlcoord 9, 8
	ld de, SCREEN_WIDTH
	ld b, 10

.loop
	ld [hl], $7C
	add hl, de
	dec b
	jr nz, .loop
	ret

PrintGenderStatusScreen:
	ld de, wLoadedMonDVs
	callfar GetMonGender
	ld a, [wGenderTemp]
	and a
	jr z, .noGender
	dec a
	jr z, .male
	ld a, '♀'
	jr .printSymbol

.male
	ld a, '♂'
	jr .printSymbol

.noGender
	ld a, ' '

.printSymbol
	hlcoord 18, 0
	ld [hl], a
	ret

IDNoText:
	db "ID№/@"

OTText:
	db "OT/@"

OTPointers:
	dw wPartyMonOT
	dw wEnemyMonOT
	dw wBoxMonOT
	dw wDayCareMonOT

NamePointers2:
	dw wPartyMonNicks
	dw wEnemyMonNicks
	dw wBoxMonNicks
	dw wDayCareMonName

TypesText:
	db   "TYPE1/"
	next "TYPE2/@"

StatusText:
	db "STATUS/@"

OKText:
	db "OK@"

StatusScreenExpText:
	db   "EXP POINTS"
	next "LEVEL UP@"

PTile: INCBIN "gfx/font/P.1bpp"
