db DEX_PUKU ; pokedex id

	db  60,  55,  50,  40,  40
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 255 ; catch rate
	db  65 ; base exp

	INCBIN "gfx/pokemon/puku/front.pic", 0, 1 ; sprite dimensions
	dw PukuPicFront, PukuPicBack

	db TACKLE, WATER_GUN, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         REST,         SUBSTITUTE,   SURF
	; end

	db BANK(PukuPicFront)
