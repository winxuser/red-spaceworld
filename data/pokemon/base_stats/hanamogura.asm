db DEX_HANAMOGURA ; pokedex id

	db  60,  62,  80,  60,  80
	;   hp   atk  def  spd  spc

	db GRASS, GRASS ; type
	db 45 ; catch rate
	db 142 ; base exp

	INCBIN "gfx/pokemon/hanamogura/front.pic", 0, 1 ; sprite dimensions
	dw HanamoguraPicFront, HanamoguraPicBack

	db TACKLE, GROWL, VINE_WHIP, NO_MOVE ; level 1 learnset (starting with Vine Whip since it's evolved)
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   CUT,          \
	     FLASH
	; end

	db BANK(HanamoguraPicFront)
