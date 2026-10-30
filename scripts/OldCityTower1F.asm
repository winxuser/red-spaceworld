OldCityTower1F_Script:
	jp EnableAutoTextBoxDrawing

OldCityTower1F_TextPointers:
	def_text_pointers
	dw_const OldCityTower1FReceptionistText,    TEXT_OLDCITYTOWER1F_RECEPTIONIST

OldCityTower1FReceptionistText:
	text_far _OldCityTower1FReceptionistText
	text_end


