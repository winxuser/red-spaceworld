db DEX_HAGANERU ; pokedex id

	db  75,  85, 200,  30,  65
	;   hp  atk  def  spd  spc

	db METAL, GROUND ; type
	db 25 ; catch rate
	db 196 ; base exp

	INCBIN "gfx/pokemon/haganeru/front.pic", 0, 1 ; sprite dimensions
	dw HaganeruPicFront, HaganeruPicBack

	db TACKLE, SCREECH, BIND, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SKULL_BASH,   REST,         ROCK_SLIDE,   \
	     SUBSTITUTE,   STRENGTH
	; end

	db BANK(HaganeruPicFront)
