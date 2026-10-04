    db DEX_DEBIRU ; pokedex id

	db  45,  60,  30,  65,  80
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 120 ; catch rate
	db 114 ; base exp

	INCBIN "gfx/pokemon/debiru/front.pic", 0, 1 ; sprite dimensions
	dw DebiruPicFront, DebiruPicBack

	db LEER, EMBER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         FIRE_BLAST,   SWIFT,        \
	     REST,         SUBSTITUTE
	; end

	db BANK(DebiruPicFront)
