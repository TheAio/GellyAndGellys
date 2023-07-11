---@diagnostic disable: lowercase-global, undefined-global
--This is the first version of GNG, for more information see readme.lua
----DATA
Map={
  "-","-","-","-","-","-","-","-","-","-",
  "|","C","#","#","/","/","/","/","/","|",
  "|","#","#","/","/","/","/","/","/","|",
  "|","F","#","#","#","S","#","#","#","|",
  "|","#","M","#","#","#","#","#",">","|",
  "|","/","/","/","/","B","#","#","#","|",
  "-","-","-","-","-","-","-","-","-","-"
}
MapData={
  {1,1,1,1,1,1,1,1,1,1},
  {1,101,2,2,3,3,3,3,3,1},
  {1,2,2,3,3,3,3,3,3,1},
  {1,102,2,2,2,103,2,2,2,1},
  {1,2,104,2,2,2,2,2,105,1},
  {1,3,3,3,3,0,2,2,2,1},
  {1,1,1,1,1,1,1,1,1,1}
}
Cards={{"Buckus",2,5,7,2,3,4,6,1,7},{"Fairy jule",3,6,5,7,7,7,8,6,0},{"Nemo",1,3,2,6,4,2,0,3,2},{"Soup Cloud",3,4,7,7,7,8,7,7,1},{"Sungus",4,8,8,8,6,3,9,0,8},{"UPD-giraffe",1,2,2,3,2,4,6,5,1},{"wood mogus",2,7,3,6,6,6,0,0,4}}
--{...{Name,Type,Att,Def,Spd,Int,Cha,Mag,Who,Cur}...}
Items={{"Tofu",10,20,5},{"Noodle-Soup",25,51,10},{"Gellibo-Soup",50,100,25},{"Toxic-Gel",100,-25,-10},{"G-Bandaid",5,0,5},{"R-Bandaid",5,5,0},{"P-Bandaid",10,5,5}}
--{...{Name,Cost,HPMod,WHOMod}...}
----GLOBAL VERIBALES
Inventory={}
MyCards={}
--{...{id,hp,WHOMod,ATTMod,DEFMod,SPDMod}...}
Pos=56
StoryLevel=0
----CODE
function drawMap(pos)
  j=0
  i=0
  while true do
    i=i+1
    j=j+1
    if i == #Map +1 then
      break
    end
    if j==11 then
      j=1
      print("")
    end
    if i==pos then
      write("¤")
    else
      write(Map[i])
    end
  end
    print("")
    print("C=the clubhouse, F=The café, S=The stage, M=The market")
    print(">=The portal, B=Starting point, #=grass, /=water")
end
function giveCard(id)
  MyCards[#MyCards+1]={id,100,0,0,0,0}
end
function giveItem(id)
  Inventory[#Inventory+1] = Items[id]
end
function hurtCard(MyCardsID,HPMod,WHOMod,ATTMod,DEFMod,SPDMod)
  local orgHP = MyCards[MyCardsID][2]
  local orgWHO = MyCards[MyCardsID][3]
  local orgATT = MyCards[MyCardsID][4]
  local orgDEF = MyCards[MyCardsID][5]
  local orgSPD = MyCards[MyCardsID][6]
end
function StoryEvent(Building,StoryLevel) --TODO; HIGH PIORITY
  print("THE STORY FEATURE DOES NOT YET EXIST")
end
function RollEncounter() --TODO; HIGH PRIORITY
  print("RANDOM ENCOUNTERS DOES NOT YET EXIST")
end
function move(Dir)
  if Dir == "U" then
    NPos=Pos-10
  elseif Dir == "D" then
    NPos=Pos+10
  elseif Dir == "L" then
    NPos=Pos-1
  elseif Dir == "R" then
    NPos=Pos+1
  end
  if NPos > #MapData then
    NPos=Pos
  elseif NPos < 1 then
    NPos=Pos
  end
  if MapData[NPos] == 3 or MapData[NPos] == 1 then
    NPos=Pos
  elseif MapData[NPos] > 100 then
    StoryEvent(NPos,StoryLevel)
  end
  if NPos == Pos then
  else
    RollEncounter()
  end
  Pos=NPos
end
function LoadGame(saveCode)
  if saveCode == nil then
    print("INTRO TEXT HERE")
  else
    saveCode = tostring(tonumber(saveCode,16))
    Pos=tonumber(string.sub(saveCode,1,2))
    StoryLevel=tonumber(string.sub(saveCode,3,4))
    i=tonumber(string.sub(saveCode,5,7))
    for j=1,i do
      giveItem(string.sub(saveCode,7+j,7+j))
    end
    j=tonumber(string.sub(saveCode,8+i,10+i))
    for k=1,j do
      giveCard(k)
    end
  end
end
function SaveGame()
  if Pos < 10 then
    Pos = "0"..tostring(Pos)
  else
    Pos = tostring(Pos)
  end
  if StoryLevel < 10 then
    StoryLevel = "0"..tostring(StoryLevel)
  else
    StoryLevel = tostring(StoryLevel)
  end
  ItemCountAsStr=tostring(#Inventory)
  ItemIds = ""
  for i=1,#Inventory do
    for j=1,#Items do
      if Items[j][1] == Inventory[i][1] then
        ItemIds = ItemIds+tostring(j)
      end
    end
  end
  CardCountAsStr=tostring(#MyCards)
  CardIds = ""
  for i=1,#MyCards do
    for j=1,#Cards do
      if Cards[j][1] == MyCards[i][1] then
        CardIds = CardIds..tostring(j)
      end
    end
  end
  if tonumber(ItemCountAsStr) < 10 then
    ItemCountAsStr="00"..ItemCountAsStr
  elseif tonumber(ItemCountAsStr) < 100 then
    ItemCountAsStr="0"..ItemCountAsStr
  end
  if tonumber(CardCountAsStr) < 10 then
    CardCountAsStr="00"..CardCountAsStr
  elseif tonumber(CardCountAsStr) < 100 then
    CardCountAsStr="0"..CardCountAsStr
  end
  saveCode = Pos..StoryLevel..ItemCountAsStr..ItemIds..CardCountAsStr..CardIds
  saveCode = ('%X'):format(saveCode)
  if string.len(tostring(saveCode)) < 10 then
    saveCode="0"..tostring(saveCode)
  end
  return saveCode
end
----EXECUTE
while true do
  print("V=CC:T5.1-A1_R-ABANDON @".._VERSION.." by ".._HOST)
  print("WELLCOME TO GNG!")
  print("Type 'new' to begin a new game!")
  print("Type 'load' to load a new game!")
  print("Type 'quit' to exit!")
  drawMap(56)
  print("THE GAME CODE IS NOT YET READY")
  print("IT WILL PROBORBLY CRASH")
  inp=string.upper(read())
  if inp == "N" then
    LoadGame(nil)
  elseif inp == "L" then
    print(SaveGame())
    print("Please enter your save code:")
    LoadGame(string.upper(tostring(read(10))))
  elseif inp == "Q" then
    break
  end
end
