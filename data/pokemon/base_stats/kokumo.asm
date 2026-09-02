    db DEX_KOKUMO ; pokedex id

	db  30,  50,  35,  25,  30
	;   hp   atk  def  spd  spc

	db BUG, POISON ; type
	db 255 ; catch rate
	db 52 ; base exp

	INCBIN "gfx/pokemon/kokumo/front.pic", 0, 1 ; sprite dimensions
	dw KokumoPicFront, KokumoPicBack

	db POISON_STING, STRING_SHOT, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         REST,         SUBSTITUTE,   \
	     FLASH
	; end

	db BANK(KokumoPicFront)
