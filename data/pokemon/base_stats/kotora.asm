    db DEX_KOTORA ; pokedex id

	db  50,  65,  45,  40,  55
	;   hp  atk  def  spd  spc

	db ELECTRIC, ELECTRIC ; type
	db 190 ; catch rate
	db 67 ; base exp

	INCBIN "gfx/pokemon/kotora/front.pic", 0, 1 ; sprite dimensions
	dw KotoraPicFront, KotoraPicBack

	db THUNDERSHOCK, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  THUNDERBOLT,  \
	     THUNDER,      RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        REST,         THUNDER_WAVE, SUBSTITUTE,   FLASH
	; end

	db BANK(KotoraPicFront)
