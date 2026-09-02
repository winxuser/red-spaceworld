    db DEX_GUROTESU ; pokedex id

	db  85,  90,  65,  95,  85
	;   hp   atk  def  spd  spc

	db WATER, METAL ; type
	db 45 ; catch rate
	db 178 ; base exp

	INCBIN "gfx/pokemon/gurotesu/front.pic", 0, 1 ; sprite dimensions
	dw GurotesuPicFront, GurotesuPicBack

	db BITE, WATER_GUN, LEER, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   RAGE,         THUNDERBOLT,  THUNDER,      \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE,   SURF
	; end

	db BANK(GurotesuPicFront)
