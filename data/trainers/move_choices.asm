DEF __move_choices__ = 0

MACRO move_choices
	IF _NARG
		db \# ; all args
	ENDC
	db 0 ; end
	DEF __move_choices__ += 1
ENDM

; move choice modification methods that are applied for each trainer class
; Gen 2-style Trainer AI
;
; Layer 1 - Avoid redundant status ailments
; Layer 2 - Encourage useful move effects
; Layer 3 - Consider type effectiveness
; Layer 4 - Recovery and high-critical-hit moves
; Layer 5 - Avoid stat moves at their limits
; Layer 6 - Smart Status and Defensive Move AI
; Layer 7 - Attack Strength Awareness
;
; Basic trainers:       1, 5
; Intermediate:         1, 3, 5
; Advanced:             1, 2, 3, 5
; Expert / major:       1, 2, 3, 4, 5

TrainerClassMoveChoiceModifications:
	move_choices 1, 5, 6          ; YOUNGSTER
	move_choices 1, 5, 6          ; BUG CATCHER
	move_choices 1, 5, 6          ; LASS
	move_choices 1, 3, 5, 6       ; SAILOR
	move_choices 1, 3, 5, 6       ; JR_TRAINER_M
	move_choices 1, 3, 5, 6       ; JR_TRAINER_F
	move_choices 1, 2, 3, 5, 6, 7    ; POKEMANIAC
	move_choices 1, 2, 3, 5, 6, 7    ; SUPER_NERD
	move_choices 1, 3, 5, 6       ; HIKER
	move_choices 1, 3, 5, 6       ; BIKER
	move_choices 1, 3, 5, 6       ; BURGLAR
	move_choices 1, 3, 5, 6       ; ENGINEER
	move_choices 1, 2, 3, 5, 6    ; UNUSED_JUGGLER
	move_choices 1, 3, 5, 6       ; FISHER
	move_choices 1, 3, 5, 6       ; SWIMMER
	move_choices 1, 5, 6          ; CUE_BALL
	move_choices 1, 3, 5, 6       ; GAMBLER
	move_choices 1, 3, 5, 6       ; BEAUTY
	move_choices 1, 2, 3, 5, 6, 7    ; PSYCHIC_TR
	move_choices 1, 3, 5, 6       ; ROCKER
	move_choices 1, 2, 3, 5, 6    ; JUGGLER
	move_choices 1, 3, 5, 6       ; TAMER
	move_choices 1, 3, 5, 6       ; BIRD_KEEPER
	move_choices 1, 2, 3, 5, 6, 7    ; BLACKBELT

	; Rivals and special trainers
	move_choices 1, 3, 5, 6       ; RIVAL1
	move_choices 1, 2, 3, 4, 5, 6, 7 ; PROF_OAK
	move_choices 1, 2, 3, 5, 6    ; CHIEF
	move_choices 1, 2, 3, 5, 6    ; SCIENTIST
	move_choices 1, 2, 3, 4, 5, 6, 7 ; GIOVANNI
	move_choices 1, 3, 5, 6       ; ROCKET

	; Experienced trainers
	move_choices 1, 2, 3, 4, 5, 6, 7 ; COOLTRAINER_M
	move_choices 1, 2, 3, 4, 5, 6, 7 ; COOLTRAINER_F

	; Gym Leaders and Elite Four
	move_choices 1, 2, 3, 4, 5, 6, 7 ; BRUNO
	move_choices 1, 3, 4, 5, 6, 7    ; BROCK
	move_choices 1, 2, 3, 4, 5, 6, 7 ; MISTY
	move_choices 1, 2, 3, 4, 5, 6, 7 ; LT_SURGE
	move_choices 1, 2, 3, 4, 5, 6, 7 ; ERIKA
	move_choices 1, 2, 3, 4, 5, 6, 7 ; KOGA
	move_choices 1, 2, 3, 4, 5, 6, 7 ; BLAINE
	move_choices 1, 2, 3, 4, 5, 6, 7 ; SABRINA

	; Other trainers and rival battles
	move_choices 1, 2, 3, 5, 6    ; GENTLEMAN
	move_choices 1, 2, 3, 4, 5, 6, 7 ; RIVAL2
	move_choices 1, 2, 3, 4, 5, 6, 7 ; RIVAL3
	move_choices 1, 2, 3, 4, 5, 6, 7 ; LORELEI
	move_choices 1, 2, 3, 5, 6    ; CHANNELER
	move_choices 1, 2, 3, 4, 5, 6, 7 ; AGATHA
	move_choices 1, 2, 3, 4, 5, 6, 7 ; LANCE

	assert __move_choices__ == NUM_TRAINERS, \
			"TrainerClassMoveChoiceModifications: expected {d:NUM_TRAINERS} entries, got {d:__move_choices__}"

