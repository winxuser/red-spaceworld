UpdateSoftwareRTC::
    push af             ; Save register A and flags

    ld a, [wRTCFrames]
    inc a
    cp 60               ; 60 frames = 1 second
    ld [wRTCFrames], a
    jr nz, .done        ; If not 60 yet, we are done

    xor a
    ld [wRTCFrames], a  ; Reset frames

    ; Increment Seconds
    ld a, [wRTCSeconds]
    inc a
    cp 60
    ld [wRTCSeconds], a
    jr nz, .done

    xor a
    ld [wRTCSeconds], a

    ; Increment Minutes
    ld a, [wRTCMinutes]
    inc a
    cp 60
    ld [wRTCMinutes], a
    jr nz, .done

    xor a
    ld [wRTCMinutes], a

    ; Increment Hours
    ld a, [wRTCHours]
    inc a
    cp 24
    ld [wRTCHours], a
    jr nz, .done

    xor a
    ld [wRTCHours], a

    ; Increment Days
    ld a, [wRTCDays]
    inc a
    ld [wRTCDays], a

.done
    pop af              ; Restore register A and flags
    ret
