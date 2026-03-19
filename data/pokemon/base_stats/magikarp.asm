	db DEX_MAGIKARP ; pokedex id

	db  20,  10,  55,  80,  15,  20
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 255 ; catch rate
	db 20 ; base exp

	INCBIN "gfx/pokemon/magikarp/front.pic", 0, 1 ; sprite dimensions
	dw MagikarpPicFront, MagikarpPicBack

	db SPLASH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db BANK(MagikarpPicFront)
