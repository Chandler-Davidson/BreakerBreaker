local Block = require('classes.Block')
local Ball = require('classes.Ball')

local composer = require( "composer" )
 
local scene = composer.newScene()

-- create()
function scene:create( event )
	local sceneGroup = self.view

	-- Commonly used coordinates
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY


	-- ENVIROMENT -- 
		-- Walls --
		local leftWall = display.newRect( sceneGroup, -5, _CY, 10, _H )
		local rightWall = display.newRect( sceneGroup, _W + 5, _CY, 10, _H )
		local topWall = display.newRect( sceneGroup, _CX, -50, _W, 10 )
		local bottomWall = display.newRect( sceneGroup, _CX, _H + 70, _W, 10 )

		physics.addBody( leftWall, 'static', { bounce = 1 } )
		physics.addBody( rightWall, 'static', { bounce = 1 } )
		physics.addBody( topWall, 'static', { bounce = 1 } )
		physics.addBody( bottomWall, 'static', { isSensor = true } )
		bottomWall.tag = 'ballBounds'
 
	local block1 = Block:new()
	block1:spawn()

	block1:move()

	balls = {}
	count = 1

	timer.performWithDelay( 500, function (  )
			table.insert(balls,  Ball:new())
			balls[count]:spawn()
			count = count + 1
	end, 7 )


end
 
 
-- show()
function scene:show( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
 
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