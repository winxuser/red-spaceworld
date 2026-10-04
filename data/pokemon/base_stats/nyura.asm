db DEX_NYURA ; pokedex id

	db  55,  95,  55, 115,  75
	;   hp  atk  def  spd  spc

	db DARK, DARK ; type
	db 60 ; catch rate
	db 132 ; base exp

	INCBIN "gfx/pokemon/nyura/front.pic", 0, 1 ; sprite dimensions
	dw NyuraPicFront, NyuraPicBack

	db SCRATCH, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        REST,         SUBSTITUTE,   CUT,          \
	     SURF
	; end

	db BANK(NyuraPicFront)
