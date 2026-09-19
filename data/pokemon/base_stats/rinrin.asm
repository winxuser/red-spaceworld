db DEX_RINRIN ; pokedex id

	db  52,  65,  50,  70,  50
	;   hp  atk  def  spd  spc

	db DARK, DARK ; type
	db 190 ; catch rate
	db 89 ; base exp

	INCBIN "gfx/pokemon/rinrin/front.pic", 0, 1 ; sprite dimensions
	dw RinrinPicFront, RinrinPicBack

	db SCRATCH, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  PAY_DAY,      \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         SUBSTITUTE
	; end

	db BANK(RinrinPicFront)
