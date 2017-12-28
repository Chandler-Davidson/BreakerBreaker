local composer = require( "composer" )

local Cannon = require('classes.Cannon')
local Observer = require('classes.Observer'):new()
local Block = require('classes.Block')
local Ball = require('classes.Ball')
local Pickup = require('classes.Pickup')

local HUD = require('scenes.HUD')

local scene = composer.newScene()

local roundCount = 1 -- Track each wave's progression

-- Only allow a single shot on screen at a time
local ballsFired = 0;		-- ammoCount at time of release (ammoCount changes w/ pickups)
local ballsReturned = 0		-- count of balls returned during shot, onCollision with bottomWall

-- Function: startNewWave
-- Description: Called to start each round, updating blocks and incrementing the round
local function startNewWave(  )
	print( 'Starting Round: ' .. roundCount )

	HUD:newRound()

	timer.performWithDelay( 10, function (  )
		-- Short timer allows collision to end

		local blockCount 	-- Defines how many blocks to spawn

		if roundCount < 7 then
			blockCount = roundCount
		else
			-- Only 7 blocks will fit on screen
			blockCount = 7
		end

		Observer:spawnBlocks(blockCount, roundCount)
		Observer:moveBlocks()
		Observer:spawnPickup( "Ball" )

		roundCount = roundCount + 1
	end )	
end


-- Function: scene:create
-- Description: Called upon initialization of the scene.
--	Creates the enviroment and defines the enviroment's collision listener
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
		physics.addBody( bottomWall, 'static', { isSensor = false, filter = { categoryBits = 2, maskBits = 3 } } )
		bottomWall.tag = 'ballBounds'

		-- Collects all returning balls
		local function ballListener( event )
			if (event.other.tag == 'ball') then

				ballsReturned = ballsReturned + 1

				-- Ensures all are collected before play
				if (ballsReturned >= ballsFired) then

					ballsReturned = 0
					Cannon:setReadyToFire( true );

					-- Create new blocks
					startNewWave()
				end

			elseif (event.other.tag == 'block') then
				-- Error here, not colliding with block
				print( '**GAME OVER**' )
				scene:gameOver()
			end
		end

		bottomWall:addEventListener( 'collision', ballListener)

	-- GAME OBJECTS --
		-- Init the cannon
		Cannon:spawn( scene )
		Cannon:setReadyToFire( true ) -- Enable fire

		-- Init blockFactory
		Observer:spawn( scene )

		timer.performWithDelay( 10, function (  )
			startNewWave()
		end  )
end

function scene:gameOver(  )
	if (roundCount > composer.getVariable('highScore')) then
		composer.setVariable( 'highScore', roundCount )
	end

	composer.gotoScene( 'scenes.leaderboard', {time = 200, effect = 'slideRight', params = {score = roundCount}} )
end

-- Function: scene:setShotsFired
-- Description: Used as a link between Cannon and the scene,
-- 	probably needs to be removed
function scene:setShotsFired( shots )
	ballsFired = shots
end

-- Function: applyPickup
-- Description: Uses the pickup's properties to apply logic to the game
function scene:applyPickup( pickupType )
	print( '  Applied ' .. pickupType .. ' pickup' )

	-- Allows for implementation of alt pickups later
	-- Apply game logic on pickup's desc.
	if pickupType == 'Ball' then
		Cannon:addAmmo( 1 )

	elseif pickupType == 'Shockwave' then
		Observer:hitAll(1)
		print('\tAll blocks hit for: 1')
	end

	-- Clean up pickups
	Observer:refactor( Observer.pickups )
end
 
-- Function: scene:show
-- Description: Used to enable objects upon reentry
function scene:show( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.showOverlay( 'scenes.HUD' )

		Cannon:setListening( true ) -- Enable cannon
		Observer:setAlpha(1)
		Observer:setInPlay(true)
 
	elseif ( phase == "did" ) then
		Runtime:addEventListener( "accelerometer", function (  )
			composer.gotoScene( 'scenes.options', { time = 300, effect = 'fade', params = { sceneFrom = 'scenes.game' } } )
		end )
	end
end

-- Function: scene:hide
-- Description: Used to enable objects upon exit 
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		Cannon:setListening( false ) -- Disable cannon
 		Observer:setAlpha(0) 	-- Hide pickups and blocks
 		Observer:setInPlay( false )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
 
	end
end
 
-- Function: scene:destroy
-- Description: Used to remove objects upon exit
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