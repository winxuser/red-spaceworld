db DEX_MARIRU ; pokedex id

	db  70,  20,  50,  40,  20
	;   hp   atk  def  spd  spc

	db WATER, WATER ; type
	db 190 ; catch rate
	db 58 ; base exp

	INCBIN "gfx/pokemon/mariru/front.pic", 0, 1 ; sprite dimensions
	dw MariruPicFront, MariruPicBack

	db TACKLE, WATER_GUN, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        REST,         SUBSTITUTE,   SURF
	; end

	db BANK(MariruPicFront)
