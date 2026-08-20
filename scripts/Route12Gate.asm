Route12Gate_Script:
	jp EnableAutoTextBoxDrawing

Route12Gate_TextPointers:
	def_text_pointers
	dw_const Route12GateGuardText, TEXT_ROUTE12GATE1F_GUARD

Route12GateGuardText:
	text_far _Route12GateGuardText
	text_end


GateUpstairsScript_PrintIfFacingUp:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, .up
	ld a, TRUE
	jr .done
.up
	call PrintText
	xor a
.done
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd
