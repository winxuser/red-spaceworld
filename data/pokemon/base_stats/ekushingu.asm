    db DEX_EKUSHINGU ; pokedex id

	db  85,  90,  80, 130,  70
	;   hp   atk  def  spd  spc

	db POISON, FLYING ; type
	db 90 ; catch rate
	db 204 ; base exp

	INCBIN "gfx/pokemon/ekushingu/front.pic", 0, 1 ; sprite dimensions
	dw EkushinguPicFront, EkushinguPicBack

	db LEECH_LIFE, SCREECH, BITE, CONFUSE_RAY ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         SUBSTITUTE,   \
	     FLY
	; end

	db BANK(EkushinguPicFront)
