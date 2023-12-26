
#Credits Appreciated :D
# Made By Eason :) 

#Join my discord sever for any questions discord.gg/rJJqJrJ24b
#I apologize if this code is messy and my variables are named weridly!, I tried my best :D

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Assets }
using { /Fortnite.com/Game }

#Create Class for individual player ui (not necessary but I prefer having my ui individual to each player)
ui_voting_class := class<unique>():

    Player : player
    #This will tell the class which player "owns it"

    #Convert's Text to message localized, I suggest only using this for values that change overtime or numbers! Anything that is constant should not use this.
    TextToMessage<localizes>(InText : string) : message = "{InText}"
    #This is the message for the buttons, VOTE | 1...
    VoteTextLocalized<localizes>(Amount : int) : message = "VOTE | {Amount}"

    #variable where we store the players canvas inside this class
    var UIPlayer : canvas = canvas{}
    
    #Init, When it is initialized some values get changed to the value of what the param's are, EX: Image1 will set the IMAGE_1 image on the players ui to image 1 
    Init(
        Image1 : texture,
        Image2 : texture,
        Image3 : texture,
        HUDText : string,
        DefaultTime : int
    ):void=


        #Sets the buttons to the default value of 0
        BUTTON_VOTE_1.SetText(VoteTextLocalized(0))
        BUTTON_VOTE_2.SetText(VoteTextLocalized(0))
        BUTTON_VOTE_3.SetText(VoteTextLocalized(0))

        
        #Sets the images to the ones passed through the param
        IMAGE_1.SetImage(Image1)
        IMAGE_2.SetImage(Image2)
        IMAGE_3.SetImage(Image3)
        
        #Sets the timer to start on the DefaultTime
        TIME.SetText(TextToMessage("{DefaultTime}s"))
            
        #Sets the description shown on the top of the hud to the value in the editable passed through param
        VoteFor.SetText(TextToMessage("{HUDText}"))
        
        #Shows this message while testing, doesnt show in public games
        Print("Initialized")

    #here we are creating text_blocks which will be shown to the player 
    BOX_1_NAME<public> : text_block = text_block{DefaultTextColor := NamedColors.White}
    BOX_2_NAME<public> : text_block = text_block{DefaultTextColor := NamedColors.White}
    BOX_3_NAME<public> : text_block = text_block{DefaultTextColor := NamedColors.White}

    #Timer text
    TIME<public> : text_block = text_block{DefaultTextColor := NamedColors.White}
    #This is the text that is shown above timer
    VoteFor<public> : text_block = text_block{DefaultTextColor := NamedColors.White}

    #BUTTONS for each option:)
    BUTTON_VOTE_1<public> : button_loud = button_loud{}
    BUTTON_VOTE_2<public> : button_loud = button_loud{}
    BUTTON_VOTE_3<public> : button_loud = button_loud{}

    #Images for each option :D
    IMAGE_1<public> : texture_block = texture_block{DefaultImage:=TexturesUI.placeholder1920, DefaultDesiredSize:=vector2{X:=500.0, Y:= 281.0}}
    IMAGE_2<public> : texture_block = texture_block{DefaultImage:=TexturesUI.placeholder1920, DefaultDesiredSize:=vector2{X:=500.0, Y:= 281.0}}
    IMAGE_3<public> : texture_block = texture_block{DefaultImage:=TexturesUI.placeholder1920, DefaultDesiredSize:=vector2{X:=500.0, Y:= 281.0}}

    #This function will create a canvas for the player
    CreateUIPlayer() : canvas =
        #Define the canvas
        UICanvas : canvas = canvas{
            #array of slots
            Slots := array{
                #Time

                #Background With Opacity 0.4
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := -400.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=500.0, Y:=100.0}}
                }
                #Text displaying the topic, what the player is voting for
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := -420.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := VoteFor
                }
                #Time, displays the time remaining
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := -390.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := TIME
                }
                #First Option
                #Background (Behind image, can only be seen with a transparent image)
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := -550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=500.0, Y:=281.0}}
                }
                #Border Outline 
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 50.0, Left := -550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=520.0, Y:=400.0}}
                }
                #Image
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := -550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := IMAGE_1
                }
                #Name
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 125.0, Left := -550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := BOX_1_NAME
                }
                #little bar where the button is
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 190.0, Left := -550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=500.0, Y:=100.0}}
                }
                #BUTTON!
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 200.0, Left := -550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := BUTTON_VOTE_1
                }
                #Second Option
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=500.0, Y:=281.0}}
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 50.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=520.0, Y:=400.0}}
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top :=0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := IMAGE_2
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 125.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := BOX_2_NAME
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 190.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=500.0, Y:=100.0}}
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 200.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := BUTTON_VOTE_2
                }
                #third option
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=500.0, Y:=281.0}}
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 50.0, Left := 550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=520.0, Y:=400.0}}
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := IMAGE_3
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 125.0, Left := 550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := BOX_3_NAME
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 190.0, Left := 550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := color_block{DefaultColor := NamedColors.Black, DefaultOpacity := 0.4, DefaultDesiredSize:=vector2{X:=500.0, Y:=100.0}}
                }
                canvas_slot{
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 200.0, Left := 550.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}

                    Widget := BUTTON_VOTE_3
                } 
            }
        }

        #returns the canvas to whatever triggered it, sort of like when someone tells you something and you give them a reply :)
        return UICanvas

    #This function shows ui for the player
    ShowUIForPlayer(PlayerAgemt : player):void=
        #Gets the player ui from the Player
        if (PlayerUI := GetPlayerUI[PlayerAgemt]):
            #remember that variable we defined earlier? This sets that variable to what we are creating using the CreateUIPlayer function
            set UIPlayer = CreateUIPlayer()
            #Adds the widget to the players screen, and makes it clickable with input mode all
            PlayerUI.AddWidget(UIPlayer, player_ui_slot{InputMode := ui_input_mode.All})

    #this function hides ui for the player
    HideUIForPlayer(PlayerAgemt : player):void=
        #get the player ui
        if (PlayerUI := GetPlayerUI[PlayerAgemt]):
            #remember how we stored it earlier? Here we will get that variable and remove what was in that variable from the players ui
            PlayerUI.RemoveWidget(UIPlayer)

    
#- this structure is what we will have in each element in the array            
ChoiceStructure := struct<concrete>{
    @editable Name : string = "Name" #name is the default name
    @editable Trigger : trigger_device = trigger_device{} #trigger, Well a trigger that is triggered when Name is the winner
}

#this will be used further down in the code, This compiles the name, trigger as well as the image.
DataStructureChoice := struct{
    Name:string
    Trigger: trigger_device
    Image : texture
}

#Creates the creative device :)
voting_system := class(creative_device){
    #IMAGES!! This is very important, The order does matter. 
    #Make sure to seperate each item with a comma, You dont need a comma for the last one
    #In my project i had TexturesUI as a folder with textures like agency, durrr, mega, tacos. You will change theese to the ones you have
    
    var Images : []texture = array{
        TexturesUI.agency,
        TexturesUI.durrr,
        TexturesUI.mega,
        TexturesUI.tacos,
        TexturesUI.placeholder1920
    }
    #Timer Default time is 30, can be adjusted in the editable
    @editable TimeToWait : int = 30
    #Time current is the progress of the timer
    var TimeCurrent : int = 0
    #Prompt text is the text above the choices
    @editable PromptText : string = "Cast Your Vote For Minigame"
    #converts a string to message, shouldnt be used unless necessary
    TextToMessage<localizes>(InText : string) : message = "{InText}"

    #Player map which stores the classes
    var PlayerHudClasses : [player]ui_voting_class = map{}

    
    
    #this array will have name, triger, image so that the device can understand which go with which (We wouldnt need this if epic gave us editable textures :( )
    var ChoicesImagesCompiled : []DataStructureChoice = array{}

    #Editable that allows you to put Name and the device you are using (I still wish they allowed us to make editable textures :DDD )
    @editable Choices : []ChoiceStructure = array{}

    #stores the vote counts for option 1, 2, 3 | I may refer to them as indexes 0,1,2
    var votes_option_1 : int = 0
    var votes_option_2 : int = 0
    var votes_option_3 : int = 0

    #Ran when the game starts
    OnBegin<override>()<suspends>:void=
        #Sets the time to the time we have in our editable
        set TimeCurrent = TimeToWait

        #I LOVE FOR LOOPS! 
        # Index will be how far into the array we are, for example index 0 will be our first value, index 1 will be our second, etc
        # Then we will get the length of our choices (since they can be infinite) and subtract one, since indexes are always one below we have to subtract one
        for (IndexC := 0..Choices.Length-1){
            #If you are wondering why im using a If statement here, its because in order to get an index from a array we need to first check if it exists inside the array. 
            #IF it does exist then we continue!
            if(Category := Choices[IndexC]){
                #this sets the variable we made above ChoicesImagesCompiled to add our structure with the name, triger and image. We keep our name and trigger from the category but we take our image from the images array
                if(set ChoicesImagesCompiled += array{DataStructureChoice{Name:=Category.Name, Trigger:=Category.Trigger, Image:=Images[IndexC]}}){}
            }
            
        }
        #Shuffle the list of Choices and images compiled, Basically randomizing everything. The more values you have the easier it is
        ShuffledList := Shuffle(ChoicesImagesCompiled)

        #Gets the first, second, third indexes of the new shuffled list
        if(ShuffledFirst := ShuffledList[0], ShuffledSecond := ShuffledList[1], ShuffledThird := ShuffledList[2]){
            #Gets all players in the game
            AllPlayers := GetPlayspace().GetPlayers()

            #For loop on the players
            for(Player: AllPlayers){
    
                #Create class for the player
                UIHudPlayer := ui_voting_class{Player:=Player}
                #Initialize 
                UIHudPlayer.Init(
                    Image1 := ShuffledFirst.Image,
                    Image2 := ShuffledSecond.Image,
                    Image3 := ShuffledThird.Image,
                    HUDText := PromptText,
                    DefaultTime := TimeToWait
                )
                #this wont show in published games, its only for debug purposes
                Print(ShuffledFirst.Name)
                Print(ShuffledSecond.Name)
                Print(ShuffledThird.Name)
    
                #Sets our player map to have our classes stored
                if(set PlayerHudClasses[Player] = UIHudPlayer){

                    #Show our very cool ui to the player
                    UIHudPlayer.ShowUIForPlayer(Player)

                    #make it so when the player clicks button, it does some cool stuff
                    UIHudPlayer.BUTTON_VOTE_1.OnClick().Subscribe(AddVote1)
                    UIHudPlayer.BUTTON_VOTE_2.OnClick().Subscribe(AddVote2)
                    UIHudPlayer.BUTTON_VOTE_3.OnClick().Subscribe(AddVote3)
                }
            }
            #LOOOOOOOOOOOOOOOOOOOOOOOOOP 
            loop{
                # subtracts one every second that goes by (This loop might take longer than a second sometimes)
                set TimeCurrent -= 1

                #If the timer is over and the time is 0 or below then
                if(TimeCurrent <= 0){
                    #Default largest number, using 0 example
                    var LargestNumber : int = 0
                    #array of the vote counts in order
                    Numbers : []int = array{
                        votes_option_1,
                        votes_option_2,
                        votes_option_3
                    }
                    #array of the options (includes image, name, trigger)
                    Options : []DataStructureChoice = array{
                        ShuffledFirst,
                        ShuffledSecond,
                        ShuffledThird
                    }
                    #for loop on all the counts
                    for(Number : Numbers){
                        #Checks if our number is bigger than the largest number
                        if (Number > LargestNumber){
                            #if the number is bigger than the largest number, we will set our largest number to this number
                            set LargestNumber = Number
        
                        }
                    }
                    #for Index 0..2 (remember 0 = 1, 1 = 2, 2 = 3)
                    #this will go through 1..3 options
                    for(I := 0..2){
                        #if the number in the index is equal to the largest number
                        if(Numbers[I] = LargestNumber){
                            #then we know that hey, this index on the numbers is the largest, that means this index in the options will also be
                            if(Trigger := Options[I].Trigger, Name := Options[I].Name){
                                #gets the name and trigger
                                #triggers the trigger
                                #for(Players : GetPlayspace().GetPlayers()){
                                Trigger.Trigger()
                                #}
                                
                                #hides ui for player
                                for(Player : AllPlayers){
                                    if(UIClass := PlayerHudClasses[Player]){
                                        UIClass.HideUIForPlayer(Player)
                                    }
                                }
                                #since we want it to choose the first largest number we return (essentiely ending everything from this point)
                                return
                            }
        
                        }
                    }
                }
                #sets the time to update
                for(Player: AllPlayers){
                    if(UIClass := PlayerHudClasses[Player]){
                        UIClass.TIME.SetText(TextToMessage("{TimeCurrent}s"))
                    }
                }
                #waits one second
                Sleep(1.0)
            }
        }

        
    #Again, Vote text will be localized with amount as the amount of votes per option
    VoteTextLocalized<localizes>(Amount : int) : message = "VOTE | {Amount}"
        

    #MAP OF CHOICES! Basically stores what the player chooses, this way if they decide to change their decision the code will know where to remove the previos vote from
    #This map stores integers (Which will be our indexes)
    var PlayerChoices : [player]int = map{}


    #Function to add and remove vote, Requires the player parameter and the new choice parameter (ChoiceNew will be the index)
    AddAndRemoveVote(Player : player, ChoiceNew : int): void = 

        #Checks if Player is inside the PlayerChoices map, if true then PlayersChoiceOld will be the value of it
        if(PlayersChoiceOld := PlayerChoices[Player]){
            #If the choice isnt the same, then... (remove from the original vote)
            if (PlayersChoiceOld <> ChoiceNew){
                case(PlayersChoiceOld){
                    0 => set votes_option_1 -= 1 # Removes the vote from the previos Choice, if its either 0,1,2 they all do different things by setting the variable to subtract 1
                    1 => set votes_option_2 -= 1
                    2 => set votes_option_3 -= 1
                    _ => Print("Couldn't Find Option")
                }
                
            }
            #if the choice is the same then...
            else{
                #basically ends the function
                return
            }
        }
        #checks if ChoiceNew matches, 0,1,2 (our indexes) 
        case(ChoiceNew){
            0 => set votes_option_1 += 1 #if index 0, +1 to option 1
            1 => set votes_option_2 += 1 #if index 2, +1 to option 2
            2 => set votes_option_3 += 1 #if index 3, +1 to option 3
            _ => Print("Couldn't Find Option") #This shouldnt be triggered ever, but in the event that it exceeds 0,1,2 and gives 3 for example. It will give us this message
        }

        if(ChoiceNew = 0){ #if the new choice is the first option
            if(set PlayerChoices[Player] = 0){}
            #sets the players vote to be in choice 1
        }
        if(ChoiceNew = 1){ #if the new choice is the second option
            if(set PlayerChoices[Player] = 1){}
            #sets the players vote to be in choice 2
        }
        if(ChoiceNew = 2){ #if the new choice is the third option
            if(set PlayerChoices[Player] = 2){}
            #sets the players vote to be in choice 3
        }

    #function to update everyones ui
    UpdateUIForAllPlayers(): void = 
        #Get all players
        AllPlayers := GetPlayspace().GetPlayers()
        #for player inside allplayers
        for(Player: AllPlayers){
            #get the individual classes
            if(UIClass := PlayerHudClasses[Player]){
                #update the buttons text to match
                UIClass.BUTTON_VOTE_1.SetText(VoteTextLocalized(votes_option_1))
                UIClass.BUTTON_VOTE_2.SetText(VoteTextLocalized(votes_option_2))
                UIClass.BUTTON_VOTE_3.SetText(VoteTextLocalized(votes_option_3))
            }
        }

    #Triggered when clicked on the first button
    AddVote1(WM : widget_message):void =
        AddAndRemoveVote(WM.Player, 0)
        #Adds a vote from player to the first option (index 0)
        UpdateUIForAllPlayers()
        #Update everyones ui
    #Triggered when clicked on the second button
    AddVote2(WM : widget_message):void =
        AddAndRemoveVote(WM.Player, 1)
        #Adds a vote from player to the second option (index 1)
        UpdateUIForAllPlayers()
        #Update everyones ui

    #Triggered when clicked on the third button
    AddVote3(WM : widget_message):void =
        AddAndRemoveVote(WM.Player, 2)
        #Adds a vote from player to the third option (index 2)
        UpdateUIForAllPlayers()
        #Update everyones ui
}
