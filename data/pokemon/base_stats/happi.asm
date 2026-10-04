db DEX_HAPPI ; pokedex id

	db 250,   5,   5,  50,  65
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 30 ; catch rate
	db 110 ; base exp

	INCBIN "gfx/pokemon/happi/front.pic", 0, 1 ; sprite dimensions
	dw HappiPicFront, HappiPicBack

	db POUND, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         SOLARBEAM,    \
	     THUNDERBOLT,  THUNDER,      PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         METRONOME,    FIRE_BLAST,   SKULL_BASH,   \
	     SOFTBOILED,   REST,         THUNDER_WAVE, PSYWAVE,      SUBSTITUTE,   \
	     FLASH
	; end

	db BANK(HappiPicFront)
