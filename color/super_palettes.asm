; Note: after calling this, you may need to set W2_ForceBGPUpdate/ForceOBPUpdate to nonzero.
; d = palette to load (see constants/palette_constants.), e = palette index
LoadSGBPalette:
	ldh a, [rWBK]
	ld b, a
	ld a, 2
	ldh [rWBK], a
	push bc

	ld a, e
	ld l, d
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, SuperPalettes
	add hl, de

	ld de, W2_BgPaletteData
	jr startPaletteTransfer

LoadSGBPalette_Sprite:
	ldh a, [rWBK]
	ld b, a
	ld a, 2
	ldh [rWBK], a
	push bc

	ld a, e
	ld l, d
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, SuperPalettes
	add hl, de

	ld de, W2_BgPaletteData + $40

startPaletteTransfer:
	add a
	add a
	add a
	add e
	ld e, a
	ld b, 8

.palLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .palLoop

	pop af
	ldh [rWBK], a
	ret

INCLUDE "data/sgb/sgb_palettes.asm"

LoadShinyPalette::
	; Save current WRAM bank and switch to bank 2.
	ldh a, [rWBK]
	ld b, a
	ld a, 2
	ldh [rWBK], a
	push bc
	; Preserve the destination palette slot.
	push de
	ld a, d
	sub PAL_MEWMON
	ld l, a
	ld h, 0

	; Each palette contains 8 bytes.
	add hl, hl
	add hl, hl
	add hl, hl

	; Point to the corresponding shiny RGB data.
	ld de, ShinyPalettes
	add hl, de

	; Restore the destination palette slot.
	pop de
	ld a, e

	; Copy the palette into GBC background palette memory.
	ld de, W2_BgPaletteData
	jp startPaletteTransfer
