LoadGenderPreviewGraphics::
	; Load male portrait into tiles $00-$30.
	ld de, RedPicFront
	ld a, BANK(RedPicFront)
	call UncompressSpriteFromDE
	ld de, vFrontPic
	call .loadPortrait

	; Load female portrait into tiles $31-$61.
	ld de, GreenPicFront
	ld a, BANK(GreenPicFront)
	call UncompressSpriteFromDE
	ld de, vBackPic
	call .loadPortrait

	ret

.loadPortrait
	push de
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, 2 * SPRITEBUFFERSIZE
	rst _CopyData
	pop de
	jp InterlaceMergeSpriteBuffers


LoadGenderPreviewPalettes::
	; Load male palette into BG palette slot 0.
IF GEN_2_GRAPHICS
	ld d, PAL_HERO
ELSE
	ld d, PAL_REDMON
ENDC
	ld e, 0
	call LoadSGBPalette

	; Load female palette into BG palette slot 1.
IF GEN_2_GRAPHICS
	ld d, PAL_HERO_FEMALE
ELSE
	ld d, PAL_REDMON
ENDC
	ld e, 1
	call LoadSGBPalette

	; Switch to WRAM bank 2.
	ld a, 2
	ldh [rWBK], a

	; Default all tile palette assignments to slot 0.
	ld hl, W2_TilesetPaletteMap
	ld bc, $100
	xor a
	call FillMemory

	; Assign female portrait tiles to palette slot 1.
	ld hl, W2_TilesetPaletteMap + PIC_SIZE
	ld b, PIC_SIZE
	ld a, 1

.femalePaletteLoop
	ld [hli], a
	dec b
	jr nz, .femalePaletteLoop

	; Enable tile-based palette assignments.
	ld [W2_TileBasedPalettes], a
	ld [W2_ForceBGPUpdate], a

	; Restore WRAM bank 1.
	xor a
	ldh [rWBK], a
	ret
