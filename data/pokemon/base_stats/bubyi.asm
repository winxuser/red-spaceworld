    db DEX_BUBYI ; pokedex id

	db  45,  75,  37,  83,  70
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 45 ; catch rate
	db 117 ; base exp

	INCBIN "gfx/pokemon/bubyi/front.pic", 0, 1 ; sprite dimensions
	dw BubyiPicFront, BubyiPicBack

	db EMBER, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  SUBMISSION,   \
	     COUNTER,      SEISMIC_TOSS, RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         FIRE_BLAST,   SWIFT,        REST,         PSYWAVE,      \
	     SUBSTITUTE
	; end

	db BANK(BubyiPicFront)
