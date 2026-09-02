db DEX_PICHU ; pokedex id

	db  20,  40,  15,  60,  35
	;   hp  atk  def  spd  spc

	db ELECTRIC, ELECTRIC ; type
	db 190 ; catch rate
	db  41 ; base exp

	INCBIN "gfx/pokemon/pichu/front.pic", 0, 1 ; sprite dimensions
	dw PichuPicFront, PichuPicBack

	db THUNDERSHOCK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  THUNDERBOLT,  \
	     THUNDER,      RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     FLASH,        REST,         THUNDER_WAVE, SUBSTITUTE
	; end

	db BANK(PichuPicFront)
