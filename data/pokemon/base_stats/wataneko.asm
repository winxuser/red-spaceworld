    db DEX_WATANEKO ; pokedex id

	db  75,  55,  70, 110,  85
	;   hp  atk  def  spd  spc

	db GRASS, FLYING ; type
	db 45 ; catch rate
	db 176 ; base exp

	INCBIN "gfx/pokemon/wataneko/front.pic", 0, 1 ; sprite dimensions
	dw WatanekoPicFront, WatanekoPicBack

	db TACKLE, ABSORB, TAIL_WHIP, POISONPOWDER ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         REST,         SUBSTITUTE,   FLASH
	; end

	db BANK(WatanekoPicFront)
