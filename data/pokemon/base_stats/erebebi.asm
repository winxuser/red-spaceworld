    db DEX_EREBEBI ; pokedex id

	db  45,  63,  37,  95,  55
	;   hp  atk  def  spd  spc

	db ELECTRIC, ELECTRIC ; type
	db 45 ; catch rate
	db 106 ; base exp

	INCBIN "gfx/pokemon/erebebi/front.pic", 0, 1 ; sprite dimensions
	dw ErebebiPicFront, ErebebiPicBack

	db QUICK_ATTACK, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  THUNDERBOLT,  \
	     THUNDER,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         \
	     THUNDER_WAVE, PSYWAVE,      SUBSTITUTE,   FLASH
	; end

	db BANK(ErebebiPicFront)
