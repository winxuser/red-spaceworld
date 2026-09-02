db DEX_PY ; pokedex id

	db  50,  25,  28,  15,  45
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 150 ; catch rate
	db  37 ; base exp

	INCBIN "gfx/pokemon/py/front.pic", 0, 1 ; sprite dimensions
	dw PyPicFront, PyPicBack

	db POUND, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    RAGE,         SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         METRONOME,    REST,         PSYWAVE,      SUBSTITUTE,   \
	     FLASH
	; end

	db BANK(PyPicFront)
