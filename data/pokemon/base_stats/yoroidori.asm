db DEX_YOROIDORI ; pokedex id

	db  65,  80, 140,  70,  40
	;   hp  atk  def  spd  spc

	db METAL, FLYING ; type
	db 25 ; catch rate
	db 168 ; base exp

	INCBIN "gfx/pokemon/yoroidori/front.pic", 0, 1 ; sprite dimensions
	dw YoroidoriPicFront, YoroidoriPicBack

	db LEER, PECK, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         \
	     SUBSTITUTE,   FLY
	; end

	db BANK(YoroidoriPicFront)
