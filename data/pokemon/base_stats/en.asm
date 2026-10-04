    db DEX_EN ; pokedex id

	db 115, 115,  85, 100,  90
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 3 ; catch rate
	db 217 ; base exp

	INCBIN "gfx/pokemon/en/front.pic", 0, 1 ; sprite dimensions
	dw EnPicFront, EnPicBack

	db BITE, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SWIFT,        REST,         SUBSTITUTE
	; end

	db BANK(EnPicFront)
