    db DEX_REDIBA ; pokedex id

	db  40,  20,  30,  55,  80
	;   hp  atk  def  spd  spc

	db BUG, FLYING ; type
	db 255 ; catch rate
	db 54 ; base exp

	INCBIN "gfx/pokemon/rediba/front.pic", 0, 1 ; sprite dimensions
	dw RedibaPicFront, RedibaPicBack

	db TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         MEGA_DRAIN,   \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE,   FLASH
	; end

	db BANK(RedibaPicFront)
