 db DEX_IKARI ; pokedex id

	db 105, 100,  95,  65,  70
	;   hp   atk  def  spd  spc

	db WATER, METAL
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/ikari/front.pic", 0, 1 ; sprite dimensions
	dw IkariPicFront, IkariPicBack

	db SPLASH, WATER_GUN, BITE, SCREECH ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         SUBSTITUTE,   \
	     SURF
	; end

	db BANK(IkariPicFront)
