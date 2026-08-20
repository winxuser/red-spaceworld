Route17_Script:
	jp EnableAutoTextBoxDrawing

Route17_TextPointers:
	def_text_pointers
	dw_const Route17NoticeSign1Text,         TEXT_ROUTE17_NOTICE_SIGN1
	dw_const Route17TrainerTips1Text,        TEXT_ROUTE17_TRAINER_TIPS1
	dw_const Route17TrainerTips2Text,        TEXT_ROUTE17_TRAINER_TIPS2
	dw_const Route17SignText,                TEXT_ROUTE17_SIGN
	dw_const Route17NoticeSign2Text,         TEXT_ROUTE17_NOTICE_SIGN2
	dw_const Route17CyclingRoadEndsSignText, TEXT_ROUTE17_CYCLING_ROAD_ENDS_SIGN


Route17NoticeSign1Text:
	text_far _Route17NoticeSign1Text
	text_end

Route17TrainerTips1Text:
	text_far _Route17TrainerTips1Text
	text_end

Route17TrainerTips2Text:
	text_far _Route17TrainerTips2Text
	text_end

Route17SignText:
	text_far _Route17SignText
	text_end

Route17NoticeSign2Text:
	text_far _Route17NoticeSign2Text
	text_end

Route17CyclingRoadEndsSignText:
	text_far _Route17CyclingRoadEndsSignText
	text_end
