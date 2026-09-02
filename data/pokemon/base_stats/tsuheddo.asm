    db DEX_TSUHEDDO ; pokedex id

	db  70,  90,  70,  40,  60
	;   hp  atk  def  spd  spc

	db BUG, POISON ; type
	db 90 ; catch rate
	db 134 ; base exp

	INCBIN "gfx/pokemon/tsuheddo/front.pic", 0, 1 ; sprite dimensions
	dw TsuheddoPicFront, TsuheddoPicBack

	db POISON_STING, STRING_SHOT, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     REST,         SUBSTITUTE,   FLASH
	; end

	db BANK(TsuheddoPicFront)
