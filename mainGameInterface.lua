------------------------------------------------------------------------------------------------------------------------------------
-- MotoX Corona Template
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http:www.deepbueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
--
-- mainGameInterface.lua
--
-- 23rd December 2018
-- Version 4.0
-- Requires Corona 2018.3326
------------------------------------------------------------------------------------------------------------------------------------


-- Build more scenes using the GUMBO tool, then use the co-ordinates of the obsticles

-- Collect relevant external libraries
local composer 			= require( "composer" )
local scene 			= composer.newScene()
system.activate( "multitouch" )

-- vars local
local bgObjects_Group 		= nil
local player_Group			= nil
local world_Group				= nil
local maxBounds			    = 180
local numberOfEnemies			= 0
local worldWall			  	= nil
local gameOverBool			= false
local levelCompleted			= false
local holdOldX			  	= 0
local holdOldY			  	= 0
local debugON           		= false
local bikeOnPlatform 			= false
--level					= 1		--Default starting Level
local bikeMaxSpeed			= 300
local bikeAccelerateSpeed		= 25
local bikeTiltLeft			= false
local bikeTiltRight			= false
local bikeAccelerate			= false
local bikeReverse				= false
local bikeOnFloor				= true
local bikeTiltSpeed			= 12
local bikeSpeed				= 0
local nextLevel				= ""

local bgObjects_Group 	= display.newGroup()
local fgObjects_Group 	= display.newGroup()
local bikeObjects_Group 	= display.newGroup()
local youWin_Group 		= display.newGroup()
local youLoose_Group 		= display.newGroup()
local rearWheel 
local frontWheel
local bikeHitZone
local bikerMan
local reverseButton
local rightButton
local bgSky
local rearWheelJoint
local frontWheelJoint
local myJoint
local memInfoTimer
local collectScene
local mainPlayerSprite
local audioCrash
local mainPlayerSpriteSet

-- Initiate the Main Game Group
game = display.newGroup();
game.x = 0

local _W 		= display.contentWidth/2
local _H 		= display.contentHeight/2
local _MH  		= display.contentHeight



-----------------------------------------------------------------
-- Setup the Physics World
-----------------------------------------------------------------
physics.start()
physics.setScale( 90 )
physics.setGravity( 0, 7 )
physics.setPositionIterations(128)

-- un-comment to see the Physics world over the top of the Sprites
--physics.setDrawMode( "hybrid" )



----------------------------------------------------------------------------------------------------
-- Extra cleanup routines
----------------------------------------------------------------------------------------------------
local coronaMetaTable = getmetatable(display.getCurrentStage())
	isDisplayObject = function(aDisplayObject)
	return (type(aDisplayObject) == "table" and getmetatable(aDisplayObject) == coronaMetaTable)
end

local function cleanGroups ( objectOrGroup )
    if(not isDisplayObject(objectOrGroup)) then return end
		if objectOrGroup.numChildren then
			-- we have a group, so first clean that out
			while objectOrGroup.numChildren > 0 do
				-- clean out the last member of the group (work from the top down!)
				cleanGroups ( objectOrGroup[objectOrGroup.numChildren])
			end
		end
			--objectOrGroup:removeSelf()
			display.remove(objectOrGroup)
			objectOrGroup = nil

			print("Cleaning....")
    return
end




-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.

	audio.setVolume( musicVolume )

	-----------------------------------------------------------------
	-- Setup our World/Scene Groups
	-----------------------------------------------------------------
	--[[
	bgObjects_Group 	= display.newGroup()
	fgObjects_Group 	= display.newGroup()
	bikeObjects_Group 	= display.newGroup()
	youWin_Group 		= display.newGroup()
	youLoose_Group 		= display.newGroup()
	--]]
	
	-----------------------------------------------------------------
	-- Setup the Background Sky sprite
	-----------------------------------------------------------------
	local bgImageSprite = sprite.newSpriteSet(spriteSheetGroup,2,1)
	bgSky = sprite.newSprite( bgImageSprite )
	bgSky:prepare(bgImageSprite)
	bgSky:play()
	bgSky.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	bgSky.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	bgSky.x = _W
	bgSky.y = _H
	bgObjects_Group:insert( bgSky )
	--bgSky.alpha = 0.2
	
	-----------------------------------------------------------------
	-- Setup the Loose Group
	-----------------------------------------------------------------
	local looseImageSprite = sprite.newSpriteSet(spriteSheetGroup,5,1)
	looseImage = sprite.newSprite( looseImageSprite )
	looseImage:prepare(looseImageSprite)
	looseImage:play()
	looseImage.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	looseImage.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	looseImage.x = _W
	looseImage.y = _H
	youLoose_Group:insert( looseImage )
	youLoose_Group.y=-300
	
	-----------------------------------------------------------------
	-- Setup the Winning Group
	-----------------------------------------------------------------
	local winImageSprite = sprite.newSpriteSet(spriteSheetGroup,3,1)
	winImage = sprite.newSprite( winImageSprite )
	winImage:prepare(winImageSprite)
	winImage:play()
	winImage.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	winImage.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	winImage.x = _W
	winImage.y = _H
	youWin_Group:insert( winImage )
	youWin_Group.y=-300


	---------------------------------------------------------------------------
	-- Add the World Boundries (We'll use these to check for a Game Over)
	---------------------------------------------------------------------------
	function addWall( x, y, angle,  width, height, wallType )
	
		local wallCollisionFilter = { categoryBits = 2, maskBits = 3 } 
		local wallMaterial = { density=300.0, friction=0.5, bounce=0.3, filter=wallCollisionFilter }

		local worldWall = display.newRect( 0, 0, width, height )
		--worldWall:setReferencePoint(display.TopLeftReferencePoint)
		worldWall.anchorX = 0.0		-- Graphics 2.0 Anchoring method
		worldWall.anchorY = 0.5		-- Graphics 2.0 Anchoring method
		worldWall.x = x
		worldWall.y = y
		worldWall.rotation = angle
		if (wallType=="Die") then
			worldWall.myName = "wall"
		else
			worldWall.myName = "myGoal"
		end
		worldWall.alpha = 0.0
		physics.addBody( worldWall, "static", wallMaterial )
		game:insert( worldWall )
	end

	addWall(0,310,0,4000,16,"Die")  	--Bottom
	addWall(-30,150,0,16,320,"Die")		--Left
	addWall(4000,150,0,16,320,"End")		--Right NOTE: We set a different flag to help the Corona Engine CATCH a win collision
	
	
	
	
	-----------------------------------------------------------------
	-- Load the Level and return how many ENEMIES there are to collect.
	-----------------------------------------------------------------
	collectScene = require("level"..level) --We dynamically load the correct level.

	-----------------------------------------------------------------
	-- Insert the LEVEL Scene Data into the contolled Game Group
	-----------------------------------------------------------------
	game:insert( bgObjects_Group )
	
	
	-----------------------------------------------------------------
	-- Insert the Bike
	-----------------------------------------------------------------
	local bikeArea = { -40,0,40,0,40,20,-40,20 }
	local bikeCollisionFilter = { categoryBits = 1, maskBits = 6 } 
	local bikeMaterial = { density=5, friction=0.0, bounce=0.0, filter=bikeCollisionFilter, shape=bikeArea }

	mainPlayerSpriteSet = sprite.newSpriteSet(spriteSheetGroup,7,12)
	sprite.add(mainPlayerSpriteSet,"bikeIdle",14,4,400,-2)
	sprite.add(mainPlayerSpriteSet,"bikeUp",13,1,400,-2)
	sprite.add(mainPlayerSpriteSet,"bikeDown",8,1,400,-2)
	sprite.add(mainPlayerSpriteSet,"bikeFinish",9,4,400,-2)
	sprite.add(mainPlayerSpriteSet,"bikeCrash",7,1,400,-2)
	
	mainPlayerSprite = sprite.newSprite( mainPlayerSpriteSet )
	mainPlayerSprite:prepare("bikeIdle")
	mainPlayerSprite:play()
	mainPlayerSprite.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	mainPlayerSprite.anchorY = 0.36		-- Graphics 2.0 Anchoring method
	mainPlayerSprite.x = 70
	mainPlayerSprite.y = 160
	
	physics.addBody( mainPlayerSprite, "dynamic", bikeMaterial )

	mainPlayerSprite.myName = "Bike"
	mainPlayerSprite.isSensor = false
	mainPlayerSprite.isFixedRotation = false
	mainPlayerSprite.isAwake = true
	mainPlayerSprite.isSleepingAllowed = false
	mainPlayerSprite.maxVelocity = bikeMaxSpeed


	-----------------------------------------------------------------
	-- Insert the Rear Wheel
	-----------------------------------------------------------------
	rearWheel = display.newCircle( _W,_H, 12 ) 
	
	rearWheel:setFillColor( 0, 0, 0 ) 
	rearWheel.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	rearWheel.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	rearWheel.x = mainPlayerSprite.x-(mainPlayerSprite.width/2)+15
	rearWheel.y = mainPlayerSprite.y+(mainPlayerSprite.height/2)
	rearWheel.alpha = 0
	rearWheel.isSensor = false
	rearWheel.myName = "Wheel"
	physics.addBody( rearWheel, "dynamic", { density=500.0, friction=20.0, bounce=0.1, radius=rearWheel.width/2, filter=bikeCollisionFilter } )
	rearWheelJoint = physics.newJoint( "pivot", mainPlayerSprite, rearWheel, mainPlayerSprite.x-(mainPlayerSprite.width/2)+15,mainPlayerSprite.y+(mainPlayerSprite.height/2))
	rearWheelJoint.isMotorEnabled = true-- (boolean)
	rearWheelJoint.motorSpeed = bikeSpeed -- (linear speed, in units of pixels per second)
	rearWheelJoint.maxMotorTorque = 10000
	rearWheelJoint.maxMotorForce = 20000

	-----------------------------------------------------------------
	-- Insert the Front Wheel
	-----------------------------------------------------------------
	frontWheel = display.newCircle( _W,_H, 12 ) 
	frontWheel:setFillColor( 0, 0, 0 ) 
	frontWheel.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	frontWheel.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	frontWheel.x = mainPlayerSprite.x+(mainPlayerSprite.width/2)-15
	frontWheel.y = mainPlayerSprite.y+(mainPlayerSprite.height/2)
	frontWheel.alpha = 0
	frontWheel.isSensor = false
	frontWheel.myName = "Wheel"
	physics.addBody( frontWheel, "dynamic", { density=1000.0, friction=20.0, bounce=0.1, radius=frontWheel.width/2, filter=bikeCollisionFilter } )
	frontWheelJoint = physics.newJoint( "pivot", mainPlayerSprite, frontWheel, mainPlayerSprite.x+(mainPlayerSprite.width/2)-15,mainPlayerSprite.y+(mainPlayerSprite.height/2))
	frontWheelJoint.isMotorEnabled = true-- (boolean)
	frontWheelJoint.motorSpeed = bikeSpeed -- (linear speed, in units of pixels per second)
	frontWheelJoint.maxMotorTorque = 10000
	frontWheelJoint.maxMotorForce = 20000


	-----------------------------------------------------------------
	-- Insert the Bike Hit Zone
	-----------------------------------------------------------------
	local bikeHitCollisionFilter = { categoryBits = 1, maskBits = 6 } 
	local bikeHitMaterial = { density=1, friction=0.0, bounce=0.0, filter=bikeHitCollisionFilter }
	bikeHitZone = display.newRect(mainPlayerSprite.x,mainPlayerSprite.y,30,30)
	bikeHitZone.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	bikeHitZone.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	bikeHitZone:setFillColor(140, 140, 140)
	bikeHitZone.alpha = 0.0
	physics.addBody( bikeHitZone, "dynamic", bikeHitMaterial )
	bikeHitZone.isSensor = true
	bikeHitZone.isFixedRotation = false
	bikeHitZone.myName = "bikeHitZone"

	myJoint = physics.newJoint( "weld", mainPlayerSprite, bikeHitZone, mainPlayerSprite.x,mainPlayerSprite.y-20)

	game:insert( mainPlayerSprite )
	game:insert( bikeHitZone )
	game:insert(rearWheel)
	game:insert(frontWheel)

	-----------------------------------------------------------------
	-- Insert the Biker Man (Hidden to Start with)
	-----------------------------------------------------------------
	local bikerManArea = { -12, -31  ,  5, -32  ,  11, 26  ,  -13, 33 }
	local bikerManCollisionFilter = { categoryBits = 2, maskBits = 6 } 
	local bikerManaterial = { density=80, friction=0.6, bounce=0.2, filter=bikerManCollisionFilter, shape=bikerManArea }
	local bikerManSprite = sprite.newSpriteSet(spriteSheetGroup,18,1)
	bikerMan = sprite.newSprite( bikerManSprite )
	bikerMan:prepare(bikerManSprite)
	bikerMan:play()
	bikerMan.anchorX = 0.5		-- Graphics 2.0 Anchoring method
	bikerMan.anchorY = 0.5		-- Graphics 2.0 Anchoring method
	bikerMan.x = 370
	bikerMan.y = -100
	physics.addBody( bikerMan, "static", bikerManaterial )
	bikerMan.myName = "BikerMan"

	game:insert( bikerMan )
	
	-----------------------------------------------------------------
	-- Insert the Accelerator
	-----------------------------------------------------------------
	local accelertorSprite = sprite.newSpriteSet(spriteSheetGroup,6,1)
	accelertorButton = sprite.newSprite( accelertorSprite )
	accelertorButton:prepare(accelertorSprite)
	accelertorButton:play()
	accelertorButton.x = 110
	accelertorButton.y = 286
	fgObjects_Group:insert( accelertorButton )
	
	-----------------------------------------------------------------
	-- Insert the Reverse/Brake
	-----------------------------------------------------------------
	local reverseSprite = sprite.newSpriteSet(spriteSheetGroup,4,1)
	reverseButton = sprite.newSprite( reverseSprite )
	reverseButton:prepare(reverseSprite)
	reverseButton:play()
	reverseButton.x = 36
	reverseButton.y = 286
	fgObjects_Group:insert( reverseButton )

	-----------------------------------------------------------------
	-- Insert the Tilt Forwards Button
	-----------------------------------------------------------------
	rightButton = sprite.newSprite( accelertorSprite )
	rightButton:prepare(accelertorSprite)
	rightButton:play()
	rightButton.x = 443
	rightButton.y = 286
	fgObjects_Group:insert( rightButton )

	-----------------------------------------------------------------
	-- Insert the Tilt Backwards Button
	-----------------------------------------------------------------
	local leftSprite = sprite.newSpriteSet(spriteSheetGroup,4,1)
	leftButton = sprite.newSprite( leftSprite )
	leftButton:prepare(leftSprite)
	leftButton:play()
	leftButton.x = 371
	leftButton.y = 286
	fgObjects_Group:insert( leftButton )

	-----------------------------------------------------------------
	-- Insert All the Groups into the Scenes main Grouping Layer
	-- We do this so the SCENE TRANSITION can clean up properly at the end
	-----------------------------------------------------------------
	sceneGroup:insert( bgObjects_Group )
	sceneGroup:insert( youWin_Group )
	sceneGroup:insert( game )
	sceneGroup:insert( bikeObjects_Group )
	sceneGroup:insert( fgObjects_Group )
	sceneGroup:insert( youLoose_Group )

	
	-----------------------------------------------------------------
	-- Start the BG Music - Looping
	-----------------------------------------------------------------
	local bgMusicStart = audio.play(bgMusic, {channel=1})
	print("Music started")


	---------------------------------------------------------------------------------------------
	-- Add Listeners to out SCENE ROTATE BUTTONS and Scene Detection Actors (Panda and Enemies).
	---------------------------------------------------------------------------------------------
	looseImage:addEventListener( "touch", restartTouch)
	winImage:addEventListener( "touch", completedTouch)
	rightButton:addEventListener( "touch", rightTouch)
	leftButton:addEventListener( "touch", leftTouch)
	accelertorButton:addEventListener( "touch", goTouch)
	reverseButton:addEventListener( "touch", brakeTouch)

end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.

      	composer.removeScene( "startScreen" )
		-- Completely removes all scenes except for the currently active scene
		composer.removeHidden()		

   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.

      	display.remove(mainPlayerSpriteSet)
	mainPlayerSpriteSet = nil

	looseImage:removeEventListener( "touch", restartTouch)
	winImage:removeEventListener( "touch", completedTouch)
	rightButton:removeEventListener( "touch", rightTouch)
	leftButton:removeEventListener( "touch", leftTouch)
	accelertorButton:removeEventListener( "touch", goTouch)
	reverseButton:removeEventListener( "touch", brakeTouch)
	Runtime:removeEventListener ( "collision", onGlobalCollision )
	Runtime:removeEventListener( "enterFrame", moveCamera )
	Runtime:removeEventListener( "enterFrame", bikeManager )

	audio.stop()

	audio.stop(bgMusicStart)
	audio.stop(1)
	bgMusicStart = nil
	
	audio.stop(audioCrash)
	audioCrash = nil

	print("Clear Memory")
	display.remove(collectScene)
	collectScene = nil
	
	display.remove(game)
	game = nil
	
	composer.removeScene( "level"..level )

	-- Completely removes all scenes except for the currently active scene
	composer.removeHidden()		
	
	if ( youWin_Group.trans ) then
	   transition.cancel( youWin_Group.trans )
	   youWin_Group.trans = nil
	end
	
	if ( youLoose_Group.trans ) then
	   transition.cancel( youLoose_Group.trans )
	   youLoose_Group.trans = nil
	end

	if ( mainPlayerSprite.trans ) then
	   transition.cancel( mainPlayerSprite.trans )
	   mainPlayerSprite.trans = nil
	end

	if ( bikerMan.trans ) then
	   transition.cancel( bikerMan.trans )
	   bikerMan.trans = nil
	end


	mainPlayerSprite:removeSelf()
	mainPlayerSprite = nil
	
	cleanGroups(bgObjects_Group)
	cleanGroups(fgObjects_Group)
	cleanGroups(bikeObjects_Group)
	cleanGroups(youWin_Group)
	cleanGroups(youLoose_Group)
	cleanGroups(game)
	

	display.remove(mainPlayerSprite)
	mainPlayerSprite = nil
	display.remove(bgImageSprite)
	bgImageSprite = nil
	display.remove(bgSky)
	bgSky = nil
	display.remove(looseImageSprite)
	looseImageSprite = nil
	display.remove(winImageSprite)
	winImageSprite = nil
	display.remove(bikerMan)
	bikerMan = nil
	display.remove(accelertorSprite)
	accelertorSprite = nil
	display.remove(reverseSprite)
	reverseSprite = nil
	display.remove(rightButton)
	rightButton = nil
	display.remove(leftSprite)
	leftSprite = nil
	
	
	
	bgObjects_Group 	= nil
	fgObjects_Group 	= nil
	bikeObjects_Group 	= nil
	youWin_Group 		= nil
	youLoose_Group 		= nil
	game = nil

   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end






--Level completed/Win code/functions
local function levelCompletedFunctionEnd()
	gameOverBool = true
	levelCompleted = true
end 


local function doGameCompleted()
	gameOverBool 	= true
	levelCompleted 	= true
	
	-- Stop the bike wheels moving
	bikeSpeed = 0
	rearWheelJoint.motorSpeed = bikeSpeed
	frontWheelJoint.motorSpeed = bikeSpeed

	mainPlayerSprite:prepare("bikeFinish")
	mainPlayerSprite:play()
	
	audio.play(crowdSFX, {channel=3})
	
	-- For the Template, we show a COMPLETED sign
	-- Which returns the user to the Main screen. In your game you would take the user to the next levelCompletedFunctionEnd
	-- AFTER you have incremented the [level] variable by 1, and possibly saved the users level or scores etc.....
	 youWin_Group.trans = transition.to( youWin_Group, { y = 0, time=400} )

end 



local function gameOverFunctionEnd()
	gameOverBool 	= true
	levelCompleted 	= true

	audio.stop(1)
	audio.stop(2)
	audio.stop(3)

	--audio.stop(bgMusic)
	--audio.stop(bikeCrash)
	--audio.stop(crowdSFX)
			

	looseImage:removeEventListener( "touch", restartTouch)
	winImage:removeEventListener( "touch", completedTouch)
	rightButton:removeEventListener( "touch", rightTouch)
	leftButton:removeEventListener( "touch", leftTouch)
	accelertorButton:removeEventListener( "touch", goTouch)
	reverseButton:removeEventListener( "touch", brakeTouch)
	Runtime:removeEventListener ( "collision", onGlobalCollision )
	Runtime:removeEventListener( "enterFrame", moveCamera )
	Runtime:removeEventListener( "enterFrame", bikeManager )

	composer.gotoScene( nextLevel, "crossFade", 200  )

end 



local function endMusic()
	youLoose_Group.trans = transition.to( youLoose_Group, { y = 0, time=400} )
end

local function gameOverFunctionStart()
	gameOverBool = true
	
	audioCrash = audio.play(bikeCrash, {channel=2})

	-- Stop the bike wheels moving
	bikeSpeed = 0
	rearWheelJoint.motorSpeed = bikeSpeed
	frontWheelJoint.motorSpeed = bikeSpeed

	mainPlayerSprite:prepare("bikeCrash")
	mainPlayerSprite:play()
	bikerMan.x = mainPlayerSprite.x
	bikerMan.y = mainPlayerSprite.y-20
	bikerMan.bodyType = "dynamic"
	mainPlayerSprite.trans = transition.to( mainPlayerSprite, { rotation = 360, time=600, onComplete=endMusic} )
	bikerMan.trans = transition.to( bikerMan, { rotation = 90, time=300} )
	mainPlayerSprite:applyLinearImpulse(5, 5, mainPlayerSprite.x, mainPlayerSprite.y)
	bikerMan:applyLinearImpulse(-0.1, 2, bikerMan.x, bikerMan.y)
end 




local function onGlobalCollision( event )
	if ( event.phase == "began" and gameOverBool==false) then
	
		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision began" )
	
		--Check to see if it's game over!
		if (event.object1.myName == "wall" and event.object2.myName == "Bike") then
			timer.performWithDelay(10, gameOverFunctionStart )
		end 
		
		if (event.object1.myName == "wall" and event.object2.myName == "bikeHitZone") then
			timer.performWithDelay(10, gameOverFunctionStart )
		end 
		
		if (event.object1.myName == "Floor" and event.object2.myName == "bikeHitZone") then
			timer.performWithDelay(10, gameOverFunctionStart )
		end 
		
		if (event.object1.myName == "wall" and event.object2.myName == "Wheel") then
			timer.performWithDelay(10, gameOverFunctionStart )
		end 
		
		--Check to see if we win!
		if (event.object1.myName == "myGoal" and event.object2.myName == "Bike") then
			timer.performWithDelay(100, doGameCompleted )
		end 
		
		if (event.object1.myName == "myGoal" and event.object2.myName == "Wheel") then
			timer.performWithDelay(100, doGameCompleted )
		end 


	elseif ( event.phase == "ended" and gameOverBool==false) then
	
		if (event.object1.myName == "Floor" and event.object2.myName == "Bike") then
			bikeOnFloor = true
			else
			bikeOnFloor = false
			print("Bike in Air")
		end	

		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision ended" )
	end
	
	
end

---------------------------------------------------------------------------------
-- Reset Game Location after death [Not used in this Template]
---------------------------------------------------------------------------------
local function resetPos()
	game.x = 0
	game.y = 0
end

----------------------------------------------------------------------------------------------
-- Lock the GAME.Group to the Bikes Central position - thus controlling the Camera..
----------------------------------------------------------------------------------------------
local function moveCamera()

	if (gameOverBool == false) then
		game.x = -(mainPlayerSprite.x)+100
	end
end


function bikeManager()

	if (bikeTiltLeft == true and levelCompleted == false and gameOverBool == false) then
		frontWheel:applyLinearImpulse(0, -3, frontWheel.x, frontWheel.y)
		rearWheel:applyLinearImpulse(0, 2, rearWheel.x, rearWheel.y)
		mainPlayerSprite.rotation = mainPlayerSprite.rotation - bikeTiltSpeed
		mainPlayerSprite:prepare("bikeDown")
		mainPlayerSprite:play()
	end
	
	if (bikeTiltRight == true and levelCompleted == false and gameOverBool == false) then
		rearWheel:applyLinearImpulse(0, -3, rearWheel.x, rearWheel.y)
		mainPlayerSprite.rotation = mainPlayerSprite.rotation + bikeTiltSpeed
	
		mainPlayerSprite:prepare("bikeUp")
		mainPlayerSprite:play()
	end
	
	if (levelCompleted == false and gameOverBool == false and bikeTiltRight == false and bikeTiltLeft == false) then
		--mainPlayerSprite:prepare("bikeIdle")
		--mainPlayerSprite:play()
		
		--Stabilise the MAXIMUM Speed of the Bike
		local vx, vy = mainPlayerSprite:getLinearVelocity()
		local m = math.sqrt((vx*vx)+(vy*vy))
		
		if (m>mainPlayerSprite.maxVelocity) then
				vx=(vx/m)*mainPlayerSprite.maxVelocity
				vy=(vy/m)*mainPlayerSprite.maxVelocity
				mainPlayerSprite:setLinearVelocity(vx,vy)
		end     

		if (bikeAccelerate == false and bikeReverse == false and bikeSpeed > 0) then
			bikeSpeed = bikeSpeed - (bikeAccelerateSpeed/2)
			rearWheelJoint.motorSpeed = bikeSpeed
			frontWheelJoint.motorSpeed = bikeSpeed
		elseif (bikeAccelerate == true) then
			bikeSpeed = rearWheelJoint.motorSpeed + bikeAccelerateSpeed
			rearWheelJoint.motorSpeed = bikeSpeed
			frontWheelJoint.motorSpeed = bikeSpeed
		elseif  (bikeReverse == true) then
			bikeSpeed = rearWheelJoint.motorSpeed - bikeAccelerateSpeed*1.2
			rearWheelJoint.motorSpeed = bikeSpeed
			frontWheelJoint.motorSpeed = bikeSpeed
		end
		
	end
end


function restartTouch(event)
	if(event.phase == "began") then
		nextLevel = "startScreen"
	elseif(event.phase == "ended") then
		timer.performWithDelay(10, gameOverFunctionEnd )
	end
end

function completedTouch(event)
	if(event.phase == "began") then
		-- Here you would RECORD the user has won the level
		-- And take them to the NEXT level.
		-- This template, simply returns the user back to the MAIN screen to start again.
		
		-- To implement a level select. You will need to.
		-- 1. Increment the LEVEL counter
		-- 2. Goto a Loading scene
		-- 3. Load THIS lua file back in;
		-- 4. Reset all of the variables in this file
		
		-- Set the LEVEL counter to PLUS 1 in your game to have the levels increment higher
		-- level = level + 1
		
		-- For the Template, we simply take the user back to the start screen....
		nextLevel = "startScreen"

		
	elseif(event.phase == "ended") then
		
		-- Perform the action when the user lifts their finger!
		timer.performWithDelay(10, gameOverFunctionEnd )
	end
end


function goTouch(event)
    print("Accelerate-Gas")
	if(event.phase == "began") then
		bikeAccelerate = true
	elseif(event.phase == "ended") then
		bikeAccelerate = false
	end
end

function brakeTouch(event)
    print("Reverse-Gas")
	if(event.phase == "began") then
		bikeReverse = true
	elseif(event.phase == "ended") then
		bikeReverse = false
	end
end


function leftTouch(event)
    print("Tilt-Left")
	if(event.phase == "began") then
		bikeTiltLeft = true
	elseif(event.phase == "ended") then
		bikeTiltLeft = false
		mainPlayerSprite:prepare("bikeIdle")
		mainPlayerSprite:play()
	end
end

function rightTouch(event)
    print("Tilt-Right")
	if(event.phase == "began") then
		bikeTiltRight = true
	elseif(event.phase == "ended") then
		bikeTiltRight = false
		mainPlayerSprite:prepare("bikeIdle")
		mainPlayerSprite:play()
  end

end


-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup

Runtime:addEventListener ( "collision", onGlobalCollision )
Runtime:addEventListener( "enterFrame", moveCamera )
Runtime:addEventListener( "enterFrame", bikeManager )

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene