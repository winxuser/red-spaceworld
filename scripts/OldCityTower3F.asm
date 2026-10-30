OldCityTower3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, OldCityTower3TrainerHeaders
	ld de, OldCityTower3F_ScriptPointers
	ld a, [wOldCityTower3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wOldCityTower3FCurScript], a
	ret

OldCityTower3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_OLDCITYTOWER3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_OLDCITYTOWER3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_OLDCITYTOWER3F_END_BATTLE

OldCityTower3F_TextPointers:
	def_text_pointers
	dw_const OldCityTower3FChanneler1Text, TEXT_OLDCITYTOWER3F_CHANNELER1
	dw_const OldCityTower3FChanneler2Text, TEXT_OLDCITYTOWER3F_CHANNELER2
	dw_const OldCityTower3FChanneler3Text, TEXT_OLDCITYTOWER3F_CHANNELER3
	dw_const PickUpItemText,               TEXT_OLDCITYTOWER3F_ESCAPE_ROPE

OldCityTower3TrainerHeaders:
	def_trainers
OldCityTower3TrainerHeader0:
	trainer EVENT_BEAT_OLDCITYTOWER_3_TRAINER_0, 2, OldCityTower3FChanneler1BattleText, OldCityTower3FChanneler1EndBattleText, OldCityTower3FChanneler1AfterBattleText
OldCityTower3TrainerHeader1:
	trainer EVENT_BEAT_OLDCITYTOWER_3_TRAINER_1, 3, OldCityTower3FChanneler2BattleText, OldCityTower3FChanneler2EndBattleText, OldCityTower3FChanneler2AfterBattleText
OldCityTower3TrainerHeader2:
	trainer EVENT_BEAT_OLDCITYTOWER_3_TRAINER_2, 2, OldCityTower3FChanneler3BattleText, OldCityTower3FChanneler3EndBattleText, OldCityTower3FChanneler3AfterBattleText
	db -1 ; end

OldCityTower3FChanneler1Text:
	text_asm
	ld hl, OldCityTower3TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

OldCityTower3FChanneler2Text:
	text_asm
	ld hl, OldCityTower3TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

OldCityTower3FChanneler3Text:
	text_asm
	ld hl, OldCityTower3TrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

OldCityTower3FChanneler1BattleText:
	text_far _OldCityTower3FChanneler1BattleText
	text_end

OldCityTower3FChanneler1EndBattleText:
	text_far _OldCityTower3FChanneler1EndBattleText
	text_end

OldCityTower3FChanneler1AfterBattleText:
	text_far _OldCityTower3FChanneler1AfterBattleText
	text_end

OldCityTower3FChanneler2BattleText:
	text_far _OldCityTower3FChanneler2BattleText
	text_end

OldCityTower3FChanneler2EndBattleText:
	text_far _OldCityTower3FChanneler2EndBattleText
	text_end

OldCityTower3FChanneler2AfterBattleText:
	text_far _OldCityTower3FChanneler2AfterBattleText
	text_end

OldCityTower3FChanneler3BattleText:
	text_far _OldCityTower3FChanneler3BattleText
	text_end

OldCityTower3FChanneler3EndBattleText:
	text_far _OldCityTower3FChanneler3EndBattleText
	text_end

OldCityTower3FChanneler3AfterBattleText:
	text_far _OldCityTower3FChanneler3AfterBattleText
	text_end
