    db DEX_KAPOERA ; pokedex id

	db  50,  95,  95,  70,  35
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db 138 ; base exp

	INCBIN "gfx/pokemon/kapoera/front.pic", 0, 1 ; sprite dimensions
	dw KapoeraPicFront, KapoeraPicBack

	db ROLLING_KICK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  SUBMISSION,   \
	     COUNTER,      SEISMIC_TOSS, RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         SUBSTITUTE,   STRENGTH
	; end

	db BANK(KapoeraPicFront)
