------------------------------------------------------------------------------------------------------------------------------------
-- MotoX Corona Template
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http:www.deepbueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
--
-- resetMe.lua
--
-- 23rd December 2018
-- Version 4.0
-- Requires Corona 2018.3326
------------------------------------------------------------------------------------------------------------------------------------

local storyboard 		= require "storyboard"
local scene = storyboard.newScene()

print("RESET SCENE")

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view


	function startGame()
		storyboard.gotoScene( "mainGameInterface")	--This is our main menu
	end

	--Start Game after a short delay.
	timer.performWithDelay(1000, startGame )


end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

	
	print("from resetMe: ")
	storyboard.removeScene( "mainGameInterface" )
	storyboard.purgeScene( "mainGameInterface" )

	storyboard.removeAll()
	storyboard.purgeAll()
	
	
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene