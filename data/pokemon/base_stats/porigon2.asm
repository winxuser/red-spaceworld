    db DEX_PORIGON2 ; pokedex id

	db  85,  80,  90,  60, 105
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 45 ; catch rate
	db 180 ; base exp

	INCBIN "gfx/pokemon/porigon2/front.pic", 0, 1 ; sprite dimensions
	dw Porigon2PicFront, Porigon2PicBack

	db TACKLE, CONVERSION, RECOVER, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   RAGE,         THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     TRI_ATTACK,   SUBSTITUTE,   FLASH
	; end

	db BANK(Porigon2PicFront)
