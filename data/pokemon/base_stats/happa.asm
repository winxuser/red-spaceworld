	db DEX_HAPPA ; pokedex id

	db  55,  40,  45,  50,  75
	;   hp  atk  def  spd  spc

	db GRASS, GRASS ; type
	db 35 ; catch rate
	db 61 ; base exp

	INCBIN "gfx/pokemon/happa/front.pic", 0, 1 ; sprite dimensions
	dw HappaPicFront, HappaPicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   CUT,          \
	     FLASH
	; end

	db BANK(HappaPicFront)
