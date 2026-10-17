VBlank::
	push af
	push bc
	push de
	push hl

	ldh a, [hLoadedROMBank]
	ld [wVBlankSavedROMBank], a

	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a

	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, .ok
	ldh a, [hWY]
	ldh [rWY], a
.ok

	call AutoBgMapTransfer
	call VBlankCopyBgMap
	call RedrawRowOrColumn
	call VBlankCopy
	call VBlankCopyDouble

	ldh a, [hSkipOAMUpdates]
	bit 0, a
	jr nz, .skipOAM
	call hDMARoutine
	ld a, BANK(GbcVBlankHook)
	call SetRomBank
	call GbcVBlankHook
.skipOAM

	; VBlank-sensitive operations end.
	call Random

	ldh a, [hVBlankOccurred]
	and a
	jr z, .skipZeroing
	xor a
	ldh [hVBlankOccurred], a
.skipZeroing

	ldh a, [hFrameCounter]
	and a
	jr z, .skipDec
	dec a
	ldh [hFrameCounter], a
.skipDec

	call UpdateSound

	farcall TrackPlayTime
	call UpdateSoftwareRTC

	ldh a, [hDisableJoypadPolling]
	and a
	call z, ReadJoypad

	; Restore saved ROM bank using existing SetRomBank helper
	ld a, [wVBlankSavedROMBank]
	call SetRomBank

	pop hl
	pop de
	pop bc
	pop af
	ret


DelayFrame::
; Wait for the next vblank interrupt.
	call DelayFrameHook
.halt
	halt
	ldh a, [hVBlankOccurred]
	and a
	jr nz, .halt
	ret
