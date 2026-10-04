    db DEX_OKUTAN ; pokedex id

	db  75, 105,  75,  45, 105
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 75 ; catch rate
	db 168 ; base exp

	INCBIN "gfx/pokemon/okutan/front.pic", 0, 1 ; sprite dimensions
	dw OkutanPicFront, OkutanPicBack

	db WATER_GUN, CONSTRICT, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         \
	     SUBSTITUTE,   SURF
	; end

	db BANK(OkutanPicFront)
