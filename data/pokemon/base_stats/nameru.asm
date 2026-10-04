    db DEX_NAMERU ; pokedex id

	db  110,  95,  95,  50,  85
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 30 ; catch rate
	db 180 ; base exp

	INCBIN "gfx/pokemon/nameru/front.pic", 0, 1 ; sprite dimensions
	dw NameruPicFront, NameruPicBack

	db LICK, SUPERSONIC, DEFENSE_CURL, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     THUNDERBOLT,  THUNDER,      EARTHQUAKE,   FISSURE,      MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         FIRE_BLAST,   SKULL_BASH,   REST,         \
	     SUBSTITUTE,   STRENGTH
	; end

	db BANK(NameruPicFront)
