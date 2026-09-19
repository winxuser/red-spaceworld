db DEX_KIRINRIKI ; pokedex id

	db  70,  80,  65,  85,  90
	;   hp  atk  def  spd  spc

	db DARK, NORMAL ; type
	db 60 ; catch rate
	db 149 ; base exp

	INCBIN "gfx/pokemon/kirinriki/front.pic", 0, 1 ; sprite dimensions
	dw KirinrikiPicFront, KirinrikiPicBack

	db LICK, HYPNOSIS, CONFUSE_RAY, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         EARTHQUAKE,   PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         DREAM_EATER,  SUBSTITUTE,   \
	     STRENGTH
	; end

	db BANK(KirinrikiPicFront)
