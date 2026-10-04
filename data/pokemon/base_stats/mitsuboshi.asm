    db DEX_MITSUBOSHI ; pokedex id

	db  55,  35,  50,  85, 110
	;   hp  atk  def  spd  spc

	db BUG, FLYING ; type
	db 90 ; catch rate
	db 134 ; base exp

	INCBIN "gfx/pokemon/mitsuboshi/front.pic", 0, 1 ; sprite dimensions
	dw MitsuboshiPicFront, MitsuboshiPicBack

	db SCRATCH, AGILITY, QUICK_ATTACK, BITE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        REST,         SUBSTITUTE,   FLASH
	; end

	db BANK(MitsuboshiPicFront)
