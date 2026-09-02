db DEX_MANBO1 ; pokedex id

	db  85,  40,  65,  25,  70
	;   hp   atk  def  spd  spc

	db WATER, WATER ; type
	db 190 ; catch rate
	db 75 ; base exp

	INCBIN "gfx/pokemon/manbo1/front.pic", 0, 1 ; sprite dimensions
	dw Manbo1PicFront, Manbo1PicBack

	db SPLASH, WATER_GUN, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        REST,         SUBSTITUTE,   SURF
	; end

	db BANK(Manbo1PicFront)
