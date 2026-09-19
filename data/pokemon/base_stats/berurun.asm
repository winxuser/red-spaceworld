    db DEX_BERURUN ; pokedex id

	db  72,  95,  70,  90,  70
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 90 ; catch rate
	db 158 ; base exp

	INCBIN "gfx/pokemon/berurun/front.pic", 0, 1 ; sprite dimensions
	dw BerurunPicFront, BerurunPicBack

	db SCRATCH, GROWL, BITE, PAY_DAY ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     PAY_DAY,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         \
	     SUBSTITUTE,   STRENGTH
	; end

	db BANK(BerurunPicFront)
