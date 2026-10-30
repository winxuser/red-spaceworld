PrintNotebookText:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wHiddenEventFunctionArgument]
	jp PrintPredefTextID

TMNotebook::
	text_far TMNotebookText
	text_waitbutton
	text_end

OldCitySchoolNotebook::
	text_asm
	ld hl, OldCitySchoolNotebookText1
	rst _PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, OldCitySchoolNotebookText2
	rst _PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, OldCitySchoolNotebookText3
	rst _PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, OldCitySchoolNotebookText4
	rst _PrintText
	ld hl, OldCitySchoolNotebookText5
	rst _PrintText
.doneReading
	rst TextScriptEnd

TurnPageSchoolNotebook:
	ld hl, TurnPageText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

TurnPageText:
	text_far _TurnPageText
	text_end

OldCitySchoolNotebookText5:
	text_far _OldCitySchoolNotebookText5
	text_waitbutton
	text_end

OldCitySchoolNotebookText1:
	text_far _OldCitySchoolNotebookText1
	text_end

OldCitySchoolNotebookText2:
	text_far _OldCitySchoolNotebookText2
	text_end

OldCitySchoolNotebookText3:
	text_far _OldCitySchoolNotebookText3
	text_end

OldCitySchoolNotebookText4:
	text_far _OldCitySchoolNotebookText4
	text_end
