OldCityMart_Script:
	call OldCityMartCheckParcelDeliveredScript
	call EnableAutoTextBoxDrawing
	ld hl, OldCityMart_ScriptPointers
	ld a, [wOldCityMartCurScript]
	jp CallFunctionInTable

OldCityMartCheckParcelDeliveredScript:
	CheckEvent EVENT_OAK_GOT_PARCEL
	jr nz, .delivered_parcel
	ld hl, OldCityMart_TextPointers
	jr .done
.delivered_parcel
	ld hl, OldCityMart_TextPointers2
.done
	ld a, l
	ld [wCurMapTextPtr], a
	ld a, h
	ld [wCurMapTextPtr+1], a
	ret

OldCityMart_ScriptPointers:
	def_script_pointers
	dw_const OldCityMartDefaultScript,    SCRIPT_OLDCITYMART_DEFAULT
	dw_const OldCityMartOaksParcelScript, SCRIPT_OLDCITYMART_OAKS_PARCEL
	dw_const OldCityMartNoopScript,       SCRIPT_OLDCITYMART_NOOP

OldCityMartDefaultScript:
	call UpdateSprites
	ld a, TEXT_OLDCITYMART_CLERK_YOU_CAME_FROM_SILENT_HILL
	ldh [hTextID], a
	call DisplayTextID
	ld hl, wSimulatedJoypadStatesEnd
	ld de, .PlayerMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_OLDCITYMART_OAKS_PARCEL
	ld [wOldCityMartCurScript], a
	ret

.PlayerMovement:
	db PAD_LEFT, 1
	db PAD_UP, 5
	db -1 ; end

OldCityMartOaksParcelScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, TEXT_OLDCITYMART_CLERK_PARCEL_QUEST
	ldh [hTextID], a
	call DisplayTextID
	lb bc, OAKS_PARCEL, 1
	call GiveItem
	SetEvent EVENT_GOT_OAKS_PARCEL
	ld a, SCRIPT_OLDCITYMART_NOOP
	ld [wOldCityMartCurScript], a
	; fallthrough
OldCityMartNoopScript:
	ret

OldCityMart_TextPointers:
	dw OldCityMartClerkSayHiToOakText
	dw OldCityMartYoungsterText
	dw OldCityMartCooltrainerMText
	const_def 4
	dw_const OldCityMartClerkYouCameFromSilentHillText, TEXT_OLDCITYMART_CLERK_YOU_CAME_FROM_SILENT_HILL
	dw_const OldCityMartClerkParcelQuestText,           TEXT_OLDCITYMART_CLERK_PARCEL_QUEST

OldCityMart_TextPointers2:
	; This becomes the primary text pointers table when Oak's parcel has been delivered.
	def_text_pointers
	dw_const OldCityMartClerkText,        TEXT_OLDCITYMART_CLERK
	dw_const OldCityMartYoungsterText,    TEXT_OLDCITYMART_YOUNGSTER
	dw_const OldCityMartCooltrainerMText, TEXT_OLDCITYMART_COOLTRAINER_M

OldCityMartClerkSayHiToOakText:
	text_far _OldCityMartClerkSayHiToOakText
	text_end

OldCityMartClerkYouCameFromSilentHillText:
	text_far _OldCityMartClerkYouCameFromSilentHillText
	text_end

OldCityMartClerkParcelQuestText:
	text_far _OldCityMartClerkParcelQuestText
	sound_get_key_item
	text_end

OldCityMartYoungsterText:
	text_far _OldCityMartYoungsterText
	text_end

OldCityMartCooltrainerMText:
	text_far _OldCityMartCooltrainerMText
	text_end

OldCityMartClerkText:
	script_mart POKE_BALL, POTION, ESCAPE_ROPE, ANTIDOTE, BURN_HEAL, AWAKENING, PARLYZ_HEAL

