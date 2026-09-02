    db DEX_PUPURIN ; pokedex id

	db  90,  30,  15,  15,  40
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 170 ; catch rate
	db  39 ; base exp

	INCBIN "gfx/pokemon/pupurin/front.pic", 0, 1 ; sprite dimensions
	dw PupurinPicFront, PupurinPicBack

	db SING, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         SOLARBEAM,    \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         PSYWAVE,      \
	     SUBSTITUTE,   FLASH
	; end

	db BANK(PupurinPicFront)
