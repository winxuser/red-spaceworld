Route9_Script:
	jp EnableAutoTextBoxDrawing

Route9_TextPointers:
	def_text_pointers
	dw_const PickUpItemText,          TEXT_ROUTE9_TM_TELEPORT
	dw_const Route9SignText,          TEXT_ROUTE9_SIGN


Route9SignText:
	text_far _Route9SignText
	text_end
