PrepareForSpecialWarp::
	call LoadSpecialWarpData
	predef LoadTilesetHeader
	ld hl, wStatusFlags6
	bit BIT_FLY_OR_DUNGEON_WARP, [hl]
	res BIT_FLY_OR_DUNGEON_WARP, [hl]
	jr z, .debugNewGameWarp
	ld a, [wDestinationMap]
	jr .next
.debugNewGameWarp
	bit BIT_DEBUG_MODE, [hl]
	jr z, .setNewGameMatWarp ; apply to StartNewGameDebug only
	call PrepareNewGameDebug
.setNewGameMatWarp
	; This is called by OakSpeech during StartNewGame and
	; loads the first warp event for the specified map index.
	ld a, SILENT_HILL
.next
	ld b, a
	ld a, [wStatusFlags3]
	and a ; ???
	jr nz, .next2
	ld a, b
.next2
	ld hl, wStatusFlags6
	bit BIT_DUNGEON_WARP, [hl]
	ret nz
	ld [wLastMap], a
	ret

LoadSpecialWarpData:
	ld a, [wCableClubDestinationMap]
	cp TRADE_CENTER
	jr nz, .notTradeCenter
	ld hl, TradeCenterPlayerWarp
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .copyClubWarpData
	ld hl, TradeCenterFriendWarp
	jr .copyClubWarpData
.notTradeCenter
	cp COLOSSEUM
	jr nz, .notColosseum
	ld hl, ColosseumPlayerWarp
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .copyClubWarpData
	ld hl, ColosseumFriendWarp
	jr .copyClubWarpData
.notColosseum
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	; warp to wLastMap (PALLET_TOWN) for StartNewGameDebug
	jr nz, .notNewGameWarp
	bit BIT_FLY_OR_DUNGEON_WARP, a
	jr nz, .notNewGameWarp
	ld hl, NewGameWarp
	jr .copyWarpData
.copyClubWarpData
	; Both Cable Club rooms belong to the same group.
	ASSERT GROUP_TRADE_CENTER == GROUP_COLOSSEUM
	ld a, GROUP_TRADE_CENTER
	ld [wCurMapGroup], a
.copyWarpData
	ld de, wCurMap
	ld c, $7
.copyWarpDataLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyWarpDataLoop
	ld a, [hli]
	ld [wCurMapTileset], a
	xor a
	jp .done
.notNewGameWarp
	ld a, [wLastMap] ; this value is overwritten before it's ever read
	ld hl, wStatusFlags6
	bit BIT_DUNGEON_WARP, [hl]
	jr nz, .usedDungeonWarp
	bit BIT_ESCAPE_WARP, [hl]
	res BIT_ESCAPE_WARP, [hl]
	jr z, .otherDestination
	; Restore the saved blackout destination group.
	ld a, [wLastBlackoutMapGroup]
	ld [wCurMapGroup], a

	ld a, [wLastBlackoutMap]
	jr .usedFlyWarp
.usedDungeonWarp
	ld hl, wStatusFlags3
	res BIT_ON_DUNGEON_WARP, [hl]
	ld a, [wDungeonWarpDestinationMap]
	ld b, a
	ld a, [wWhichDungeonWarp]
	ld c, a

	; Select the dungeon list for the destination region.
	ld a, [wDestinationMapGroup]
	cp MAPGROUP_REGION_2
	jr z, .region2DungeonList

	ld hl, DungeonWarpList
	jr .gotDungeonList

.region2DungeonList
	ld hl, Region2DungeonWarpList

.gotDungeonList
	ld de, 0
	ld a, 6
	ld [wDungeonWarpDataEntrySize], a
.dungeonWarpListLoop
	ld a, [hli]
	cp $ff
	jr z, .invalidDungeonWarp
	cp b
	jr z, .matchedDungeonWarpDestinationMap
	inc hl
	jr .nextDungeonWarp
.matchedDungeonWarpDestinationMap
	ld a, [hli]
	cp c
	jr z, .matchedDungeonWarpID
.nextDungeonWarp
	ld a, [wDungeonWarpDataEntrySize]
	add e
	ld e, a
	jr .dungeonWarpListLoop
.matchedDungeonWarpID
	; The destination exists, so apply its map ID.
	ld a, b
	ld [wCurMap], a

	; Apply the destination region.
	ld a, [wDestinationMapGroup]
	ld [wCurMapGroup], a

	; Choose coordinates from the matching region's table.
	cp MAPGROUP_REGION_2
	jr z, .region2DungeonData

	ld hl, DungeonWarpData
	jr .gotDungeonData

.region2DungeonData
	ld hl, Region2DungeonWarpData
.gotDungeonData
	add hl, de
	jr .copyWarpData2
.invalidDungeonWarp
	; Invalid dungeon destination.
	; Recover at Silent Hill rather than reading past
	; the dungeon warp tables.
	ld a, MAPGROUP_NIHON
	ld [wCurMapGroup], a

	ld a, SILENT_HILL
	ld [wCurMap], a

	ld hl, FlyWarpDataPtr.SilentHill
	jp .copyWarpData2
.otherDestination
	; Select the region requested by Fly.
	ld a, [wDestinationMapGroup]
	ld [wCurMapGroup], a

	ld a, [wDestinationMap]

.usedFlyWarp
	; Keep the destination map ID in B.
	ld b, a

	; Select the regional Fly destination table.
	ld a, [wCurMapGroup]
	cp MAPGROUP_REGION_2
	jr z, .region2FlyTable

	ld hl, FlyWarpDataPtr
	jr .gotFlyTable
.region2FlyTable
	ld hl, Region2FlyWarpDataPtr

.gotFlyTable
.flyWarpDataPtrLoop
	ld a, [hli]
	cp $ff
	jr z, .invalidFlyWarp

	cp b
	jr z, .foundFlyWarpMatch

	; Skip the unused byte and two-byte pointer.
	inc hl
	inc hl
	inc hl
	jr .flyWarpDataPtrLoop
.invalidFlyWarp
	; Temporary recovery destination for an invalid
	; regional Fly lookup.
	ld a, MAPGROUP_NIHON
	ld [wCurMapGroup], a

	ld a, SILENT_HILL
	ld [wCurMap], a

	ld hl, FlyWarpDataPtr.SilentHill
	jp .copyWarpData2
.foundFlyWarpMatch
	; The destination exists, so commit its map ID.
	ld a, b
	ld [wCurMap], a

	; HL points to the unused byte.
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
.copyWarpData2
	ld de, wCurrentTileBlockMapViewPointer
	ld c, $6
.copyWarpDataLoop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyWarpDataLoop2
	xor a ; OVERWORLD
	ld [wCurMapTileset], a
.done
	ld [wYOffsetSinceLastSpecialWarp], a
	ld [wXOffsetSinceLastSpecialWarp], a
	ld a, -1 ; exclude normal warps
	ld [wDestinationWarpID], a
	ret

INCLUDE "data/maps/special_warps.asm"
