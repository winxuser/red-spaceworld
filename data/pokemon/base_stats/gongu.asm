    db DEX_GONGU ; pokedex id

	db  35,  35,  35,  35,  35
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 212 ; catch rate
	db 61 ; base exp

	INCBIN "gfx/pokemon/gongu/front.pic", 0, 1 ; sprite dimensions
	dw GonguPicFront, GonguPicBack

	db TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  SUBMISSION,   \
	     COUNTER,      SEISMIC_TOSS, RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         SUBSTITUTE,   STRENGTH
	; end

	db BANK(GonguPicFront)
