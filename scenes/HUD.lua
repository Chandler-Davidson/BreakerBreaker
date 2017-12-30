local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local highScore = composer.getVariable( 'highScore' )
local roundCount
print( '1' )
local bestCounter
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY
 
	local sceneGroup = self.view

	print( '2' )

	roundCount = display.newText( {
		parent = sceneGroup,
		text = '0',
		x = _W - 10, y = -15,
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		} )

	bestCounter = display.newText( {
		parent = sceneGroup,
		text = "Best:  " .. highScore,
		x = 70, y = -15,
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		} )
end

function scene:newRound(  )

	if roundCount.text then
		roundCount.text = roundCount.text + 1

		if tonumber(roundCount.text) > highScore then
			bestCounter.text = "Best: " .. roundCount.text
		end
	end
end
 
 
-- show()
function scene:show( event )
	print( '4' )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		roundCount.text = event.params.currentRound
 
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
 
	end
end
 
 
-- hide()
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
 
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
 
	end
end
 
 
-- destroy()
function scene:destroy( event )
 
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene