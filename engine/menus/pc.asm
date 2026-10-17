ActivatePC::
	call SaveScreenTilesToBuffer2
	ld a, SFX_TURN_ON_PC
	rst _PlaySound
	ld hl, TurnedOnPC1Text
	rst _PrintText
	call WaitForSoundToFinish
	ld hl, wMiscFlags
	set BIT_USING_GENERIC_PC, [hl]
	call LoadScreenTilesFromBuffer2
	call Delay3

PCMainMenu:
	farcall DisplayPCMainMenu
	ld hl, wMiscFlags
	set BIT_NO_MENU_BUTTON_SOUND, [hl]
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, LogOff

	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMaxMenuItem]
	cp b
	jr z, LogOff ; If selecting the last option (Log Off), exit PC

	ld a, b
	add a
	ld c, a
	ld b, 0
	ld hl, .PCMenuJumptable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.PCMenuJumptable:
	dw BillsPC
	dw PlayersPC
	dw OaksPC
	dw PKMNLeague

EnterPC:
	ld a, SFX_ENTER_PC
	rst _PlaySound
	jp WaitForSoundToFinish

PlayersPC:
	ld hl, wMiscFlags
	res BIT_NO_MENU_BUTTON_SOUND, [hl]
	set BIT_USING_GENERIC_PC, [hl]
	call EnterPC
	ld hl, AccessedMyPCText
	rst _PrintText
	farcall PlayerPC
	jr ReloadMainMenu

OaksPC:
	call EnterPC
	farcall OpenOaksPC
	jr ReloadMainMenu

PKMNLeague:
	call EnterPC
	farcall PKMNLeaguePC
	jr ReloadMainMenu

BillsPC:
	call EnterPC
	CheckEvent EVENT_MET_BILL
	ld hl, AccessedBillsPCText
	jr nz, .printText
	ld hl, AccessedSomeonesPCText

.printText
	rst _PrintText
	farcall BillsPC_

ReloadMainMenu:
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call ReloadMapData
	call UpdateSprites
	jp PCMainMenu

LogOff:
	ld a, SFX_TURN_OFF_PC
	rst _PlaySound
	call WaitForSoundToFinish
	ld hl, wMiscFlags
	res BIT_USING_GENERIC_PC, [hl]
	res BIT_NO_MENU_BUTTON_SOUND, [hl]
	ret

TurnedOnPC1Text:
	text_far _TurnedOnPC1Text
	text_end

AccessedBillsPCText:
	text_far _AccessedBillsPCText
	text_end

AccessedSomeonesPCText:
	text_far _AccessedSomeonesPCText
	text_end

AccessedMyPCText:
	text_far _AccessedMyPCText
	text_end

; Removes one of the specified item ID [hItemToRemoveID] from bag (if existent)
RemoveItemByID::
	ld hl, wBagItems
	ldh a, [hItemToRemoveID]
	ld b, a
	xor a
	ldh [hItemToRemoveIndex], a

.loop
	ld a, [hli]
	cp -1 ; Reached terminator?
	ret z
	cp b
	jr z, .foundItem
	inc hl
	ldh a, [hItemToRemoveIndex]
	inc a
	ldh [hItemToRemoveIndex], a
	jr .loop

.foundItem
	ld a, 1
	ld [wItemQuantity], a
	ldh a, [hItemToRemoveIndex]
	ld [wWhichPokemon], a
	ld hl, wNumBagItems
	jp RemoveItemFromInventory
