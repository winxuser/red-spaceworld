SECTION "Pokemon Palette Data", ROMX, BANK[$7B]

INCLUDE "data/pokemon/normal_palettes.asm"
INCLUDE "data/pokemon/shiny_palettes.asm"
INCLUDE "data/trainers/palettes.asm"


; d = Pokedex number or trainer class
; e = destination palette slot (0-7)
; Requires WRAM bank 2.

LoadPokemonPalette::
	ld hl, PokemonPalettes
	jr LoadSpeciesPalette

LoadShinyPokemonPalette::
	ld hl, ShinyPokemonPalettes
	jr LoadSpeciesPalette

LoadTrainerPortraitPalette::
	ld hl, TrainerPortraitPalettes
	jr LoadSpeciesPalette


; Sprite palette loaders.

LoadPokemonSpritePalette::
	ld hl, PokemonPalettes
	jr LoadSpeciesSpritePalette

LoadShinyPokemonSpritePalette::
	ld hl, ShinyPokemonPalettes

LoadSpeciesSpritePalette:
	; Sprite palette data follows the eight BG palettes.
	ld a, e
	add 8
	ld e, a
	jr LoadSpeciesPalette


LoadSpeciesPalette:
	; Calculate the destination palette address.
	ld a, e
	add a
	add a
	add a
	ld c, a

	; Calculate the source palette offset.
	ld e, d
	ld d, 0

	sla e
	rl d
	sla e
	rl d
	sla e
	rl d

	add hl, de

	; Point to the destination palette.
	ld de, W2_BgPaletteData
	ld a, e
	add c
	ld e, a

	; Copy four RGB colours (8 bytes).
	ld b, 8

.copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyLoop

	ret
