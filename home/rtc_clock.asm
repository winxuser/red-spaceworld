UpdateSoftwareRTC::
	push af

	; 1. Increment sub-frames (0 to 59)
	ld a, [wRTCSubFrames]
	inc a
	ld [wRTCSubFrames], a
	cp 60                  ; 60 VBlanks = 1 real second
	jr nz, .done
	xor a
	ld [wRTCSubFrames], a

	; 2. Increment real-second counter (0 to 4)
	ld a, [wRTCFrames]     ; Reusing wRTCFrames as our 5-second counter
	inc a
	ld [wRTCFrames], a
	cp 5                   ; 5 real seconds passed!
	jr nz, .done
	xor a
	ld [wRTCFrames], a

	; 3. Increment 1 in-game minute
	ld a, [wRTCMinutes]
	inc a
	ld [wRTCMinutes], a
	cp 60
	jr nz, .done
	xor a
	ld [wRTCMinutes], a

	; 4. Increment 1 in-game hour
	ld a, [wRTCHours]
	inc a
	cp 24
	jr c, .hour_set
	xor a                  ; Rollover 24 -> 0

.hour_set
	ld [wRTCHours], a

.done
	pop af
	ret
