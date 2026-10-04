    db DEX_BETOBEBI ; pokedex id

	db  50,  50,  30,  15,  30
	;   hp  atk  def  spd  spc

	db POISON, POISON ; type
	db 255 ; catch rate
	db 45 ; base exp

	INCBIN "gfx/pokemon/betobebi/front.pic", 0, 1 ; sprite dimensions
	dw BetobebiPicFront, BetobebiPicBack

	db POUND, POISON_GAS, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    RAGE,         MEGA_DRAIN,   MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         REST,         SUBSTITUTE
	; end

	db BANK(BetobebiPicFront)
