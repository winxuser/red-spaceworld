db DEX_DAINABEA ; pokedex id

	db  85,  100,  75,  80,  85
	;   hp   atk   def  spd  spc

	db FIRE, FIRE ; type
	db 45 ; catch rate
	db 208 ; base exp

	INCBIN "gfx/pokemon/dainabea/front.pic", 0, 1 ; sprite dimensions
	dw DainabeaPicFront, DainabeaPicBack

	db SCRATCH, GROWL, EMBER, FLAMETHROWER ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   SWORDS_DANCE, MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      \
	     SEISMIC_TOSS, RAGE,         DRAGON_RAGE,  EARTHQUAKE,   FISSURE,      \
	     DIG,          MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE,   \
	     CUT,          STRENGTH
	; end

	db BANK(DainabeaPicFront)
