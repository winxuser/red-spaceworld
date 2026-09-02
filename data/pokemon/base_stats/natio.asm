    db DEX_NATIO ; pokedex id

	db  65,  75,  70,  95,  95
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FLYING ; type
	db 75 ; catch rate
	db 171 ; base exp

	INCBIN "gfx/pokemon/natio/front.pic", 0, 1 ; sprite dimensions
	dw NatioPicFront, NatioPicBack

	db PECK, LEER, NIGHT_SHADE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     REST,         PSYWAVE,      SUBSTITUTE,   FLY
	; end

	db BANK(NatioPicFront)
