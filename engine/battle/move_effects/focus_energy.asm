FocusEnergyEffect_:
	ld hl, wPlayerBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .notEnemy
	ld hl, wEnemyBattleStatus2
.notEnemy
	bit GETTING_PUMPED, [hl] ; is mon already using focus energy?
	jr nz, .alreadyUsing
	set GETTING_PUMPED, [hl] ; mon is now using focus energy
	callfar PlayCurrentMoveAnimation
	ld hl, GettingPumpedText
	rst _PrintText
	ret
.alreadyUsing
	ld c, 50
	rst _DelayFrame
	jpfar PrintButItFailedText_

GettingPumpedText:
	text_pause
	text_far _GettingPumpedText
	text_end
