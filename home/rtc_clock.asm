UpdateSoftwareRTC::
	push af

	ld a, [wRTCSubFrames]
	inc a
	ld [wRTCSubFrames], a
	cp 60                  ; 60 VBlanks = 1 real second
	jr nz, .done
	xor a
	ld [wRTCSubFrames], a

	ld a, [wRTCFrames]     ; Reusing wRTCFrames as our 5-second counter
	inc a
	ld [wRTCFrames], a
	cp 5                   ; 5 real seconds passed!
	jr nz, .done
	xor a
	ld [wRTCFrames], a

	ld a, [wRTCMinutes]
	inc a
	ld [wRTCMinutes], a
	cp 60
	jr nz, .done
	xor a
	ld [wRTCMinutes], a

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
