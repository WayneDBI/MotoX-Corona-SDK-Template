module(..., package.seeall)

------------------------------------------------------------------------------------------------------------------------------------
-- MotoX Corona Template
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http:www.deepbueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
--
-- level1.lua
--
-- 23rd December 2018
-- Version 4.0
-- Requires Corona 2018.3326
------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Level 1
-- Create the Rigging and Ramps etc...
---------------------------------------------------------------------------


-- Build more scenes using the GUMBO tool, then use the co-ordinates of the obsticles


local floorType1 = sprite.newSpriteSet(spriteSheetGroup,23,1)
local floorType2 = sprite.newSpriteSet(spriteSheetGroup,22,1)
local floorType3 = sprite.newSpriteSet(spriteSheetGroup,21,1)
local floorType4 = sprite.newSpriteSet(spriteSheetGroup,20,1)
local supportRig = sprite.newSpriteSet(spriteSheetGroup,24,1)
local startFinish = sprite.newSpriteSet(spriteSheetGroup,25,1)
local bgSign = sprite.newSpriteSet(spriteSheetGroup,27,1)
local bgMound = sprite.newSpriteSet(spriteSheetGroup,28,1)
local bgLight = sprite.newSpriteSet(spriteSheetGroup,29,1)

--sprite.add(floorType1,"floorType1",1,1,300,0)
--sprite.add(floorType2,"floorType2",21,1,300,0)
--sprite.add(floorType3,"floorType3",22,1,300,0)
--sprite.add(floorType4,"floorType4",23,1,300,0)
--sprite.add(supportRig,"supportRig",24,1,300,0)
--sprite.add(startFinish,"startFinish",25,1,300,0)
--sprite.add(bgSign,"bgSign",27,1,300,0)
--sprite.add(bgMound,"bgMound",28,1,300,0)
--sprite.add(bgLight,"bgLight",29,1,300,0)



--rig1Sprite = sprite.newSprite( floorType1 )



local function addNewRigging(x ,y, sizeX, sizeY, angle, rigName)

local riggingCollisionFilter = { categoryBits = 2, maskBits = 3 } 
local riggingMaterial = { density=100.0, friction=0.1, bounce=0.2, filter=riggingCollisionFilter }

local rig = nil
local addPhysics = false

if (rigName=="floorType1") then
	rig = sprite.newSprite( floorType1 )
	rig:prepare(floorType1)
	addPhysics = true
	rig.myName = "Floor"
elseif  (rigName=="floorType2") then
	rig = sprite.newSprite( floorType2 )
	rig:prepare(floorType2)
	addPhysics = true
	rig.myName = "Floor"
elseif  (rigName=="floorType3") then
	rig = sprite.newSprite( floorType3 )
	rig:prepare(floorType3)
	addPhysics = true
	rig.myName = "Floor"
elseif  (rigName=="floorType4") then
	rig = sprite.newSprite( floorType4 )
	rig:prepare(floorType4)
	addPhysics = true
	rig.myName = "Floor"
elseif  (rigName=="supportRig") then
	rig = sprite.newSprite( supportRig )
	rig:prepare(supportRig)
	addPhysics = true
	rig.myName = "Floor"
elseif  (rigName=="startFinish") then
	rig = sprite.newSprite( startFinish )
	rig:prepare(startFinish)
	addPhysics = true
	rig.myName = "Floor"
elseif  (rigName=="bgSign") then
	rig = sprite.newSprite( bgSign )
	rig:prepare(bgSign)
	addPhysics = false
	rig.myName = "Sign"
elseif  (rigName=="bgMound") then
	rig = sprite.newSprite( bgMound )
	rig:prepare(bgMound)
	addPhysics = false
	rig.myName = "Mound"
elseif  (rigName=="bgLight") then
	rig = sprite.newSprite( bgLight )
	rig:prepare(bgLight)
	addPhysics = false
	rig.myName = "Light"
end

rig:play()
rig.alpha = 1.0
rig.x = x
rig.y = y
rig.rotation = angle
if (addPhysics == true ) then
	physics.addBody( rig, "static", riggingMaterial )
	rig.isSensor = false
	rig.isFixedRotation = true
	rig.isAwake = true
end
game:insert( rig )

end


addNewRigging(603,260, 151, 118, 0, "bgSign")
addNewRigging(2725,260, 151, 118, 0, "bgSign")
addNewRigging(1091,245, 235, 106, 0, "bgMound")
addNewRigging(3343,245, 235, 106, 0, "bgMound")
addNewRigging(407,182, 80, 242, 0, "bgLight")
addNewRigging(1272,182, 80, 242, 0, "bgLight")
addNewRigging(2400,182, 80, 242, 0, "bgLight")
addNewRigging(3927,182, 80, 242, 0, "bgLight")

addNewRigging(60,278, 72, 24, 0, "startFinish")
addNewRigging(3794,255, 72, 24, 0, "startFinish")

addNewRigging(182,256, 192, 24, -14, "floorType1")
addNewRigging(364,195, 192, 24, -23, "floorType1")
addNewRigging(1472,167, 192, 24, 19, "floorType1")
addNewRigging(1646,238, 192, 24, 25, "floorType1")
addNewRigging(1073,145, 192, 24, -14, "floorType1")
addNewRigging(2145,291, 192, 24, -11, "floorType1")
addNewRigging(2332,273, 192, 24, 0, "floorType1")
addNewRigging(2508,229, 192, 24, -27, "floorType1")
addNewRigging(3489,180, 192, 24, 10, "floorType1")
addNewRigging(3673,226, 192, 24, 18, "floorType1")

addNewRigging(1839,309, 96, 24, 0, "floorType2")
addNewRigging(2006,309, 96, 24, 0, "floorType2")
addNewRigging(2629,158, 96, 24, -37, "floorType2")
addNewRigging(2862,162, 96, 24, -5, "floorType2")
addNewRigging(3027,158, 96, 24, 0, "floorType2")

addNewRigging(492,137, 96, 24, -28, "floorType3")
addNewRigging(769,168, 96, 24, 0, "floorType3")
addNewRigging(935,168, 96, 24, 0, "floorType3")
addNewRigging(3123,152, 96, 24, -7, "floorType3")
addNewRigging(3878,255, 96, 24, 0, "floorType3")
addNewRigging(3974,255, 96, 24, 0, "floorType3")
addNewRigging(3352,170, 96, 24, -5, "floorType3")

addNewRigging(852,168, 72, 24, 0, "floorType4")
addNewRigging(1922,309, 72, 24, 0, "floorType4")
addNewRigging(2944,158, 72, 24, 0, "floorType4")

addNewRigging(462,217, 24, 96, 0, "supportRig")
addNewRigging(462,308, 24, 96, 0, "supportRig")
addNewRigging(308,275, 24, 96, 0, "supportRig")
addNewRigging(818,223, 24, 96, 0, "supportRig")
addNewRigging(818,318, 24, 96, 0, "supportRig")
addNewRigging(982,222, 24, 96, 0, "supportRig")
addNewRigging(982,317, 24, 96, 0, "supportRig")
addNewRigging(1158,179, 24, 96, 0, "supportRig")
addNewRigging(1158,272, 24, 96, 0, "supportRig")
addNewRigging(1389,193, 24, 96, 0, "supportRig")
addNewRigging(1389,288, 24, 96, 0, "supportRig")
addNewRigging(1557,252, 24, 96, 0, "supportRig")
addNewRigging(1557,348, 24, 96, 0, "supportRig")
addNewRigging(1725,317, 24, 96, 0, "supportRig")
addNewRigging(2416,332, 24, 96, 0, "supportRig")
addNewRigging(2589,243, 24, 96, 0, "supportRig")
addNewRigging(2589,339, 24, 96, 0, "supportRig")
addNewRigging(2990,217, 24, 96, 0, "supportRig")
addNewRigging(2990,313, 24, 96, 0, "supportRig")
addNewRigging(3161,218, 24, 96, 0, "supportRig")
addNewRigging(3161,314, 24, 96, 0, "supportRig")
addNewRigging(3466,234, 24, 96, 0, "supportRig")
addNewRigging(3466,329, 24, 96, 0, "supportRig")
addNewRigging(3762,310, 24, 96, 0, "supportRig")
addNewRigging(3905,314, 24, 96, 0, "supportRig")

---------------------------------------------------------------------------
-- Create the GOAL hit Object/Zone
---------------------------------------------------------------------------
local myGoalCollisionFilter = { categoryBits = 2, maskBits = 3 } 
local myGoalMaterial = { density=100.0, friction=0.1, bounce=0.2, filter=myGoalCollisionFilter }
local myWinGoal = display.newRect(3950,190,260,68)
myWinGoal.anchorX = 0.5		-- Graphics 2.0 Anchoring method
myWinGoal.anchorY = 0.5		-- Graphics 2.0 Anchoring method
myWinGoal:setFillColor(140, 140, 140)
myWinGoal.alpha = 0.0
physics.addBody( myWinGoal, "static", myGoalMaterial )
myWinGoal.isSensor = true
myWinGoal.isFixedRotation = true
myWinGoal.isAwake = true
myWinGoal.myName = "myGoal" -- We'll use this NAME in the main code to detect if the user has reached the end

game:insert( myWinGoal )
				
