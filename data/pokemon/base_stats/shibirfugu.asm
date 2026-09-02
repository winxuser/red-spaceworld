db DEX_SHIBIRFUGU ; pokedex id

	db  85,  95,  75,  85,  55
	;   hp  atk  def  spd  spc

	db WATER, ELECTRIC ; type
	db 75 ; catch rate
	db 145 ; base exp

	INCBIN "gfx/pokemon/shibirefugu/front.pic", 0, 1 ; sprite dimensions
	dw ShibirefuguPicFront, ShibirefuguPicBack

	db TACKLE, WATER_GUN, THUNDERSHOCK, DEFENSE_CURL ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     THUNDERBOLT,  THUNDER,      \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         \
	     THUNDER_WAVE, SUBSTITUTE,   SURF
	; end

	db BANK(ShibirefuguPicFront)
