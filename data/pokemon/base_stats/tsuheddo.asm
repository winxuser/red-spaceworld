	db DEX_TSUHEDDO ; 186

	db  50,  50,  50,  50,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db BUG, POISON ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/tsuheddo/front.pic", 0, 1 ; sprite dimensions
	dw TsuheddoPicFront, TsuheddoPicBack

	db POISON_STING, STRING_SHOT, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SKULL_BASH,   REST,         SUBSTITUTE,   \
	     FLASH
	; end

	db BANK(TsuheddoPicFront)
