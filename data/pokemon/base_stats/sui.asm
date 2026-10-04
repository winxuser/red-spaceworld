    db DEX_SUI ; pokedex id

	db 100,  75, 115,  85, 115
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 3 ; catch rate
	db 215 ; base exp

	INCBIN "gfx/pokemon/sui/front.pic", 0, 1 ; sprite dimensions
	dw SuiPicFront, SuiPicBack

	db BITE, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE,   SURF
	; end

	db BANK(SuiPicFront)
