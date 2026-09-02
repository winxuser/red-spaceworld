db DEX_SANI ; pokedex id

	db  75,  75,  55,  30, 105
	;   hp  atk  def  spd  spc

	db GRASS, PSYCHIC_TYPE ; type
	db 120 ; catch rate
	db 146 ; base exp

	INCBIN "gfx/pokemon/sani/front.pic", 0, 1 ; sprite dimensions
	dw SaniPicFront, SaniPicBack

	db ABSORB, POUND, GROWTH, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     REST,         SUBSTITUTE,   FLASH
	; end

	db BANK(SaniPicFront)
