PrintRedSNESText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump RedBedroomSNESText

RedBedroomSNESText::
	text_far _RedBedroomSNESText
	text_end

OpenRedsPC:
	call EnableAutoTextBoxDrawing
	tx_pre_jump RedBedroomPCText

RedBedroomPCText::
	script_players_pc

PrintRedRadioText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump RedBedroomRadioText

RedBedroomRadioText::
	text_far _RedBedroomRadioText
	text_end
