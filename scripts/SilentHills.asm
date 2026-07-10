SilentHills_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SilentHillsTrainerHeaders
	ld de, SilentHills_ScriptPointers
	ld a, [wSilentHillsCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilentHillsCurScript], a
	ret

SilentHills_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILENTHILLS_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILENTHILLS_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILENTHILLS_END_BATTLE

SilentHills_TextPointers:
	def_text_pointers
	dw_const SilentHillsYoungster1Text,      TEXT_SILENTHILLS_YOUNGSTER1
	dw_const SilentHillsYoungster2Text,      TEXT_SILENTHILLS_YOUNGSTER2
	dw_const SilentHillsYoungster3Text,      TEXT_SILENTHILLS_YOUNGSTER3
	dw_const SilentHillsYoungster4Text,      TEXT_SILENTHILLS_YOUNGSTER4
	dw_const SilentHillsYoungster5Text,      TEXT_SILENTHILLS_YOUNGSTER5
	dw_const SilentHillsTrainerTips1Text,    TEXT_SILENTHILLS_TRAINER_TIPS1
	dw_const SilentHillsLeavingSignText,     TEXT_SILENTHILLS_LEAVING_SIGN

SilentHillsTrainerHeaders:
	def_trainers 2
SilentHillsTrainerHeader0:
	trainer EVENT_BEAT_SILENT_HILLS_TRAINER_0, 4, SilentHillsYoungster2BattleText, SilentHillsYoungster2EndBattleText, SilentHillsYoungster2AfterBattleText
SilentHillsTrainerHeader1:
	trainer EVENT_BEAT_SILENT_HILLS_TRAINER_1, 4, SilentHillsYoungster3BattleText, SilentHillsYoungster3EndBattleText, SilentHillsYoungster3AfterBattleText
SilentHillsTrainerHeader2:
	trainer EVENT_BEAT_SILENT_HILLS_TRAINER_2, 1, SilentHillsYoungster4BattleText, SilentHillsYoungster4EndBattleText, SilentHillsYoungster4AfterBattleText
	db -1 ; end

SilentHillsYoungster1Text:
	text_far _SilentHillsYoungster1Text
	text_end

SilentHillsYoungster2Text:
	text_asm
	ld hl, SilentHillsTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilentHillsYoungster3Text:
	text_asm
	ld hl, SilentHillsTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilentHillsYoungster4Text:
	text_asm
	ld hl, SilentHillsTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilentHillsYoungster2BattleText:
	text_far _SilentHillsYoungster2BattleText
	text_end

SilentHillsYoungster2EndBattleText:
	text_far _SilentHillsYoungster2EndBattleText
	text_end

SilentHillsYoungster2AfterBattleText:
	text_far _SilentHillsYoungster2AfterBattleText
	text_end

SilentHillsYoungster3BattleText:
	text_far _SilentHillsYoungster3BattleText
	text_end

SilentHillsYoungster3EndBattleText:
	text_far _SilentHillsYoungster3EndBattleText
	text_end

SilentHillsYoungster3AfterBattleText:
	text_far _SilentHillsYoungster3AfterBattleText
	text_end

SilentHillsYoungster4BattleText:
	text_far _SilentHillsYoungster4BattleText
	text_end

SilentHillsYoungster4EndBattleText:
	text_far _SilentHillsYoungster4EndBattleText
	text_end

SilentHillsYoungster4AfterBattleText:
	text_far _SilentHillsYoungster4AfterBattleText
	text_end

SilentHillsYoungster5Text:
	text_far _SilentHillsYoungster5Text
	text_end

SilentHillsTrainerTips1Text:
	text_far _SilentHillsTrainerTips1Text
	text_end

SilentHillsLeavingSignText:
	text_far _SilentHillsLeavingSignText
	text_end
