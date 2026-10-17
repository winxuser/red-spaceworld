BankswitchHome::
; switches to bank # in a
; Only use this when in the home bank!
	ld [wBankswitchHomeTemp], a
	ldh a, [hLoadedROMBank]
	ld [wBankswitchHomeSavedROMBank], a
	ld a, [wBankswitchHomeTemp]
	jp SetRomBank

BankswitchBack::
; returns from BankswitchHome
	ld a, [wBankswitchHomeSavedROMBank]
	jp SetRomBank

Bankswitch::
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	call SetRomBank
	ld bc, .Return
	push bc
	jp hl
.Return
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

_LoadMapVramAndColors:
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(LoadMapVramAndColors)
	call SetRomBank
	call LoadMapVramAndColors
	pop af
	jp SetRomBank

SetRomBank::
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret
