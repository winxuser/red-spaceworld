db DEX_HERUGA ; pokedex id

	db  75,  90,  50,  95, 110
	;   hp  atk  def  spd  spc

	db DARK, FIRE ; type
	db 45 ; catch rate
	db 204 ; base exp

	INCBIN "gfx/pokemon/heruga/front.pic", 0, 1 ; sprite dimensions
	dw HerugaPicFront, HerugaPicBack

	db LEER, EMBER, ROAR, SMOG ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         FIRE_BLAST,   \
	     SWIFT,        REST,         SUBSTITUTE
	; end

	db BANK(HerugaPicFront)
