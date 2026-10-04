    db DEX_PUCHIKON ; pokedex id

	db  25,  60,  30,  65,  40
	;   hp  atk  def  spd  spc

	db FIRE, NORMAL ; type
	db 255 ; catch rate
	db 64 ; base exp

	INCBIN "gfx/pokemon/puchikon/front.pic", 0, 1 ; sprite dimensions
	dw PuchikonPicFront, PuchikonPicBack

	db TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         FIRE_BLAST,   \
	     SWIFT,        REST,         SUBSTITUTE
	; end

	db BANK(PuchikonPicFront)
