db DEX_DENRYU ; pokedex id

	db  90,  75,  75,  55, 115 ; hp, atk, def, spd, spc
	db ELECTRIC, ELECTRIC ; type
	db 45 ; catch rate
	db 230 ; base exp

	INCBIN "gfx/pokemon/denryu/front.pic", 0, 1 ; sprite dimensions
	dw DenryuPicFront, DenryuPicBack

	db TACKLE, GROWL, THUNDERSHOCK, THUNDER_WAVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
     RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        \
     DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        \
     REST,         THUNDER_WAVE, SUBSTITUTE
	; end

	db BANK(DenryuPicFront)
