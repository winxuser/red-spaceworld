	db DEX_YOROIDORI ; 187

	db  50,  50,  50,  50,  50,  50
	;   hp  atk  def  spd  sat  sdf

	db STEEL, FLYING ; type
	db 255 ; catch rate
	db 100 ; base exp

	INCBIN "gfx/pokemon/yoroidori/front.pic", 0, 1 ; sprite dimensions
	dw YoroidoriPicFront, YoroidoriPicBack

	db LEER, PECK, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        SKY_ATTACK,   \
	     REST,         THUNDER_WAVE, SUBSTITUTE,   CUT,          FLY
	; end

	db BANK(YoroidoriPicFront)
