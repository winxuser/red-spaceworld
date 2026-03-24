SoftReset_orig:: ; HAX: "SoftReset" label moved elsewhere (calls this after)
	call StopAllSounds
	call GBPalWhiteOut
	ld c, 32
	rst _DelayFrame
	; fallthrough

Init::
;  Program init.
	di

	xor a
	ldh [rIF], a
	ldh [rIE], a
	ldh [rSCX], a
	ldh [rSCY], a
	ldh [rSB], a
	ldh [rSC], a
	ldh [rWX], a
	ldh [rWY], a
	ldh [rTMA], a
	ldh [rTAC], a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a

	ld a, LCDC_ON
	ldh [rLCDC], a
	call DisableLCD

	ld sp, wStack

	ld hl, STARTOF(WRAM0)
	ld bc, SIZEOF(WRAM0)
.loop
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop

;;;;;;;;;;;;;;;;;;;; marcelnote - shinpokered xorshift RNG
;joenote - implement xorshift RNG
;Initialize the RNG state. It can be initialized to anything but zero; this is just a simple way of doing it.
;Initialize with whatever random garbage is in hram to get an initial seed.
	ld a, [hJoyLast]
	and a
	push af
	ld a, [hFrameCounter]
	and a
	push af
	ld a, [hDividend2]
	and a
	push af
	ld a, [hSpriteAnimFrameCounter]
	and a
	push af
;;;;;;;;;;;;;;;;;;;;

	call ClearVram

	ld hl, STARTOF(HRAM)
	ld bc, SIZEOF(HRAM)
	call FillMemory

	call ClearSprites

;;;;;;;;;;;;;;;;;;;; marcelnote - shinpokered xorshift RNG
;finish initializing RNG
;joenote - added lines to save the RNG seed
	ld hl, wRandomSeed ; $DEF0 in shinpokered
	pop af
	call z, .inc_a
	ld [hRandomAdd], a
	ld [hli], a
	pop af
	call z, .inc_a
	ld [hRandomSub], a
	ld [hli], a
	pop af
	call z, .inc_a
	ld [hRandomLast], a
	ld [hli], a
	pop af
	call z, .inc_a
	ld [hRandomLast + 1], a
	ld [hli], a
;;;;;;;;;;;;;;;;;;;;

	ld a, BANK(WriteDMACodeToHRAM)
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call WriteDMACodeToHRAM

	xor a
	ldh [hTileAnimations], a
	ldh [rSTAT], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [rIF], a
	ld a, IE_VBLANK | IE_TIMER | IE_SERIAL
	ldh [rIE], a

	ld a, 144 ; move the window off-screen
	ldh [hWY], a
	ldh [rWY], a
	ld a, 7
	ldh [rWX], a

	ld a, CONNECTION_NOT_ESTABLISHED
	ldh [hSerialConnectionStatus], a

	ld h, HIGH(vBGMap0)
	call ClearBgMap
	ld h, HIGH(vBGMap1)
	call ClearBgMap

	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	ld a, 16
	ldh [hSoftReset], a
	call StopAllSounds

	ei

	predef LoadSGB

;	ld a, 0 ; BANK(SFX_Shooting_Star)
;	ld [wAudioROMBank], a
;	ld [wAudioSavedROMBank], a
	ld a, HIGH(vBGMap1)
	ldh [hAutoBGTransferDest + 1], a
	xor a
	ldh [hAutoBGTransferDest], a
	dec a
	ld [wUpdateSpritesEnabled], a

	predef PlayIntro

	call DisableLCD
	call ClearVram
	call GBPalNormal
	call ClearSprites
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a

	jp PrepareTitleScreen

.inc_a ; marcelnote - shinpokered xorshift RNG
	inc a
	ret

ClearVram::
	ld hl, STARTOF(VRAM)
	ld bc, SIZEOF(VRAM)
	xor a
	jp FillMemory


StopAllSounds::
;	ld a, 0 ; BANK("Audio Engine 1")
;	ld [wAudioROMBank], a
;	ld [wAudioSavedROMBank], a
	xor a
	ld [wMusicFade], a
	ld [wMusicFadeID], a
	ld [wLastMusicSoundID], a
	dec a
	jp PlaySound
