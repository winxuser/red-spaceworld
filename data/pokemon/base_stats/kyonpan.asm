    db DEX_KYONPAN ; pokedex id

	db  65,  75,  70,  50,  95
	;   hp  atk  def  spd  spc

	db GHOST, GHOST ; type
	db 75 ; catch rate
	db 142 ; base exp

	INCBIN "gfx/pokemon/kyonpan/front.pic", 0, 1 ; sprite dimensions
	dw KyonpanPicFront, KyonpanPicBack

	db LICK, CONFUSE_RAY, NIGHT_SHADE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         DREAM_EATER,  \
	     REST,         PSYWAVE,      SUBSTITUTE,   FLASH
	; end

	db BANK(KyonpanPicFront)
