    db DEX_PARA ; pokedex id

	db  20,  45,  45,  15,  40
	;   hp   atk  def  spd  spc

	db BUG, GRASS ; type
	db 255 ; catch rate
	db 43 ; base exp

	INCBIN "gfx/pokemon/para/front.pic", 0, 1 ; sprite dimensions
	dw ParaPicFront, ParaPicBack

	db SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    DIG,          \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         \
	     SUBSTITUTE,   FLASH
	; end

	db BANK(ParaPicFront)
