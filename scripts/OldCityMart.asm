OldCityMart_Script:
	jp EnableAutoTextBoxDrawing

OldCityMart_TextPointers:
	def_text_pointers
	dw_const OldCityMartClerkText,        TEXT_OLDCITYMART_CLERK
	dw_const OldCityMartYoungsterText,    TEXT_OLDCITYMART_YOUNGSTER
	dw_const OldCityMartCooltrainerMText, TEXT_OLDCITYMART_COOLTRAINER_M

OldCityMartYoungsterText:
	text_far _OldCityMartYoungsterText
	text_end

OldCityMartCooltrainerMText:
	text_far _OldCityMartCooltrainerMText
	text_end


OldCityMartClerkText:
	script_mart POKE_BALL, ANTIDOTE, PARLYZ_HEAL, BURN_HEAL

