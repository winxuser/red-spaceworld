    db DEX_TOGEPI ; pokedex id

	db  35,  20,  65,  20,  40
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 190 ; catch rate
	db 74 ; base exp

	INCBIN "gfx/pokemon/togepi/front.pic", 0, 1 ; sprite dimensions
	dw TogepiPicFront, TogepiPicBack

	db GROWL, METRONOME, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     METRONOME,    REST,         THUNDER_WAVE, PSYWAVE,      SUBSTITUTE,   \
	     FLASH
	; end

	db BANK(TogepiPicFront)
