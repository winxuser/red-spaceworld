    db DEX_KONYA ; pokedex id

	db  20,  35,  25,  70,  30
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 255 ; catch rate
	db 48 ; base exp

	INCBIN "gfx/pokemon/konya/front.pic", 0, 1 ; sprite dimensions
	dw KonyaPicFront, KonyaPicBack

	db SCRATCH, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  PAY_DAY,      \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE
	; end

	db BANK(KonyaPicFront)
