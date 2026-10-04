    db DEX_YAMIKARASU ; pokedex id

	db  60,  85,  42,  91,  85
	;   hp  atk  def  spd  spc

	db DARK, FLYING ; type
	db 135 ; catch rate
	db 107 ; base exp

	INCBIN "gfx/pokemon/yamikarasu/front.pic", 0, 1 ; sprite dimensions
	dw YamikarasuPicFront, YamikarasuPicBack

	db PECK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SWIFT,        DREAM_EATER,  REST,         \
	     SUBSTITUTE,   FLY
	; end

	db BANK(YamikarasuPicFront)
