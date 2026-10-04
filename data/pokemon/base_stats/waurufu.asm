db DEX_WAURUFU ; pokedex id

	db  90, 125,  85,  95,  85
	;   hp  atk  def  spd  spc

	db NORMAL, FIGHTING ; type
	db 45 ; catch rate
	db 205 ; base exp

	INCBIN "gfx/pokemon/waurufu/front.pic", 0, 1 ; sprite dimensions
	dw WaurufuPicFront, WaurufuPicBack

	db SCRATCH, LEER, FURY_SWIPES, KARATE_CHOP ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE,   STRENGTH
	; end

	db BANK(WaurufuPicFront)
