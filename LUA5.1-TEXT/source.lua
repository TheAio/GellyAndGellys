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
----CODE
function drawMap(pos)
  j=0
  for i=1,#Map do
    j=j+1
    if j==11 then
      print("")
    end
    if i==pos then
      print("¤")
    else
      print(Map[i])
    end
  end
    print("C=the clubhouse, F=The café, S=The stage, M=The market")
    print(">=The portal, B=Starting point, #=grass, /=water")
end
function giveCard(id)
  MyCards[#MyCards+1]={id,100,0,0,0,0}
end
function hurtCard(MyCardsID,HPMod,WHOMod,ATTMod,DEFMod,SPDMod)
  local orgHP = MyCards[MyCardsID][2]
  local orgWHO = MyCards[MyCardsID][3]
  local orgATT = MyCards[MyCardsID][4]
  local orgDEF = MyCards[MyCardsID][5]
  local orgSPD = MyCards[MyCardsID][6]
end
