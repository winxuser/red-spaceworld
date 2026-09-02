    db DEX_NEITI ; pokedex id

	db  40,  50,  45,  70,  70
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FLYING ; type
	db 190 ; catch rate
	db  73 ; base exp

	INCBIN "gfx/pokemon/neiti/front.pic", 0, 1 ; sprite dimensions
	dw NeitiPicFront, NeitiPicBack

	db PECK, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         PSYWAVE,      \
	     SUBSTITUTE,   FLY
	; end

	db BANK(NeitiPicFront)
