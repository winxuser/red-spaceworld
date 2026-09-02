db DEX_ANIMON ; pokedex id

	db  68,  68,  68,  68,  68
	;   hp  atk  def  spd  spc

	db METAL, METAL ; type (or NORMAL / NORMAL if Steel is not backported)
	db 35 ; catch rate
	db 126 ; base exp

	INCBIN "gfx/pokemon/animon/front.pic", 0, 1 ; sprite dimensions
	dw AnimonPicFront, AnimonPicBack

	db TRANSFORM, SCREECH, HARDEN, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         \
	     SUBSTITUTE,   FLASH
	; end

	db BANK(AnimonPicFront)
