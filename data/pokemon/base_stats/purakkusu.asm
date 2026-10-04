    db DEX_PURAKKUSU ; pokedex id

	db  65, 125, 100,  85,  55
	;   hp  atk  def  spd  spc

	db BUG, BUG ; type
	db 45 ; catch rate
	db 200 ; base exp

	INCBIN "gfx/pokemon/purakkusu/front.pic", 0, 1 ; sprite dimensions
	dw PurakkusuPicFront, PurakkusuPicBack

	db VICEGRIP, HARDEN, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         \
	     SUBSTITUTE,   CUT,          STRENGTH
	; end

	db BANK(PurakkusuPicFront)
