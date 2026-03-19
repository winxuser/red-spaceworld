	db DEX_HANAMOGURA ; pokedex id

	db  50,  45,  50,  50,  45,  50
	;   hp  atk  def  spd  sat  sdf

	db GRASS, GRASS ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/hanamogura/front.pic", 0, 1 ; sprite dimensions
	dw HanamoguraPicFront, HanamoguraPicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   CUT,          \
	     FLASH
	; end

	db BANK(HanamoguraPicFront)
