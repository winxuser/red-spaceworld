    db DEX_ANNON ; pokedex id

	db  48,  72,  48,  48,  72
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 225 ; catch rate
	db 61 ; base exp

	INCBIN "gfx/pokemon/annon/front.pic", 0, 1 ; sprite dimensions
	dw AnnonPicFront, AnnonPicBack

	db TRI_ATTACK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db BANK(AnnonPicFront)
