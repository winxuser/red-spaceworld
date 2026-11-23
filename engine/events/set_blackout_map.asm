SetLastBlackoutMap:
; Set the map to return to when
; blacking out or using Teleport or Dig.
; Safari rest houses don't count.

	push hl

	; Safari Zone rest houses belong to Nihon.
	; Region 2 maps must not match their map IDs.
	ld a, [wCurMapGroup]
	cp MAPGROUP_NIHON
	jr nz, .notresthouse

	ld hl, SafariZoneRestHouses
	ld a, [wCurMap]
	ld b, a
.loop
	ld a, [hli]
	cp -1
	jr z, .notresthouse
	cp b
	jr nz, .loop
	jr .done

.notresthouse
	; Save the outdoor map's group.
	ld a, [wLastMapGroup]
	ld [wLastBlackoutMapGroup], a
	; Save the outdoor map number.
	ld a, [wLastMap]
	ld [wLastBlackoutMap], a
.done
	pop hl
	ret

INCLUDE "data/maps/rest_house_maps.asm"
