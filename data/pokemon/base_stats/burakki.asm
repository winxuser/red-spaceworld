db DEX_BURAKKI ; pokedex id

	db  95,  65, 110,  65, 130
	;   hp  atk  def  spd  spc

	db POISON, POISON ; type
	db 45 ; catch rate
	db 197 ; base exp

	INCBIN "gfx/pokemon/burakki/front.pic", 0, 1 ; sprite dimensions
	dw BurakkiPicFront, BurakkiPicBack

	db TACKLE, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        REST,         SUBSTITUTE,   FLASH
	; end

	db BANK(BurakkiPicFront)
