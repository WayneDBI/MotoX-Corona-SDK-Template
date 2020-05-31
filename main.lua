------------------------------------------------------------------------------------------------------------------------------------
-- MotoX Corona Template
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http:www.deepbueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
--
-- main.lua
--
-- 23rd December 2018
-- Version 4.0
-- Requires Corona 2018.3326
------------------------------------------------------------------------------------------------------------------------------------


display.setStatusBar( display.HiddenStatusBar )

-- require controller module
local composer 			= require( "composer" )
local physics 			= require( "physics" )

_G.sprite = require "sprite"							-- Add SPRITE API for Graphics 1.0

_G._w 					= display.contentWidth  		-- Get the devices Width
_G._h 					= display.contentHeight 		-- Get the devices Height
_G.gameScore			= 0								-- The Users score
_G.highScore			= 0								-- Saved HighScore value
_G.numberOfLevels		= 3								-- How many levels does the game have?
_G.levelsUnlocked		= 1								-- How many levels has the user unlocked?
_G.sfxVolume			= 1								-- Default SFX Volume
_G.musicVolume			= 0.3							-- Default Music Volume
_G.imagePath			= "assets/images/"
_G.audioPath			= "assets/audio/"
_G.level				= 1								-- Global Level Select, Clean, Load, etc...
_G.doDebugPhysics		= true

-- Enable debug by setting to [true] to see FPS and Memory usage.
local doDebug 			= false


-- Debug Data
if (doDebug) then
	local fps = require("fps")
	local performance = fps.PerformanceOutput.new();
	performance.group.x, performance.group.y = display.contentWidth/2,  270;
	performance.alpha = 0.3; -- So it doesn't get in the way of the rest of the scene
end


audio.setVolume( musicVolume )

function startGame()
	composer.gotoScene( "startScreen")	--This is our main menu
end


--Define some globally loaded assets
bgMusic			= audio.loadSound( audioPath.."RaceLoop.mp3" )	-- channel 1
bikeCrash		= audio.loadSound( audioPath.."CarHit2.mp3" ) 	-- channel 2
crowdSFX 		= audio.loadSound( audioPath.."Crowd.mp3" ) 	-- channel 3


spriteSheetGroup = sprite.newSpriteSheetFromData( imagePath.."SpriteSheetMotoX.png", require("SpriteSheetMotoX").getSpriteSheetData() )


--Start Game after a short delay.
timer.performWithDelay(10, startGame )
