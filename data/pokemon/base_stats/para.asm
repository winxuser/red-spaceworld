	db DEX_PARA ; 184

	db  50,  50,  50,  50,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db BUG, GRASS ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/para/front.pic", 0, 1 ; sprite dimensions
	dw ParaPicFront, ParaPicBack

	db SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    DIG,          MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   REST,         \
	     SUBSTITUTE,   CUT
	; end

	db BANK(ParaPicFront)
