    db DEX_RAITORA ; pokedex id

	db  75,  95,  70,  70,  85
	;   hp  atk  def  spd  spc

	db ELECTRIC, ELECTRIC ; type
	db 45 ; catch rate
	db 168 ; base exp

	INCBIN "gfx/pokemon/raitora/front.pic", 0, 1 ; sprite dimensions
	dw RaitoraPicFront, RaitoraPicBack

	db THUNDERSHOCK, LEER, QUICK_ATTACK, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         THUNDER_WAVE, SUBSTITUTE,   \
	     STRENGTH,     FLASH
	; end

	db BANK(RaitoraPicFront)
