    db DEX_RIIFI ; pokedex id

	db  65,  60,  65,  95, 110
	;   hp  atk  def  spd  spc

	db GRASS, GRASS ; type
	db 45 ; catch rate
	db 197 ; base exp

	INCBIN "gfx/pokemon/riifi/front.pic", 0, 1 ; sprite dimensions
	dw RiifiPicFront, RiifiPicBack

	db TACKLE, TAIL_WHIP, VINE_WHIP, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        REST,         SUBSTITUTE,   CUT           \
	; end

	db BANK(RiifiPicFront)
