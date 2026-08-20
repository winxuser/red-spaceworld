MACRO outdoor_map
	dn \2, \1
	dw \3
ENDM

; the appearance of towns and routes in the town map
ExternalMapEntries:
	table_width 3
	; x, y, name
	outdoor_map 10, 12, SilentHillName
	outdoor_map  8, 10, OldCityName
	outdoor_map  5, 10, WestCityName
	outdoor_map 10,  2, BirdonName
	outdoor_map 14,  5, FontName
	outdoor_map 10,  9, SouthCityName
	outdoor_map  7,  5, HighTechName
	outdoor_map  8, 13, NewTypeName
	outdoor_map  2, 15, PrinceName
	outdoor_map  0,  2, KantoName
	outdoor_map 10,  5, StandName
	outdoor_map  0,  0, BlueForestName ; unused
	outdoor_map  0,  0, NorthCityName ; unused
	outdoor_map  0,  0, SugarName ; unused
	outdoor_map  0,  0, MtFujiName ; unused
	outdoor_map  9, 12, Route1Name
	outdoor_map  8, 11, Route1P2Name
	outdoor_map  8, 11, Route2Name
	outdoor_map  7, 10, Route3Name
	outdoor_map  5,  8, Route4Name
	outdoor_map 10,  3, Route5Name
	outdoor_map 10,  8, Route6Name
	outdoor_map  8,  5, Route7Name
	outdoor_map 13,  5, Route8Name
	outdoor_map 13,  2, Route9Name
	outdoor_map 14,  4, Route10Name
	outdoor_map 12,  9, Route11Name
	outdoor_map 14,  9, Route12Name
	outdoor_map 13, 11, Route13Name
	outdoor_map 11, 12, Route14Name
	outdoor_map 10, 13, Route15Name
	outdoor_map  5,  5, Route16Name
	outdoor_map  4,  8, Route17Name
	outdoor_map  6, 13, Route18Name
	outdoor_map  6, 15, Route19Name
	outdoor_map  4, 15, Route20Name
	outdoor_map  2, 13, Route21Name
	outdoor_map  0,  8, Route22Name
	outdoor_map  0,  6, Route23Name
	outdoor_map 10,  1, Route24Name
	outdoor_map 11,  0, Route25Name
	outdoor_map 11,  0, Route26Name
	outdoor_map 11,  0, Route29Name
	outdoor_map 11,  0, Route30Name
	assert_table_length FIRST_INDOOR_MAP


MACRO indoor_map
	db INDOORGROUP_\1
	dn \3, \2
	dw \4
ENDM

; the appearance of buildings and dungeons in the town map
InternalMapEntries:
	table_width 4
	; indoor map group, x, y, name
	indoor_map SILENT_HILL,        10, 12, SilentHillName
	indoor_map OLD_CITY,            2,  8, OldCityName
	indoor_map ROUTE_2,             8, 11, Route2Name
	indoor_map SILENT_HILLS,        8, 12, SilentHillsName
	indoor_map WEST_CITY,           2,  3, WestCityName
	indoor_map MT_MOON,             6,  2, MountMoonName
	indoor_map BIRDON,             10,  2, BirdonName
	indoor_map ROUTE_4,             5,  2, Route4Name
	indoor_map BIRDON_2,           10,  2, BirdonName
	indoor_map ROUTE_5,            10,  4, Route5Name
	indoor_map ROUTE_6,            10,  6, Route6Name
	indoor_map ROUTE_7,             9,  5, Route7Name
	indoor_map ROUTE_8,            11,  5, Route8Name
	indoor_map ROCK_TUNNEL,        14,  3, RockTunnelName
	indoor_map POWER_PLANT,        15,  4, PowerPlantName
	indoor_map ROUTE_11,           13,  9, Route11Name
;	indoor_map ROUTE_12,           14,  7, Route12Name
	indoor_map SEA_COTTAGE,        12,  0, SeaCottageName
	indoor_map SOUTH_CITY,         10,  9, SouthCityName
	indoor_map SS_ANNE,             9, 10, SSAnneName
	indoor_map VICTORY_ROAD,        0,  4, VictoryRoadName
	indoor_map POKEMON_LEAGUE,      0,  2, PokemonLeagueName
	indoor_map UNDERGROUND_PATH,   10,  5, UndergroundPathName
	indoor_map POKEMON_LEAGUE_2,    0,  2, PokemonLeagueName
	indoor_map UNDERGROUND_PATH_2, 10,  5, UndergroundPathName
	indoor_map HIGH_TECH,           7,  5, HighTechName
	indoor_map FONT,               14,  5, FontName
	indoor_map POKEMON_TOWER,      15,  5, PokemonTowerName
	indoor_map FONT_2,             14,  5, FontName
	indoor_map NEW_TYPE,            8, 13, NewTypeName
	indoor_map SAFARI_ZONE,         8, 12, SafariZoneName
	indoor_map NEW_TYPE_2,          8, 13, NewTypeName
	indoor_map SEAFOAM_ISLANDS,     5, 15, SeafoamIslandsName
	indoor_map SOUTH_CITY_2,       10,  9, SouthCityName
	indoor_map NEW_TYPE_3,          8, 13, NewTypeName
	indoor_map POKEMON_MANSION,     2, 15, PokemonMansionName
	indoor_map PRINCE,              2, 15, PrinceName
	indoor_map INDIGO_PLATEAU,      0,  2, KantoName
	indoor_map STAND,              10,  5, StandName
	indoor_map ROUTE_15,            9, 13, Route15Name
	indoor_map ROUTE_16,            4,  5, Route16Name
	indoor_map ROUTE_12_2,         14, 10, Route12Name
	indoor_map ROUTE_18,            7, 13, Route18Name
	indoor_map SEAFOAM_ISLANDS_2,   5, 15, SeafoamIslandsName
	indoor_map ROUTE_22,            0,  7, Route22Name
	indoor_map VICTORY_ROAD_2,      0,  4, VictoryRoadName
;	indoor_map ROUTE_12_3,         14,  7, Route12Name
	indoor_map SOUTH_CITY_3,       10,  9, SouthCityName
	indoor_map DIGLETTS_CAVE,       3,  4, DiglettsCaveName
	indoor_map VICTORY_ROAD_3,      0,  4, VictoryRoadName
	indoor_map ROCKET_HQ,           7,  5, RocketHQName
	indoor_map SILPH_CO,           10,  5, SilphCoName
	indoor_map POKEMON_MANSION_2,   2, 15, PokemonMansionName
	indoor_map SAFARI_ZONE_2,       8, 12, SafariZoneName
	indoor_map CERULEAN_CAVE,       9,  1, CeruleanCaveName
	indoor_map FONT_3,             14,  5, FontName
	indoor_map BIRDON_3,           10,  2, BirdonName
	indoor_map ROCK_TUNNEL_2,      14,  3, RockTunnelName
	indoor_map SILPH_CO_2,         10,  5, SilphCoName
	indoor_map POKEMON_LEAGUE_3,    0,  2, PokemonLeagueName
	assert_table_length NUM_INDOOR_MAP_GROUPS
	db -1 ; end
