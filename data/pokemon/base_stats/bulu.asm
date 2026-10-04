    db DEX_BULU ; pokedex id

	db  60,  80,  50,  30,  40
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 190 ; catch rate
	db 63 ; base exp

	INCBIN "gfx/pokemon/bulu/front.pic", 0, 1 ; sprite dimensions
	dw BuluPicFront, BuluPicBack

	db TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         \
	     SUBSTITUTE,   STRENGTH
	; end

	db BANK(BuluPicFront)
