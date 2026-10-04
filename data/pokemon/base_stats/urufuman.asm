    db DEX_URUFUMAN ; pokedex id

	db  75, 100,  70,  85,  75
	;   hp  atk  def  spd  spc

	db NORMAL, FIGHTING ; type
	db 45 ; catch rate
	db 175 ; base exp

	INCBIN "gfx/pokemon/urufuman/front.pic", 0, 1 ; sprite dimensions
	dw UrufumanPicFront, UrufumanPicBack

	db SCRATCH, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     REST,         SUBSTITUTE,   STRENGTH
	; end

	db BANK(UrufumanPicFront)
