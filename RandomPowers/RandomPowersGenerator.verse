using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/FortPlayerUtilities }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Game }
using { /Verse.org/Assets }
# please ignore what i name variables and params, thank you
verse_powers_base := class(creative_device):
    var PowerTypes : []string = array{
        "test",
        "anothertest"
    }

    OnBegin<override>()<suspends>:void=
        Print("Hello, world!")
        GiveOutPowers()

    GiveOutPowers(): void =
        AllPlayers := GetPlayspace().GetPlayers()

        for(Player : AllPlayers){
            NewListPowers := Shuffle(PowerTypes)
            SelectedPowerIndex := GetRandomInt(0, NewListPowers.Length-1)
            if(PowerType := NewListPowers[SelectedPowerIndex]){
                case(PowerType):
                    "test" => TestFunction(Player)
                    "anothertest: => AnotherTestFunction(Player)
                    _ => Print("Couldn't Find Power")
            }

        }
            
    TestFunction(Player : player):void=
        Print("Player Got Test Power!")
        # do something here
    AnotherTestFunction(Player : player):void=
          Print("Player Got Another Test Power!")
        # do something here
