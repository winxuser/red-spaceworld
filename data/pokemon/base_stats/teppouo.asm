    db DEX_TEPPOUO ; pokedex id

	db  35,  65,  35,  65,  65
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 190 ; catch rate
	db 78 ; base exp

	INCBIN "gfx/pokemon/teppouo/front.pic", 0, 1 ; sprite dimensions
	dw TeppouoPicFront, TeppouoPicBack

	db WATER_GUN, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         \
	     SUBSTITUTE,   SURF
	; end

	db BANK(TeppouoPicFront)
