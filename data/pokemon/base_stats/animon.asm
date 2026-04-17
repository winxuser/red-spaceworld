	db DEX_ANIMON ; 188

	db  50,  50,  50,  50,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, STEEL ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/animon/front.pic", 0, 1 ; sprite dimensions
	dw AnimonPicFront, AnimonPicBack

	db TRANSFORM, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db BANK(AnimonPicFront)
