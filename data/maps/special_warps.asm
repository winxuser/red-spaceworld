; Format: (size 2 bytes)
; 00: target map ID
; 01: which dungeon warp in the source map was used
DungeonWarpList:
	db SEAFOAM_ISLANDS_B1F, 1
	db SEAFOAM_ISLANDS_B1F, 2
	db SEAFOAM_ISLANDS_B2F, 1
	db SEAFOAM_ISLANDS_B2F, 2
	db SEAFOAM_ISLANDS_B3F, 1
	db SEAFOAM_ISLANDS_B3F, 2
	db SEAFOAM_ISLANDS_B4F, 1
	db SEAFOAM_ISLANDS_B4F, 2
	db VICTORY_ROAD_2F,     2
	db POKEMON_MANSION_1F,  1
	db POKEMON_MANSION_1F,  2
	db POKEMON_MANSION_2F,  3
	db -1 ; end


MACRO fly_warp
	event_displacement \1_WIDTH, \2, \3
	db ((\3) & $01) ;sub-block Y
	db ((\2) & $01) ;sub-block X
ENDM

DungeonWarpData:
	fly_warp SEAFOAM_ISLANDS_B1F, 18,  7
	fly_warp SEAFOAM_ISLANDS_B1F, 23,  7
	fly_warp SEAFOAM_ISLANDS_B2F, 19,  7
	fly_warp SEAFOAM_ISLANDS_B2F, 22,  7
	fly_warp SEAFOAM_ISLANDS_B3F, 18,  7
	fly_warp SEAFOAM_ISLANDS_B3F, 19,  7
	fly_warp SEAFOAM_ISLANDS_B4F,  4, 14
	fly_warp SEAFOAM_ISLANDS_B4F,  5, 14
	fly_warp VICTORY_ROAD_2F,     22, 16
	fly_warp POKEMON_MANSION_1F,  16, 14
	fly_warp POKEMON_MANSION_1F,  16, 14
	fly_warp POKEMON_MANSION_2F,  18, 14


MACRO special_warp_spec
	db \1
	fly_warp \1, \2, \3
	db \4
ENDM

NewGameWarp:
	special_warp_spec REDS_HOUSE_2F, 3, 6, REDS_HOUSE_2
TradeCenterPlayerWarp:
	special_warp_spec TRADE_CENTER,  3, 4, CLUB
TradeCenterFriendWarp:
	special_warp_spec TRADE_CENTER,  6, 4, CLUB
ColosseumPlayerWarp:
	special_warp_spec COLOSSEUM,     3, 4, CLUB
ColosseumFriendWarp:
	special_warp_spec COLOSSEUM,     6, 4, CLUB


MACRO fly_warp_spec
	db \1, 0
	dw \2
ENDM

FlyWarpDataPtr:
	fly_warp_spec SILENT_HILL,     .SilentHill
	fly_warp_spec OLD_CITY,        .OldCity
	fly_warp_spec WEST_CITY,       .WestCity
	fly_warp_spec BIRDON,          .Birdon
	fly_warp_spec FONT,            .Font
	fly_warp_spec SOUTH_CITY,      .SouthCity
	fly_warp_spec HIGH_TECH,       .HighTech
	fly_warp_spec NEW_TYPE,        .NewType
	fly_warp_spec PRINCE,          .Prince
	fly_warp_spec KANTO,           .Kanto
	fly_warp_spec STAND,           .Stand
	fly_warp_spec BLUE_FOREST,     .BlueForest
	fly_warp_spec NORTH_CITY,      .NorthCity
	fly_warp_spec ROUTE_4,         .Route4
	fly_warp_spec ROUTE_10,        .Route10

.SilentHill:     fly_warp SILENT_HILL,      5,  5
.OldCity:        fly_warp OLD_CITY,        27, 29
.WestCity:       fly_warp WEST_CITY,       24, 15
.Birdon:         fly_warp BIRDON,          19, 18
.Font:           fly_warp FONT,             3,  6
.SouthCity:      fly_warp SOUTH_CITY,      11,  4
.HighTech:       fly_warp HIGH_TECH,       41, 10
.NewType:        fly_warp NEW_TYPE,        19, 28
.Prince:         fly_warp PRINCE,          11, 12
.Kanto:          fly_warp KANTO,            9,  6
.Stand:          fly_warp STAND,            9, 30
.BlueForest:     fly_warp BLUE_FOREST,      5,  5
.NorthCity:      fly_warp NORTH_CITY,       5,  5
.Route4:         fly_warp ROUTE_4,         11,  6
.Route10:        fly_warp ROUTE_10,        11, 20
