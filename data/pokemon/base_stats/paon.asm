    db DEX_PAON ; pokedex id

	db  45,  60,  60,  40,  40
	;   hp  atk  def  spd  spc

	db GROUND, GROUND ; type
	db 120 ; catch rate
	db 124 ; base exp

	INCBIN "gfx/pokemon/paon/front.pic", 0, 1 ; sprite dimensions
	dw PaonPicFront, PaonPicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  SUBMISSION,   \
	     COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   FISSURE,      \
	     DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         \
	     SUBSTITUTE
	; end

	db BANK(PaonPicFront)
