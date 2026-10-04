SECTION "rst0", ROM0[$0000]
_CopyData::
	jp CopyData

SECTION "rst8", ROM0[$0008]
_PlaySound::
	jp PlaySound

SECTION "rst10", ROM0[$0010]

; HAX: rst18 can be used for "Bankswitch"
SECTION "rst18", ROM0[$0018]
_Bankswitch::
	jp Bankswitch

SECTION "rst20", ROM0[$0020]
_DelayFrames::
	jp DelayFrames

SECTION "rst28", ROM0[$0028]
_PrintText::
	jp PrintText

SECTION "rst30", ROM0[$0030]
_Predef::
	jp Predef

SECTION "rst38", ROM0[$0038]
TextScriptEnd::
        pop hl ; turn the rst call into a jp by popping off the return address
TextScriptEndNoPop::
        ld hl, TextScriptEndingText
DoRet::
        ret

TextScriptEndingText:: ; moved from home/overworld_text.asm
    	text_end

; Game Boy hardware interrupts

SECTION "vblank", ROM0[$0040]
	push hl
	ld hl, VBlank
	jp InterruptWrapper

SECTION "lcd", ROM0[$0048] ; HAX: interrupt wasn't used in original game
	push hl
	ld hl, _GbcPrepareVBlank
	jp InterruptWrapper

SECTION "timer", ROM0[$0050]
	push hl
	ld hl, Timer
	jp InterruptWrapper

SECTION "serial", ROM0[$0058]
	push hl
	ld hl, Serial
	jp InterruptWrapper

SECTION "joypad", ROM0[$0060]
	reti


SECTION "Header", ROM0[$0100]

Start::
jp InitializeColor

; The Game Boy cartridge header data is patched over by rgbfix.
; This makes sure it doesn't get used for anything else.

	ds $0150 - @

ENDSECTION
