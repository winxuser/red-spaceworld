	db DEX_NOROWARA ; pokedex id

	db  50,  50,  55,  30,  75
	;   hp  atk  def  spd  spc

	db GHOST, GHOST ; type
	db 120 ; catch rate
	db 80 ; base exp

	INCBIN "gfx/pokemon/norowara/front.pic", 0, 1 ; sprite dimensions
	dw NorowaraPicFront, NorowaraPicBack

	db LICK, CONFUSE_RAY, NIGHT_SHADE, NO_MOVE ; level 1 learnset (Gastly standard)
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         DREAM_EATER,  REST,         \
	     PSYWAVE,      SUBSTITUTE,   FLASH
	; end

	db BANK(NorowaraPicFront)
