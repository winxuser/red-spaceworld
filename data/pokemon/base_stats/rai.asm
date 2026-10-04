    db DEX_RAI ; pokedex id

	db  90,  85,  75, 115, 115
	;   hp  atk  def  spd  spc

	db ELECTRIC, ELECTRIC ; type
	db 3 ; catch rate
	db 216 ; base exp

	INCBIN "gfx/pokemon/rai/front.pic", 0, 1 ; sprite dimensions
	dw RaiPicFront, RaiPicBack

	db BITE, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SWIFT,        REST,         THUNDER_WAVE, \
	     SUBSTITUTE,   FLASH
	; end

	db BANK(RaiPicFront)
