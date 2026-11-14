; party menu icons
; used in MonPartySpritePointers (see data/icon_pointers.asm)
	const_def
	const ICON_MON         ; $0
	const ICON_BALL        ; $1
	const ICON_HELIX       ; $2
	const ICON_FAIRY       ; $3
	const ICON_BIRD        ; $4
	const ICON_WATER       ; $5
	const ICON_BUG         ; $6
	const ICON_GRASS       ; $7
	const ICON_SNAKE       ; $8
	const ICON_QUADRUPED   ; $9
	const_skip 4
	const ICON_TRADEBUBBLE ; $e

DEF ICONOFFSET EQU $40 ; difference between alternating icon frames' tile IDs

; Custom species-specific party icons
; 0 = original Gen 1 icons
; 1 = enable custom icons
DEF USE_CUSTOM_PARTY_ICONS EQU 1

; Each party member uses four tiles per animation frame.
DEF CUSTOM_PARTY_ICON_TILES_PER_MON EQU 4

; First frame starts at sprite tile $00.
DEF CUSTOM_PARTY_ICON_BASE_TILE EQU $00

; Second frame is 64 tiles after the first.
DEF CUSTOM_PARTY_ICON_FRAME_OFFSET EQU ICONOFFSET
