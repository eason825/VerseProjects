
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }

# Created By Eason
#create a class for the HUD UI, Unique to the player

CurrencyDisplayHud := class<unique>():

    #The player that will be effected
    Player : player

    #the amount of your currency the player has (Default set as zero, can be changed to any number)
    var CurrencyAmount : int = 0

    #the text that shows on the players ui, EX: "FortBucks Amount : 100"
    var CurrencyText : string = ""


    #converts any string, into a message type
    StringToMessage<localizes>(InText : string) : message = "{InText}"
    
    #text block defenition, Text color, shadow color as well as offset
    CurrencyScoreTextBlock<public> : text_block = text_block{
        DefaultTextColor := NamedColors.Black, 
        DefaultShadowColor := NamedColors.White, 
        DefaultShadowOffset := option{
                vector2{
                    X:=3.0, Y:=3.0
                }
            }
        }

    #Initialize the class, TextContent parameter tells us via the editable, what text we want to say on the ui
    Init(
        TextContent : string
    ):void=

        # sets our variable for Currency Text into what the TextContent param is.
        set CurrencyText = TextContent

        # sets the text block defined above to have a string converted to message of our default text value + our players currency amount
        CurrencyScoreTextBlock.SetText(StringToMessage(TextContent + "{CurrencyAmount}"))

        #sets the opacity of the shadow to 1.0, it is not 1.0 at default.
        CurrencyScoreTextBlock.SetShadowOpacity(1.0)
        
    #a function to create a canvas
    CreateHudCanvas() : canvas =

        UICanvas : canvas = canvas{
            Slots := array{
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 800.0, Left := 50.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := CurrencyScoreTextBlock
                }
            }
        }
            
        # returns the UICanvas to where the CreateHudCanvas function was ran
        return UICanvas

    #function to show ui to player, Requires the PlayerToShow parameter with the player type
    ShowUIPerPlayer(PlayerToShow : player):void=
        
        #fetches and saves PlayerUI Definition as the players ui using the GetPlayerUI function using the PlayerToShow param we created earlier.
        if (PlayerUI := GetPlayerUI[PlayerToShow]):
            #Adds the widget returned from the function CreateHudCanvas to the PlayerUI Defenition
            PlayerUI.AddWidget(CreateHudCanvas())

    # create a new funciton called IncreaseCurrency which requires the amount param in the integer format (int)
    IncreaseCurrency(Amount : int):void=
        # sets the CurrencyAmount variable to add and save the Integer in the Amount param.
        set CurrencyAmount += Amount
        #Updates the currency text block we previosly created using the SetText function
        CurrencyScoreTextBlock.SetText(StringToMessage("{CurrencyText} {CurrencyAmount}"))

#create our custom currency device class
CustomCurrency := class(creative_device):

    #editables, theese can be edited in the editor by the settings of the device
    #The text that will show in front of the Number of your currency the player has.
    @editable CurrencyHudText : string = "💸 FortBucks Amount: "

    #Trigger That increases a players amount by one 
    @editable IncreaseByOneTrigger : trigger_device = trigger_device{}
    #Trigger That increases a players amount by ten 
    @editable IncreaseByTenTrigger : trigger_device = trigger_device{}
    #Trigger That increases a players amount by hundred 
    @editable IncreaseByHundredTrigger : trigger_device = trigger_device{}

    #Trigger That decreases a players amount by one 
    @editable DecreaseByOne : trigger_device = trigger_device{}

    #Trigger That decreases a players amount by ten 
    @editable DecreaseByTen : trigger_device = trigger_device{}

    #Trigger That decreases a players amount by hundred 
    @editable DecreaseByHundred : trigger_device = trigger_device{}
    

    # Create an agent map variable to store the current huds of the player.
    var PlayerHuds : [agent]CurrencyDisplayHud = map{}

    #on begin function, is triggered automatically when the device is activated
    OnBegin<override>()<suspends>:void=

        #subscribe to the events where the triggers are triggered to handle functions
        IncreaseByOneTrigger.TriggeredEvent.Subscribe(HandleIncreaseScoreOne)
        IncreaseByTenTrigger.TriggeredEvent.Subscribe(HandleIncreaseScoreTen)
        IncreaseByHundredTrigger.TriggeredEvent.Subscribe(HandleIncreaseScoreHundred)

        DecreaseByOne.TriggeredEvent.Subscribe(HandleDecreaseScoreOne)
        DecreaseByTen.TriggeredEvent.Subscribe(HandleDecreaseScoreTen)
        DecreaseByHundred.TriggeredEvent.Subscribe(HandleDecreaseScoreHundred)

        #get all players in playspace
        AllPlayers := GetPlayspace().GetPlayers()
        
        # for loop to go through every player in AllPlayers
        for(Player : AllPlayers){
            #Use the class we created for custom huds per player. Remember to put the Player parameter or it will not work.
            UIForPlayer := CurrencyDisplayHud{Player:=Player}
            #Initialize the class for the player
            UIForPlayer.Init(CurrencyHudText)
            #show the ui to the player using the ShowUIPerPlayer function
            UIForPlayer.ShowUIPerPlayer(Player)
            # save the class for the player into the agent map we created earlier called PlayerHuds
            if(set PlayerHuds[Player] = UIForPlayer){}
        }
        #subscribe to the OnPlayerAdded function when player joins the game
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerAdded)

      OnPlayerAdded(Agent : agent): void =

        #fetch the agent from the fort character, fetch the player from the agent
        if(FortChar := Agent.GetFortCharacter[], Player := player[Agent]):
            #Give the player their ui
            UIHudPlayer := CurrencyDisplayHud{Player:= Player}
            #Initialize the class
            UIHudPlayer.Init(CurrencyHudText)

            #save the class to the agent map
            if(set PlayerHuds[Player] = UIHudPlayer){
                UIHudPlayer.ShowUIForPlayer(Player)
            }


    #Handle when the score is increased by one, since triggers can be triggered by anything not just players, We have to make agent an option.
    HandleIncreaseScoreOne(MaybeAgent : ?agent): void =
        
        Print("Score Increasing By One!") # prints that the trigger was triggered
        #if the MaybeAgent param has the agent then..
        if(Agent := MaybeAgent?){
            #fetches the players hud class from the agent map
            if(AgentsHud := PlayerHuds[Agent]){
                #Run the increase currency function on the players individual class, it will have the parameter for any integer ( you can change this to how much you wanna increase by)
                AgentsHud.IncreaseCurrency(1)
            }
        }

    HandleIncreaseScoreTen(MaybeAgent : ?agent): void =
        Print("Score Increasing By Ten!")
        if(Agent := MaybeAgent?){
            if(AgentsHud := PlayerHuds[Agent]){
                AgentsHud.IncreaseCurrency(10)
            }
        }

    HandleIncreaseScoreHundred(MaybeAgent : ?agent): void =
        Print("Score Increasing By Hundred!")
        if(Agent := MaybeAgent?){
            if(AgentsHud := PlayerHuds[Agent]){
                AgentsHud.IncreaseCurrency(100)
            }
        }

    HandleDecreaseScoreOne(MaybeAgent : ?agent): void =
        Print("Score Decreasing By One!")
        if(Agent := MaybeAgent?){
            if(AgentsHud := PlayerHuds[Agent]){
                AgentsHud.IncreaseCurrency(-1)
            }
        }

    HandleDecreaseScoreTen(MaybeAgent : ?agent): void =
        Print("Score Decreasing By Ten!")
        if(Agent := MaybeAgent?){
            if(AgentsHud := PlayerHuds[Agent]){
                AgentsHud.IncreaseCurrency(-10)
            }
        }

    HandleDecreaseScoreHundred(MaybeAgent : ?agent): void =
        Print("Score Decreasing By Hundred!")
        if(Agent := MaybeAgent?){
            if(AgentsHud := PlayerHuds[Agent]){
                AgentsHud.IncreaseCurrency(-100)
            }
        }
    



