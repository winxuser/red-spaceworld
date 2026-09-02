    db DEX_MIZUO ; pokedex id

	db  75,  80,  65,  100,  80
	;   hp  atk  def   spd  spc

	db WATER, WATER ; type
	db 90 ; catch rate
	db 150 ; base exp

	INCBIN "gfx/pokemon/mizuo/front.pic", 0, 1 ; sprite dimensions
	dw MizuoPicFront, MizuoPicBack

	db WATER_GUN, SUPERSONIC, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         \
	     SUBSTITUTE,   SURF
	; end

	db BANK(MizuoPicFront)
