local Block = require('classes.Block')
local Ball = require('classes.Ball')
local BlockFactory = require('classes.BlockFactory')
local Pickup = require('classes.Pickup')

local composer = require( "composer" )
 
local scene = composer.newScene()

local roundCount = 1

-- Count of shots in player's inventory
local ammoCount = 1

-- Only allow a single shot on screen at a time
local ballFired = 0;		-- ammoCount at time of release (ammoCount changes w/ pickups)
local ballsReturned = 0		-- count of balls returned during shot
local readyToFire = true 	-- is cannon ready to fire again?

local function startNewWave(  )
	print( 'Starting Round: ' .. roundCount )
	timer.performWithDelay( 10, function (  )
		-- Short timer allows collision to end

		local blockCount

		if roundCount > 7 then
			blockCount = 7
		end

		blockFactory:spawnBlocks(roundCount, roundCount)
		blockFactory:moveBlocks()
		Pickup:new():spawn( scene )

		roundCount = roundCount + 1
	end )	
end

function scene:create( event )
	local sceneGroup = self.view

	-- Commonly used coordinates
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY


	-- ENVIROMENT --
		-- Walls --
		local leftWall = display.newRect( sceneGroup, -5, _CY, 10, _H + 100 )
		local rightWall = display.newRect( sceneGroup, _W + 5, _CY, 10, _H + 100 )
		local topWall = display.newRect( sceneGroup, _CX, -50, _W, 10 )
		local bottomWall = display.newRect( sceneGroup, _CX, _H + 70, _W, 10 )

		physics.addBody( leftWall, 'static', { bounce = 1, filter = { categoryBits = 2, maskBits = 1 } } )
		physics.addBody( rightWall, 'static', { bounce = 1, filter = { categoryBits = 2, maskBits = 1 } } )
		physics.addBody( topWall, 'static', { bounce = 1, filter = { categoryBits = 2, maskBits = 1 } } )
		physics.addBody( bottomWall, 'static', { isSensor = false, filter = { categoryBits = 2, maskBits = 1 } } )
		bottomWall.tag = 'ballBounds'

		local function ballListener( event )
			if (event.other.tag == 'ball') then

				ballsReturned = ballsReturned + 1

				if (ballsReturned >= ballFired) then

					ballsReturned = 0
					readyToFire = true;

					startNewWave()
				end
			end
		end

		bottomWall:addEventListener( 'collision', ballListener)

	-- GAME OBJECTS --

		blockFactory = BlockFactory:new()
		blockFactory:spawn()
		blockFactory:spawnBlocks(4, roundCount)
		blockFactory:moveBlocks()

		Pickup:new():spawn( self )


		local reticleLine

		local function shoot( event )

			if reticleLine then
				reticleLine:removeSelf( )
			end

			reticleLine = display.newLine( _CX, _CY + 250, event.x, event.y )


			if event.phase == 'began' then

			elseif event.phase == 'ended' then
				
				readyToFire = false

				deltaX = _CX - event.x
				deltaY = _CY + 200 - event.y


				normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
				normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
				local speed = -500

				ballFired = ammoCount

				timer.performWithDelay( 200, function (  )
					local tempBall = Ball:new()
					tempBall:spawn( normDeltaX * speed, normDeltaY * speed )
				end, ammoCount )

				reticleLine:removeSelf( )
				reticleLine = nil 
			end
		end

		Runtime:addEventListener( 'touch', function ( event )

			if (readyToFire) then
				shoot( event );
			end

		end )
end

function scene:applyPickup( pickupType )
	print( '  Applied ' .. pickupType .. ' pickup' )

	if pickupType == 'Ball' then
		ammoCount = ammoCount + 1
		print( '\tNew ammoCount: ' .. ammoCount )
	end
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

 
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
 
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
 
	end
end
 
 
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