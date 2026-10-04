db DEX_SHIZASU ; pokedex id

	db  70, 130, 100,  65,  55
	;   hp  atk  def  spd  spc

	db BUG, FLYING ; type
	db 25 ; catch rate
	db 200 ; base exp

	INCBIN "gfx/pokemon/shizasu/front.pic", 0, 1 ; sprite dimensions
	dw ShizasuPicFront, ShizasuPicBack

	db QUICK_ATTACK, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE,   CUT
	; end

	db BANK(ShizasuPicFront)
