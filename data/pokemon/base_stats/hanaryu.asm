	db DEX_HANARYU ; pokedex id

	db  70,  65,  60,  50,  60
	;   hp  atk  def  spd  spc

	db GRASS, GRASS ; type
	db 45 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/hanaryu/front.pic", 0, 1 ; sprite dimensions
	dw HanaryuPicFront, HanaryuPicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   CUT,          \
	     FLASH
	; end

	db BANK(HanaryuPicFront)
