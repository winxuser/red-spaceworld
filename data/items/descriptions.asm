; Item descriptions for the PACK menu.
; Item IDs follow constants/item_constants.asm.

ItemDescriptions::
    dw MasterBallDescription ; $01
    dw UltraBallDescription  ; $02
    dw GreatBallDescription  ; $03
    dw PokeBallDescription   ; $04
    dw TownMapDescription    ; $05
    dw BicycleDescription       ; $06
    dw SurfboardDescription     ; $07
    dw SafariBallDescription    ; $08
    dw PokedexDescription       ; $09
    dw MoonStoneDescription     ; $0A
    dw AntidoteDescription      ; $0B
    dw BurnHealDescription      ; $0C
    dw IceHealDescription       ; $0D
    dw AwakeningDescription     ; $0E
    dw ParlyzHealDescription    ; $0F
    dw FullRestoreDescription   ; $10
    dw MaxPotionDescription     ; $11
    dw HyperPotionDescription   ; $12
    dw SuperPotionDescription   ; $13
    dw PotionDescription        ; $14
    dw BoulderBadgeDescription  ; $15
    dw CascadeBadgeDescription  ; $16
    dw ThunderBadgeDescription  ; $17
    dw RainbowBadgeDescription  ; $18
    dw SoulBadgeDescription     ; $19
    dw MarshBadgeDescription    ; $1A
    dw VolcanoBadgeDescription  ; $1B
    dw EarthBadgeDescription    ; $1C
    dw EscapeRopeDescription    ; $1D
    dw RepelDescription         ; $1E
    dw OldAmberDescription      ; $1F
    dw FireStoneDescription     ; $20
    dw ThunderStoneDescription  ; $21
    dw WaterStoneDescription    ; $22
    dw HPUpDescription          ; $23
    dw ProteinDescription       ; $24
    dw IronDescription          ; $25
    dw CarbosDescription        ; $26
    dw CalciumDescription       ; $27
    dw RareCandyDescription     ; $28
    dw DomeFossilDescription    ; $29
    dw HelixFossilDescription   ; $2A
    dw SecretKeyDescription     ; $2B
    dw SkateboardDescription    ; $2C
    dw BikeVoucherDescription   ; $2D
    dw XAccuracyDescription     ; $2E
    dw LeafStoneDescription     ; $2F
    dw CardKeyDescription       ; $30
    dw NuggetDescription        ; $31
    dw Item32Description        ; $32
    dw PokeDollDescription      ; $33
    dw FullHealDescription      ; $34
    dw ReviveDescription        ; $35
    dw MaxReviveDescription     ; $36
    dw GuardSpecDescription     ; $37
    dw SuperRepelDescription    ; $38
    dw MaxRepelDescription      ; $39
    dw DireHitDescription       ; $3A
    dw CoinDescription          ; $3B
    dw FreshWaterDescription    ; $3C
    dw SodaPopDescription       ; $3D
    dw LemonadeDescription      ; $3E
    dw SSTicketDescription      ; $3F
    dw GoldTeethDescription     ; $40
    dw XAttackDescription       ; $41
    dw XDefendDescription       ; $42
    dw XSpeedDescription        ; $43
    dw XSpecialDescription      ; $44
    dw CoinCaseDescription      ; $45
    dw OaksParcelDescription    ; $46
    dw ItemfinderDescription    ; $47
    dw SilphScopeDescription    ; $48
    dw PokeFluteDescription     ; $49
    dw LiftKeyDescription       ; $4A
    dw ExpAllDescription        ; $4B
    dw OldRodDescription        ; $4C
    dw GoodRodDescription       ; $4D
    dw SuperRodDescription      ; $4E
    dw PPUpDescription          ; $4F
    dw EtherDescription         ; $50
    dw MaxEtherDescription      ; $51
    dw ElixerDescription        ; $52
    dw MaxElixerDescription     ; $53

ItemDescriptionsEnd::
    ASSERT ItemDescriptionsEnd - ItemDescriptions == MAX_ELIXER * 2

MasterBallDescription:
    db "Never fails to"
    next "catch a POKéMON.@"

UltraBallDescription:
    db "A powerful BALL"
    next "for catching MON.@"

GreatBallDescription:
    db "A good BALL for"
    next "catching POKéMON.@"

PokeBallDescription:
    db "A BALL used to"
    next "catch wild MON.@"

TownMapDescription:
    db "Shows a map of"
    next "the region.@"

BicycleDescription:
    db "A bike that lets"
    next "you travel faster.@"

SurfboardDescription:
    db "A board for riding"
    next "across water.@"

SafariBallDescription:
    db "A special BALL"
    next "for SAFARI ZONE.@"

PokedexDescription:
    db "Records data on"
    next "POKéMON you find.@"

MoonStoneDescription:
    db "A stone that"
    next "evolves POKéMON.@"

AntidoteDescription:
    db "Cures poisoning"
    next "in one POKéMON.@"

BurnHealDescription:
    db "Heals a burned"
    next "POKéMON.@"

IceHealDescription:
    db "Thaws a frozen"
    next "POKéMON.@"

AwakeningDescription:
    db "Wakes a sleeping"
    next "POKéMON.@"

ParlyzHealDescription:
    db "Cures paralysis"
    next "in one POKéMON.@"

FullRestoreDescription:
    db "Restores all HP"
    next "and heals status.@"

MaxPotionDescription:
    db "Fully restores"
    next "one POKéMON's HP.@"

HyperPotionDescription:
    db "Restores 200 HP"
    next "to one POKéMON.@"

SuperPotionDescription:
    db "Restores 50 HP"
    next "to one POKéMON.@"

PotionDescription:
    db "Restores 20 HP"
    next "to one POKéMON.@"

BoulderBadgeDescription:
    db "A BADGE awarded"
    next "by PEWTER GYM.@"

CascadeBadgeDescription:
    db "A BADGE awarded"
    next "by CERULEAN GYM.@"

ThunderBadgeDescription:
    db "A BADGE awarded"
    next "by VERMILION GYM.@"

RainbowBadgeDescription:
    db "A BADGE awarded"
    next "by CELADON GYM.@"

SoulBadgeDescription:
    db "A BADGE awarded"
    next "by FUCHSIA GYM.@"

MarshBadgeDescription:
    db "A BADGE awarded"
    next "by SAFFRON GYM.@"

VolcanoBadgeDescription:
    db "A BADGE awarded"
    next "by CINNABAR GYM.@"

EarthBadgeDescription:
    db "A BADGE awarded"
    next "by VIRIDIAN GYM.@"

EscapeRopeDescription:
    db "Escape instantly"
    next "from a dungeon.@"

RepelDescription:
    db "Repels weak MON"
    next "for 100 steps.@"

OldAmberDescription:
    db "Ancient amber"
    next "holding MON DNA.@"

FireStoneDescription:
    db "A special stone"
    next "that evolves MON.@"

ThunderStoneDescription:
    db "An electric stone"
    next "that evolves MON.@"

WaterStoneDescription:
    db "A water stone"
    next "that evolves MON.@"

HPUpDescription:
    db "Raises a MON's"
    next "HP stat.@"

ProteinDescription:
    db "Raises a MON's"
    next "ATTACK stat.@"

IronDescription:
    db "Raises a MON's"
    next "DEFENSE stat.@"

CarbosDescription:
    db "Raises a MON's"
    next "SPEED stat.@"

CalciumDescription:
    db "Raises a MON's"
    next "SPECIAL stat.@"

RareCandyDescription:
    db "Raises a MON's"
    next "level by one.@"

DomeFossilDescription:
    db "A fossil holding"
    next "ancient MON DNA.@"

HelixFossilDescription:
    db "An ancient fossil"
    next "of a sea POKéMON.@"

SecretKeyDescription:
    db "Opens the door to"
    next "CINNABAR GYM.@"

SkateboardDescription:
    db "A board for riding"
    next "around quickly.@"

BikeVoucherDescription:
    db "Trade this for a"
    next "BICYCLE.@"

XAccuracyDescription:
    db "Raises accuracy"
    next "during battle.@"

LeafStoneDescription:
    db "A special stone"
    next "that evolves MON.@"

CardKeyDescription:
    db "Opens locked doors"
    next "in SILPH CO.@"

NuggetDescription:
    db "A golden nugget."
    next "Sells for a lot.@"

Item32Description:
    db "No description"
    next "available.@"

PokeDollDescription:
    db "Helps you escape"
    next "from a wild MON.@"

FullHealDescription:
    db "Heals all status"
    next "conditions.@"

ReviveDescription:
    db "Revives a fainted"
    next "MON with half HP.@"

MaxReviveDescription:
    db "Revives a fainted"
    next "MON to full HP.@"

GuardSpecDescription:
    db "Stops stat drops"
    next "during battle.@"

SuperRepelDescription:
    db "Repels weak MON"
    next "for 200 steps.@"

MaxRepelDescription:
    db "Repels weak MON"
    next "for 250 steps.@"

DireHitDescription:
    db "Raises critical"
    next "hit chance.@"

CoinDescription:
    db "A coin used at"
    next "the GAME CORNER.@"

FreshWaterDescription:
    db "Restores 50 HP"
    next "to one POKéMON.@"

SodaPopDescription:
    db "Restores 60 HP"
    next "to one POKéMON.@"

LemonadeDescription:
    db "Restores 80 HP"
    next "to one POKéMON.@"

SSTicketDescription:
    db "A ticket for the"
    next "S.S. ANNE ship.@"

GoldTeethDescription:
    db "Lost teeth from"
    next "the SAFARI ZONE.@"

XAttackDescription:
    db "Raises ATTACK in"
    next "one battle.@"

XDefendDescription:
    db "Raises DEFENSE in"
    next "one battle.@"

XSpeedDescription:
    db "Raises SPEED in"
    next "one battle.@"

XSpecialDescription:
    db "Raises SPECIAL in"
    next "one battle.@"

CoinCaseDescription:
    db "Holds GAME CORNER"
    next "coins you collect.@"

OaksParcelDescription:
    db "A parcel for"
    next "PROF. OAK.@"

ItemfinderDescription:
    db "Finds hidden items"
    next "nearby.@"

SilphScopeDescription:
    db "Reveals invisible"
    next "ghost POKéMON.@"

PokeFluteDescription:
    db "Plays a tune that"
    next "wakes up POKéMON.@"

LiftKeyDescription:
    db "Opens the lift at"
    next "ROCKET HIDEOUT.@"

ExpAllDescription:
    db "Shares battle EXP"
    next "with your party.@"

OldRodDescription:
    db "An old rod used"
    next "for fishing.@"

GoodRodDescription:
    db "A good rod used"
    next "for fishing.@"

SuperRodDescription:
    db "The best rod for"
    next "catching fish MON.@"

PPUpDescription:
    db "Raises maximum PP"
    next "of a move.@"

EtherDescription:
    db "Restores 10 PP"
    next "to one move.@"

MaxEtherDescription:
    db "Fully restores PP"
    next "to one move.@"

ElixerDescription:
    db "Restores 10 PP"
    next "to all moves.@"

MaxElixerDescription:
    db "Fully restores PP"
    next "to all moves.@"

UnknownItemDescription:
    db "No description"
    next "available.@"
