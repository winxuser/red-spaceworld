	db DEX_HANEI ; pokedex id

	db  50,  50,  50,  50,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db WATER, FLYING ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/hanei/front.pic", 0, 1 ; sprite dimensions
	dw HaneiPicFront, HaneiPicBack

	db TACKLE, BUBBLE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         \
	     SUBSTITUTE,   SURF
	; end

	db BANK(HaneiPicFront)
