	db DEX_PINSIR ; pokedex id

	db  65, 125, 100,  85,  55,  75
	;   hp  atk  def  spd  sat  sdf

	db BUG, BUG ; type
	db 45 ; catch rate
	db 200 ; base exp

	INCBIN "gfx/pokemon/pinsir/front.pic", 0, 1 ; sprite dimensions
	dw PinsirPicFront, PinsirPicBack

	db VICEGRIP, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   SUBMISSION,   SEISMIC_TOSS, RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         REST,         SUBSTITUTE,   CUT,          \
	     STRENGTH
	; end

	db BANK(PinsirPicFront)
