---@diagnostic disable: lowercase-global, undefined-global
----GLOBAL VARIABLES
Cards={{"Buckus",2,5,7,2,3,4,6,1,7},{"Fairy-jule",3,6,5,7,7,7,8,6,0},{"Nemo",1,3,2,6,4,2,0,3,2},{"Soup-Cloud",3,4,7,7,7,8,7,7,1},{"Sungus",4,8,8,8,6,3,9,0,8},{"UPD-giraffe",1,2,2,3,2,4,6,5,1},{"wood-mogus",2,7,3,6,6,6,0,0,4}}
--{...{Name,Type,Att,Def,Spd,Int,Cha,Mag,Who,Cur}...}
InitItems={{"Tofu",10,20,5},{"Noodle-Soup",25,51,10},{"Gellibo-Soup",50,100,25},{"Toxic-Gel",100,-25,-10},{"G-Bandaid",5,0,5},{"R-Bandaid",5,5,0},{"P-Bandaid",10,5,5}}
--{...{Name,Cost,HPMod,ATTMod}...}
UserCards={}
--{...{Name,Card,HP,ATTMod}...}
UserItems={}
--{...id...}
UserMagic=0
ErrorLog = {}
--{...{trace,text,level}...}
----CORE GAME FUNCTIONS
function ErrorReport(isWrite,trace,text,level)
    --levels: 1 - minor addon issue 2 - minor game issue or major addon issue 3 - major game issue (panic)    
    if isWrite then
        ErrorLog[#ErrorLog+1] = {trace,text,level}
        if level == 2 then
            printError(trace,"is causing a level 2 error!")
            sleep(2)
        elseif level > 2 then
            printError("LUA PANIC")
            printError("Something has gone very wrong!")
            printError("'"..text.."'")
            printError("If you submit a bug report or ask for help, include the following:")
            printError("----BEGIN DATA DUMP----")
            printError("#ErrorLog",#ErrorLog)
            printError("#C&#II:",#Cards,#InitItems)
            error(text.." "..trace.." "..level,2)
        end
    end
end
function CleanInput(min,max)
    local ox,oy=term.getCursorPos()
    while true do
        local rawinp = read()
        local inp = tonumber(rawinp)
        if inp == nil then
        elseif inp > min-1 then
            if inp < max+1 then
                return inp
            end
        end
        term.setCursorPos(ox,oy)
        term.clearLine()
        term.setCursorPos(ox,oy)
    end
end
function Random()
    if tonumber(string.sub(os.clock(),string.len(os.clock()),string.len(os.clock()))) > 5 then
        randomBool = true
    else
        randomBool = false
    end
    return randomBool
end
function Give(ID,Type) --Type is 'item' or 'card'
    if Type == "item" then
        UserItems[#UserItems+1] = ID
    elseif Type == "card" then
        UserCards[#UserCards+1] = {Cards[ID][1],ID,100,0}
    else
        ErrorReport(true,"Give@CGF","invalid type",2)
    end
end
function Damage(UserCardID,GiverAtt,GiverSpd,GiverInt)
    local initHp = UserCards[UserCardID][3]
    for i=1,#Cards do
        if Cards[i][1] == UserCards[UserCardID][1] then
            baseAtt = Cards[i][3]
        end
    end
    if GiverAtt < baseAtt + UserCards[UserCardID][4] then
        if Random() then
            return 0
        end
    end
    if GiverSpd < Cards[UserCards[UserCardID][2]][5] then
        if Random() then
            return 0
        end
    end
    if GiverInt < Cards[UserCards[UserCardID][2]][7] then
        if Random then
            return 0
        end
    end
    if initHp < 25 then
        UserCards[UserCardID][3] = 0
    else
        UserCards[UserCardID][3] = UserCards[UserCardID][3] - 25
    end
    return 25
end
function Attack(UserCardID)
    if UserCards[UserCardID][3] == 0 then
        return false
    elseif UserMagic < Cards[UserCardID[2]][8] then
        return false
    else
        UserMagic = UserMagic - Cards[UserCardID[2]][8]
    end
end
function HealCard(UserCardID,HPMod,ATTMod)
    UserCards[UserCardID][3] = UserCards[UserCardID][3]+HPMod
    UserCards[UserCardID][4] = UserCards[UserCardID][4]+ATTMod
end
function UseItem(UserItemID,UserCardID)
    HealCard(UserCardID,InitItems[UserItems[UserItemID]][3],InitItems[UserItems[UserItemID]][4])
    local ot = UserItems
    UserItems={}
    for i=1,#ot do
        if InitItems[ot[i]][1] == InitItems[ot[UserItemID]][1] then
        else
            UserItems[i] = ot[i]
        end
        sleep(0)
    end
end
function DrawEncounter(UserCardID,EnemyName)
    term.clear()
    term.setCursorPos(1,1)
    print("You are batteling",EnemyName)
    print("Your card has",UserCards[UserCardID][3],"hp remaining")
    print("You have",UserMagic,"magic remaining")
    print("Your card uses",Cards[UserCardID][8],"magic each attack")
    print("1. Attack")
    print("2. Use item")
    print("3. Wait a turn")
end
----SINGLEPLAYER FUNCTIONS
Cash=0
function LoadGame(code)
    
end
function SaveGame(code)
    
end
--[[ todo: consider depricating this function:
function simulateCard(id,dmg)
    return {Cards[id][1],id,100-dmg,0}
end
]]
function shop()
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print("SHOP")
        print("You have",Cash,"gellystars!")
        print("The items you can afford are:")
        print("0. Return")
        local j={}
        for i=1,#InitItems do
            k=false
            sleep(0)
            for a=1,#UserItems do
                if InitItems[i][1] == InitItems[UserItems[a]][1] then
                    k=true
                    break
                end
                sleep(0)
            end
            if k == false then
                if Cash > InitItems[i][2]-1 then
                    j[#j+1] = i
                    print(#j..".",InitItems[i][1],"for",InitItems[i][2])
                end
            end
        end
        i=CleanInput(0,#j)
        if i == 0 then
            break
        else
            Give(j[i],"item")
            Cash = Cash - InitItems[j[i]][2]
        end
    end
end
local function encounter(UserCardID,id)
    local dmgPool=0
    local enemyDMG=0
    local visited=false
    while true do
        term.clear()
        term.setCursorPos(1,1)
        DrawEncounter(UserCardID,Cards[id][1])
        while true do
            i=tonumber(read())
            if i == 1 then
                local dmg = Damage(UserCardID,Cards[id][3],Cards[id][5],Cards[id][6])
                if dmg == 0 then
                    term.clear()
                    term.setCursorPos(1,1)
                    if Random() then
                        print("You missed!")
                        HealCard(UserCardID,-5,0)
                    else
                        print("You almost missed!")
                        dmg = 15
                    end
                else
                    print("You hit the enemy!")
                end
                sleep(1)
                UserMagic = UserMagic - Cards[UserCardID][8]
                enemyDMG = enemyDMG + dmg
                break
            elseif i == 2 then
                if #UserItems > 0 then
                    if visited then
                        print("You may only use items once!")
                        break
                    end
                    visited=true
                    print("Select item to use:")
                    for j=1,#UserItems do
                        print(j..".",InitItems[UserItems[j]][1])
                    end
                    UseItem(CleanInput(1,#UserItems),UserCardID)
                else
                    print("You dont own any!")
                    sleep(3)
                end
                break
            elseif i == 3 then
                HealCard(UserCardID,-5,0)
                UserMagic=UserMagic+2
                break
            end
        end
        if enemyDMG > 49 then
            term.setCursorPos(1,1)
            term.clear()
            textutils.slowPrint("YOU WIN!")
            HealCard(UserCardID,10,0)
            Cash = Cash + 10
            return true
        end
        if UserCards[selectedCard][3] < 1 then
            term.clear()
            term.setCursorPos(1,1)
            textutils.slowPrint("Uhoh, your card has no more HP")
            textutils.slowPrint("That means...")
            textutils.slowPrint(".............")
            term.clear()
            term.setCursorPos(1,1)
            textutils.slowPrint("G A M E   O V E R")
            term.setCursorPos(1,1)
            textutils.slowPrint("                 ")
            return false
        end
    end
end
function RandomEncounter(UserCardID,seed) --seed is a value in the range 0-1
    if seed > 0.5 then
        if Random() then
            i=encounter(UserCardID,1)
        else
            i=encounter(UserCardID,3)
        end
    else
        if Random() then
            i=encounter(UserCardID,6)
        else
            i=encounter(UserCardID,7)
        end
    end
    return i
end
function SinglePlayer(data)
    local function giveNewCard()
        for i = 1,#UserCards do
            for j = 1,#Cards do
                if UserCards[i][2] == j then
                else
                    textutils.slowPrint("You got a...")
                    Give(j,"card")
                    print(UserCards[#UserCards][1],"card!")
                    sleep(3)
                    return true
                end
            end
        end
    end
    local function drawChapterIntro(level)
        term.clear()
        term.setCursorPos(1,1)
        print("Chapter",level)
        textutils.slowPrint("-------")
        sleep(1)
        term.clear()
        term.setCursorPos(1,1)
    end
    local function drawStory(level,event)
        
    end
    local level = 0
    Cash = 0
    UserMagic = 10
    --load stuff
    --play game
    if data == nil then
        term.clear()
        term.setCursorPos(1,1)
        textutils.slowPrint("Welcome to GNG!")
        textutils.slowPrint("Narator - One time long ago on some garden somewhere on a planet,")
        textutils.slowPrint("there was a collection of nice and friendly beings, happy as ever.")
        textutils.slowPrint("But then one day the evil magician Dave turned everyone evil!")
        textutils.slowPrint("luckily you and... who - who is that?")
        textutils.slowPrint("You - that is, that is... uh... that's")
        print("1. Nemo","2. UPD-giraffe")
        i=CleanInput(1,2)
        if i == 1 then
            Give(3,"card")
            textutils.slowPrint("Nemo!")
        else
            Give(6,"card")
            textutils.slowPrint("UPD-giraffe!")
        end
        sleep(1)
        term.clear()
        term.setCursorPos(1,1)
        textutils.slowPrint("Narator - Right, anyways the two of you somehow managed to survive!")
        textutils.slowPrint("After months of research you figure out that the only way to turn everyone back")
        textutils.slowPrint("to normal was by makeing them unconsious. Obviously the best way to do that is")
        textutils.slowPrint("by magic violance!")
        print("1. that does not sound so nice!")
        print("2. yeah, violance!")
        print("3. why should i trust you?")
        i=CleanInput(1,3)
        if i == 1 then
            textutils.slowPrint("Hey im the narrator, im telling you what to do.")
        elseif i == 2 then
            textutils.slowPrint("Yeah that's the spirit!")
        else
            textutils.slowPrint("Look you! Im the narrator, this is not some stanleys parable you should just trust me!")
        end
        textutils.slowPrint("Now go play the game!")
        selectedCard=1
        sleep(2)
    end
    recentLevel = level
    rand=true   
    drawChapterIntro(level)
    while true do
        textutils.slowPrint("Do you want to visit the shop?")
        print("1. Yes 2. No")
        inp = CleanInput(1,2)
        if inp == 1 then
            shop()
        end
        if UserCards[selectedCard][3] < 1 then
            term.clear()
            term.setCursorPos(1,1)
            textutils.slowPrint("Uhoh, your card has no more HP")
            textutils.slowPrint("That means...")
            textutils.slowPrint(".............")
            term.clear()
            term.setCursorPos(1,1)
            textutils.slowPrint("G A M E   O V E R")
            term.setCursorPos(1,1)
            textutils.slowPrint("                 ")
            return true
        elseif UserCards[selectedCard][3] < 25 then
            term.clear()
            term.setCursorPos(1,1)
            textutils.slowPrint("Your card is very hurt!")
            if #UserItems > 0 then
                while true do
                    print("Do you want to use an item on your card?")
                    print("0 no, go back")
                    for i=1,#UseItems do
                        print(i,"use",UserItems[i])
                    end
                    print(#UserItems+1,"go to the store")
                    inp = CleanInput()
                    if inp == 0 then
                        break
                    elseif inp == #UserItems+1 then
                        shop()
                    else
                        UseItem(inp,selectedCard)
                    end
                end
            end
        end
        if rand then
            rand = false
        else
            rand = true
        end
        if level == recentLevel then
            if rand then
                i=RandomEncounter(selectedCard,1)
            else
                i=RandomEncounter(selectedCard,0)
            end
            if i then
                level = level + 1
            else
                return true
            end
        else
            drawChapterIntro(level)
            if #UserCards > #Cards-1 then
                print("Enter a number between 1 and",#Items)
                giveItem(CleanInput(1,#Items))
            end
            giveNewCard()
            drawChapterIntro(level)
            recentLevel = level
        end
    end
end
----ONLINE MULTIPLAYER FUNCTIONS

----ADDON HOOKING
if fs.exists("addons/") then
    if fs.exists("addons/items/") then
        i=fs.list("addons/items/")
        if #i == 0 then
            ErrorReport(true,"I@AH","items folder exists but is empty",1)
        else
            for j=1,#i do
                k=fs.open(i[j])
                InitItems[#InitItems+1] = {k.readLine(),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine())}
                k.close()
                sleep(0)
            end
        end
    end
    if fs.exists("addons/cards/") then
        i=fs.list("addons/cards/")
        if #i == 0 then
            ErrorReport(true,"C@AH","cards folder exists but is empty",1)
        else
            for j=1,#i do
                k=fs.open(i[j])
                Cards[#Cards+1] = {k.readLine(),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine()),tonumber(k.readLine())}
                k.close()
                sleep(0)
            end
        end
    end
end
----EXECUTE
if _VERSION == "Lua 5.1" then
else
    ErrorReport(true,"VC@E","Wrong lua version!",3)
end
while true do
    ErrorReport(true,"MM@E","Game is in beta!",2)
    term.clear()
    term.setCursorPos(1,1)
    print("V=CC:T5.1-B1 @".._VERSION.." by ".._HOST)
    print("WELCOME TO GNG!")
    print("Type 'new' to begin a new game!")
    print("Type 'load' to load a saved game!")
    print("Type 'online' for multiplayer!")
    print("Type 'quit' to exit!")
    print("Type 'about' for more info!")
    print("THE GAME CODE IS IN BETA")
    print("IT WILL PROBORBLY CRASH")
    inp=string.upper(read())
    if inp == "ABOUT" then
        textutils.slowPrint("GNG (Gelly and Gellys) is a game based of a card game based around a discord server")
        textutils.slowPrint("The code is licensed under the GNU General Public License v3.0")
        textutils.slowPrint("please see https://github.com/TheAio/GellyAndGellys/blob/main/LICENSE for more information")
        textutils.slowPrint("Now that you have explored this menu here is a secrate left behind by Aio")
        textutils.slowPrint("If you type 'DEV' in the main menu you get a secrate menu!")
        sleep(5)
    elseif inp == "NEW" then
      LoadGame(nil)
      SinglePlayer()
    elseif inp == "DEV" then
        ErrorReport(true,"@E","STARTING DEV MODE",2)
        printError("WAIT")
        printError("*   *   *  *** ***")
        printError("* * *  *-*  *   * ")
        printError(" * *   * * ***  * ")
        printError("This place may be dangerus if you do not know what you are doing!")
        print("Press enter to conutinue")
        read()
        term.clear()
        term.setCursorPos(1,1)
        printError("This is DEV mode, please be careful!")
        while true do
            print("1. cheatCode 2. e-code 3. e-shell")
            i=CleanInput(1,3)
            if i == 1 then
                print("Enter cheat code:")
                i=CleanInput(1,5)
                if i == 1 then
                    for i=1,#ErrorLog do
                        print(ErrorLog[i][1],ErrorLog[i][2],ErrorLog[i][3])
                    end
                elseif i == 2 then
                    for i=1,#InitItems do
                        Give(i,"item")
                        sleep(0)
                    end
                    for i=1,#Cards do
                        Give(i,"card")
                        sleep(0)
                    end
                elseif i == 3 then
                    print("Enter 1 or 2")
                    RandomEncounter(1,1/CleanInput(1,2))
                elseif i == 4 then
                    Cash = tonumber(CleanInput(-999,999))
                    shop()
                end
            elseif i == 2 then
                print("Enter code to execute:")
                ---@diagnostic disable-next-line: deprecated
                assert(loadstring(read()))()
            elseif i == 3 then
                shell.run(read())
            end
        end
    elseif inp == "LOAD" then
      print(SaveGame())
      print("Please enter your save code:")
      LoadGame(string.upper(tostring(read())))
    elseif inp == "ONLINE" then
        onlineMenu()
    elseif inp == "QUIT" then
      break
    end
end
term.setCursorPos(1,1)
term.clear()
print("Thank you for playing!")
if #ErrorLog > 0 then
    print("The following are all errors reported during gameplay:")
    for i=1,#ErrorLog do
        print(i,ErrorLog[i][1])
        sleep(0)
    end
end