    db DEX_TSUINZU ; pokedex id

	db  50,  20,  25,  40,  45
	;   hp  atk  def  spd  spc

	db DARK, NORMAL ; type
	db 255 ; catch rate
	db 67 ; base exp

	INCBIN "gfx/pokemon/tsuinzu/front.pic", 0, 1 ; sprite dimensions
	dw TsuinzuPicFront, TsuinzuPicBack

	db LICK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  PSYCHIC_M,    \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     REST,         DREAM_EATER,  SUBSTITUTE
	; end

	db BANK(TsuinzuPicFront)
