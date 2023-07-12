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
        print(string.rep(" ",string.len(rawinpinp)))
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
    local initHp = UserCards[CardID][3]
    if GiverAtt < Cards[UserCards[UserCardID][2]] + UserCards[UserCardID][4] then
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
        UserCards[CardID][3] = 0
    else
        UserCards[CardID][3] = UserCards[CardID][3] - 25
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
end
function DrawEncounter(UserCardID,EnemyName)
    term.clear()
    term.setCursorPos(1,1)
    print("You are batteling",EnemyName)
    print("Your card has",UserCards[UserCardID][3],"hp remaining")
    print("You have",MagicPoints,"magic remaining")
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
            if Cash > InitItems[i][2]-1 then
                j[#j+1] = i
                print(#j..".",InitItems[i][1],"for",InitItems[i][2])
            end
            sleep(0)
        end
        i=CleanInput(0,#j)
        if i == 0 then
            break
        else
            
        end
    end
end
local function encounter(UserCardID,id)
    local dmgPool=0
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
                    print("You missed!")
                else
                    print("You hit the enemy!")
                end
                break
            elseif i == 2 then
                if #UserItems > 0 then
                    print("Select item to use:")
                    for j=1,#UserItems do
                        print(j,UserItems[j])
                    end
                    UseItem(CleanInput(1,#UserItems),UserCardID)
                else
                    print("You dont own any!")
                    sleep(3)
                end
                break
            elseif i == 3 then
                UserMagic=UserMagic+2
            end
        end
    end
end
function RandomEncounter(UserCardID,seed) --seed is a value in the range 0-1
    if seed > 0.5 then
        if Random() then
            encounter(UserCardID,1)
        else
            encounter(UserCardID,3)
        end
    else
        if Random() then
            encounter(UserCardID,6)
        else
            encounter(UserCardID,7)
        end
    end
end
----ONLINE MULTIPLAYER FUNCTIONS

----EXECUTE
if _VERSION == "Lua 5.1" then
else
    ErrorReport(true,"VC@E","Wrong lua version!",3)
end
while true do
    ErrorReport(true,"@E","Game is not ready yet",2)
    term.clear()
    term.setCursorPos(1,1)
    print("V=CC:T5.1-A2 @".._VERSION.." by ".._HOST)
    print("WELLCOME TO GNG!")
    print("Type 'new' to begin a new game!")
    print("Type 'load' to load a saved game!")
    print("Type 'online' for multiplayer")
    print("Type 'quit' to exit!")
    print("THE GAME CODE IS NOT YET READY")
    print("IT WILL PROBORBLY CRASH")
    inp=string.upper(read())
    if inp == "NEW" then
      LoadGame(nil)
    elseif inp == "DEV" then
        ErrorReport(true,"@E","STARTING DEV MODE",2)
        printError("WAIT")
        printError("*   *   *  *** ***")
        printError("* * *  *-*  *   * ")
        printError(" * *   * * ***  * ")
        printError("This place may be dangerus if you do not know what you are doing!")
        sleep(3)
        term.clear()
        term.setCursorPos(1,1)
        printError("This is DEV mode, please be careful!")
        while true do            
            print("Enter code to execute:")
            ---@diagnostic disable-next-line: deprecated
            assert(loadstring(read()))()
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
for i=1,#ErrorLog do
    print(i,ErrorLog[i][1])
end