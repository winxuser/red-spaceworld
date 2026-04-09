BerryTreeScript::
; Display the "It's a fruit-bearing tree." text
	call EnableAutoTextBoxDrawing
	ld hl, FruitTreeText
	rst _PrintText

; Check to see if the player can get a berry from this tree right now
	ld a, [wCurBerryTree] ; Which tree is this?
	dec a
	ld c, a ; We need this in register c
	ld b, 2 ; We want to read this value to see if it's been taken or not
	ld hl, wBerryTreeFlags
	predef FlagActionPredef
	ld a, c ; Let's get the result of that check
	and a ; Make sure the flag isn't set
	jp nz, .NothingHereScript ; If it is, you got the berry, so the tree is empty

; Time to give the berry
	ld a, [wCurBerryTree]
	dec a
	ld c, a
	ld b, 0
	ld hl, BerryTable
	add hl, bc
	ld a, [hl]
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, .BagFull

; Mark the berry as taken
	ld a, [wCurBerryTree] ; Which tree is this?
	dec a
	ld c, a ; We need this in c
	ld b, 1 ; We want to set this tree's bit
	ld hl, wBerryTreeFlags
	predef FlagActionPredef

; Show "Found (Berry Name)!" text
	ld hl, FoundBerryText
	jr .print

; Runs if the berry has already been taken from this tree
.NothingHereScript
	ld hl, NoBerryText
	jr .print

; Runs when the bag is full
.BagFull
	ld hl, PackFullText
.print
	rst _PrintText
	ret

FruitTreeText:
	text "It's a fruit-"
	line "bearing tree."
	prompt
	text_end

NoBerryText:
	text "Looks like there's"
	line "nothing here."
	done
	text_end

FoundBerryText:
	text_far _FoundItemText
	sound_get_item_1
	text_end

PackFullText:
	text_far _NoMoreRoomForItemText
	text_end

; The table is not terminated, so don't use invalid tree numbers
BerryTable:
	db BERRY   ; Route 1
	db PSNCUREBERRY  ; Viridian Forest, Tree 1
	db ICE_BERRY  ; Pewter City, Tree 1
	db MINT_BERRY ; Pewter City, Tree 2
	db PRZCUREBERRY  ; Route 8
	db GOLD_BERRY   ; Route 11
	db BURNT_BERRY ; Fuchsia City
	db MYSTERYBERRY  ; Route 4, Tree 1
	db MIRACLEBERRY    ; Route 4, Tree 2
	db PSNCUREBERRY  ; Route 15
	db MYSTERYBERRY  ; Route 16
	db PSNCUREBERRY  ; Route 2, Tree 2
	db BERRY   ; Viridian Forest
	db GOLD_BERRY ; Route 7
	db BERRY   ; Faraway Island??
	db BERRY   ;

BerryReset::
; Called to reset berry trees
; Happens when the berry counter hits 0
	ld a, [wBerryStepCounter + 1]
	cp a, $4
	ret nz
	xor a
	ld hl, wBerryTreeFlags
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret
