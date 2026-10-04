    db DEX_KIREIHANA ; pokedex id

	db  75,  80,  85,  50, 100
	;   hp  atk  def  spd  spc

	db GRASS, POISON ; type (Spaceworld '97 typing)
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/kireihana/front.pic", 0, 1 ; sprite dimensions
	dw KireihanaPicFront, KireihanaPicBack

	db STUN_SPORE, SLEEP_POWDER, ACID, PETAL_DANCE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   CUT,          \
	     FLASH
	; end

	db BANK(KireihanaPicFront)
