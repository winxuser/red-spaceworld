	db DEX_TEIRU ; pokedex id

	db  55,  70,  55,  85,  40
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 45 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/teiru/front.pic", 0, 1 ; sprite dimensions
	dw TeiruPicFront, TeiruPicBack

	db SCRATCH, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, SUBSTITUTE,   \
	     STRENGTH
	; end

	db BANK(TeiruPicFront)
