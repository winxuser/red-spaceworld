    db DEX_GIFUTO ; pokedex id

	db  45,  55,  45,  75,  65
	;   hp  atk  def  spd  spc

	db WATER, ICE ; type
	db 45 ; catch rate
	db 116 ; base exp

	INCBIN "gfx/pokemon/gifuto/front.pic", 0, 1 ; sprite dimensions
	dw GifutoPicFront, GifutoPicBack

	db POUND, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     \
	     BLIZZARD,     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        REST,         SUBSTITUTE,   FLY
	; end

	db BANK(GifutoPicFront)
