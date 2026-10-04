    db DEX_KINGUDORA ; pokedex id

	db  75,  95,  95,  85,  95
	;   hp  atk  def  spd  spc

	db DRAGON, WATER ; type
	db 45 ; catch rate
	db 207 ; base exp

	INCBIN "gfx/pokemon/kingudora/front.pic", 0, 1 ; sprite dimensions
	dw KingudoraPicFront, KingudoraPicBack

	db WATER_GUN, SMOKESCREEN, LEER, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         DRAGON_RAGE,  \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        REST,         \
	     SUBSTITUTE,   SURF
	; end

	db BANK(KingudoraPicFront)
