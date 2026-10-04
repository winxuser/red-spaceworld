    db DEX_BOMUSHIKA ; pokedex id

	db  70,  75,  70,  80,  95
	;   hp  atk  def  spd  spc

	db WATER, FIRE ; type
	db 120 ; catch rate
	db 150 ; base exp

	INCBIN "gfx/pokemon/bomushika/front.pic", 0, 1 ; sprite dimensions
	dw BomushikaPicFront, BomushikaPicBack

	db WATER_GUN, EMBER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         FIRE_BLAST,   SWIFT,        \
	     REST,         SUBSTITUTE,   SURF
	; end

	db BANK(BomushikaPicFront)
