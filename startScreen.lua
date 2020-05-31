------------------------------------------------------------------------------------------------------------------------------------
-- MotoX Corona Template
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http:www.deepbueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
--
-- startScreen.lua
--
-- 23rd December 2018
-- Version 4.0
-- Requires Corona 2018.3326
------------------------------------------------------------------------------------------------------------------------------------

local composer 			= require( "composer" )
local scene 			= composer.newScene()

local widget 			= require "widget"

local buttonGroup 			= display.newGroup()
local logoGroup 			= display.newGroup()
local highlightGroup 		= display.newGroup()
local highlightSpeed		= 20

local image
local highlight
local infoButton
local dbaLogo
local imageLogo
local imageLogoX
local imageBike
local templateInfo

local crowdScream

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
	
	-- level select button function
	local function levelSelect()
			doDebugPhysics = false
			composer.gotoScene( "mainGameInterface", "fade", 400  )
			return true
	end

	----------------------------------------------------------------------------------------------------
	-- Setup the Background Image
	----------------------------------------------------------------------------------------------------
	image = display.newImage( imagePath.."background.png" )
	image.x = _w/2
	image.y = _h/2
	--transition.to(image, {alpha=1.0, time=500})
	sceneGroup:insert( image )
	image.alpha = 0.3
	
	----------------------------------------------------------------------------------------------------
	-- Setup the Highlight bar
	----------------------------------------------------------------------------------------------------
	highlight = display.newImage( imagePath.."highlight.png" )
	highlight.x = _w+200
	highlight.y = _h/2
	highlight.alpha = 1.0
	highlight.rotation = -55
	highlightGroup:insert( highlight )
	sceneGroup:insert( highlightGroup )
	
	----------------------------------------------------------------------------------------------------
	-- Setup the start game button
	----------------------------------------------------------------------------------------------------
	infoButton = widget.newButton{
		left 	= _w-186,
		top 	= _h-120,
		defaultFile = imagePath.."buttonStartOff.png",
		overFile 	= imagePath.."buttonStartOn.png",
		onRelease = levelSelect,
		}			
	buttonGroup:insert( infoButton )
	--Insert the Info Group Layer into the Main Layer
	sceneGroup:insert( buttonGroup )

	
	----------------------------------------------------------------------------------------------------
	-- Setup the Logo - with Bounce in effect
	----------------------------------------------------------------------------------------------------
	dbaLogo = display.newImage( imagePath.."introDBI.png" )
	dbaLogo.x = (_w/2)-120
	dbaLogo.y = -196
	logoGroup:insert( dbaLogo )

	imageLogo = display.newImage( imagePath.."introMoto.png" )
	imageLogo.x = (_w/2)-40
	imageLogo.y = -117
	logoGroup:insert( imageLogo )

	imageLogoX = display.newImage( imagePath.."introX.png" )
	imageLogoX.x = (_w/2)
	imageLogoX.y = -100
	imageLogoX:scale(6.0,6.0)
	imageLogoX.alpha = 0.0
	logoGroup:insert( imageLogoX )

	imageBike = display.newImage( imagePath.."introBike.png" )
	imageBike.x = (_w/2)-350
	imageBike.y = 220
	sceneGroup:insert( imageBike )

	templateInfo = display.newImage( imagePath.."introInfoText.png" )
	templateInfo.x = (_w/2)
	templateInfo.y = 285
	templateInfo:scale(1.0,0.1)
	templateInfo.alpha = 0.0
	sceneGroup:insert( templateInfo )

	local function bounceUp()
		logoGroup.t1 = transition.to(logoGroup, {y=230, time=150}) 												-- Bounce the logo back up a little
		templateInfo.t2 = transition.to(templateInfo, {alpha=1.0, yScale=1.0, time=500})								-- Flip in the Template info details
		highlight.t3 = transition.to(highlight, {alpha=0.0,xScale=4.0, yScale=4.0, x=0, time=1800})				-- Swipe the Highlight across the screen	
		imageLogoX.t4 = transition.to(imageLogoX, {xScale=1.0, yScale=1.0, alpha=1.0, x=(_w/2)+90, time=900})		-- Scale down the [ X ] logo...
		crowdScream = audio.play(crowdSFX, {channel=3})
	end
	
	local function bounceBack()
		imageBike.bounceBack = transition.to(imageBike, {x=(_w/2)-150, time=100})
	end
	
	logoGroup.trans1 = transition.to(logoGroup, {y=270, time=350, onComplete=bounceUp})					-- Animate the intro Logo..
	imageBike.trans1 = transition.to(imageBike, {x=(_w/2)-100, time=350, onComplete=bounceBack})			-- Animate the Bike in the intro
	sceneGroup:insert( logoGroup )
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


		print("from startScreen: ")
		composer.removeScene( "mainGameInterface" )

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
	
	audio.stop(crowdScream)
	crowdScream = nil

	-- Cancel any transitions...
	if ( imageBike.bounceBack ) then
	   transition.cancel( imageBike.bounceBack )
	   imageBike.bounceBack = nil
	end

	if ( imageBike.trans1 ) then
	   transition.cancel( imageBike.trans1 )
	   imageBike.trans1 = nil
	end

	if ( logoGroup.trans1 ) then
	   transition.cancel( logoGroup.trans1 )
	   logoGroup.trans1 = nil
	end

	if ( logoGroup.t1 ) then
	   transition.cancel( logoGroup.t1 )
	   logoGroup.t1 = nil
	end

	if ( templateInfo.t2 ) then
	   transition.cancel( templateInfo.t2 )
	   templateInfo.t2 = nil
	end

	if ( highlight.t3 ) then
	   transition.cancel( highlight.t3 )
	   highlight.t3 = nil
	end
	
	if ( imageLogoX.t4 ) then
	   transition.cancel( imageLogoX.t4 )
	   imageLogoX.t4 = nil
	end
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
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
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
