OldCityTower4F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, OldCityTower4TrainerHeaders
	ld de, OldCityTower4F_ScriptPointers
	ld a, [wOldCityTower4FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wOldCityTower4FCurScript], a
	ret

OldCityTower4F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_OLDCITYTOWER4F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_OLDCITYTOWER4F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_OLDCITYTOWER4F_END_BATTLE

OldCityTower4F_TextPointers:
	def_text_pointers
	dw_const OldCityTower4FChanneler1Text, TEXT_OLDCITYTOWER4F_CHANNELER1
	dw_const OldCityTower4FChanneler2Text, TEXT_OLDCITYTOWER4F_CHANNELER2
	dw_const OldCityTower4FChanneler3Text, TEXT_OLDCITYTOWER4F_CHANNELER3
	dw_const PickUpItemText,               TEXT_OLDCITYTOWER4F_ELIXER
	dw_const PickUpItemText,               TEXT_OLDCITYTOWER4F_AWAKENING
	dw_const PickUpItemText,               TEXT_OLDCITYTOWER4F_HP_UP

OldCityTower4TrainerHeaders:
	def_trainers
OldCityTower4TrainerHeader0:
	trainer EVENT_BEAT_OLDCITYTOWER_4_TRAINER_0, 2, OldCityTower4FChanneler1BattleText, OldCityTower4FChanneler1EndBattleText, OldCityTower4FChanneler1AfterBattleText
OldCityTower4TrainerHeader1:
	trainer EVENT_BEAT_OLDCITYTOWER_4_TRAINER_1, 2, OldCityTower4FChanneler2BattleText, OldCityTower4FChanneler2EndBattleText, OldCityTower4FChanneler2AfterBattleText
OldCityTower4TrainerHeader2:
	trainer EVENT_BEAT_OLDCITYTOWER_4_TRAINER_2, 2, OldCityTower4FChanneler3BattleText, OldCityTower4FChanneler3EndBattleText, OldCityTower4FChanneler3AfterBattleText
	db -1 ; end

OldCityTower4FChanneler1Text:
	text_asm
	ld hl, OldCityTower4TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

OldCityTower4FChanneler2Text:
	text_asm
	ld hl, OldCityTower4TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

OldCityTower4FChanneler3Text:
	text_asm
	ld hl, OldCityTower4TrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

OldCityTower4FChanneler1BattleText:
	text_far _OldCityTower4FChanneler1BattleText
	text_end

OldCityTower4FChanneler1EndBattleText:
	text_far _OldCityTower4FChanneler1EndBattleText
	text_end

OldCityTower4FChanneler1AfterBattleText:
	text_far _OldCityTower4FChanneler1AfterBattleText
	text_end

OldCityTower4FChanneler2BattleText:
	text_far _OldCityTower4FChanneler2BattleText
	text_end

OldCityTower4FChanneler2EndBattleText:
	text_far _OldCityTower4FChanneler2EndBattleText
	text_end

OldCityTower4FChanneler2AfterBattleText:
	text_far _OldCityTower4FChanneler2AfterBattleText
	text_end

OldCityTower4FChanneler3BattleText:
	text_far _OldCityTower4FChanneler3BattleText
	text_end

OldCityTower4FChanneler3EndBattleText:
	text_far _OldCityTower4FChanneler3EndBattleText
	text_end

OldCityTower4FChanneler3AfterBattleText:
	text_far _OldCityTower4FChanneler3AfterBattleText
	text_end
