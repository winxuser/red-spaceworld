    db DEX_MADAMU ; pokedex id

	db  62,  95,  75,  95,  78
	;   hp  atk  def  spd  spc

	db NORMAL, FLYING ; type
	db 45 ; catch rate
	db 162 ; base exp

	INCBIN "gfx/pokemon/madamu/front.pic", 0, 1 ; sprite dimensions
	dw MadamuPicFront, MadamuPicBack

	db PECK, SAND_ATTACK, LEER, FURY_ATTACK ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE,   CUT,          FLY
	; end

	db BANK(MadamuPicFront)
