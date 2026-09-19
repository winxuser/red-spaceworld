    db DEX_PEINTA ; pokedex id

	db  55,  20,  35,  75,  20
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 45 ; catch rate
	db 88 ; base exp

	INCBIN "gfx/pokemon/peinta/front.pic", 0, 1 ; sprite dimensions
	dw PeintaPicFront, PeintaPicBack

	db MIMIC, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db BANK(PeintaPicFront)
