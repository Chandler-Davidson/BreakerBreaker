local Cannon = require('classes.Cannon')
local Block = require('classes.Block')
local Ball = require('classes.Ball')
local BlockFactory = require('classes.BlockFactory'):new()
local Pickup = require('classes.Pickup')

local composer = require( "composer" )
 
local scene = composer.newScene()

local roundCount = 1 -- Track each wave's progression

-- Only allow a single shot on screen at a time
local ballFired = 0;		-- ammoCount at time of release (ammoCount changes w/ pickups)
local ballsReturned = 0		-- count of balls returned during shot

local pickups = {}

local function startNewWave(  )
	print( 'Starting Round: ' .. roundCount )
	timer.performWithDelay( 10, function (  )
		-- Short timer allows collision to end

		local blockCount

		if roundCount < 7 then
			blockCount = roundCount
		else
			blockCount = 7
		end

		BlockFactory:spawnBlocks(blockCount, roundCount)
		BlockFactory:moveBlocks()
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
		physics.addBody( bottomWall, 'static', { isSensor = false, filter = { categoryBits = 2, maskBits = 3 } } )
		bottomWall.tag = 'ballBounds'

		-- Collects all returning balls
		local function ballListener( event )
			if (event.other.tag == 'ball') then

				ballsReturned = ballsReturned + 1

				-- Ensures all are collected before play
				if (ballsReturned >= ballFired) then

					ballsReturned = 0
					Cannon:setReadyToFire( true );

					-- Create new blocks
					startNewWave()
				end

			elseif (event.other.tag == 'block') then
				-- Error here, not colliding with block
				print( '**GAME OVER**' )
				-- scene:gameOver()
			end
		end

		bottomWall:addEventListener( 'collision', ballListener)

	-- GAME OBJECTS --

		BlockFactory:spawn()
		
		startNewWave()

		Pickup:new( { pickupType = 'Shockwave', color = { 1, 0, 0 }, notification = 'BooM!'} ):spawn( self )

		-- Cannon is a singleton
		Cannon:spawn( scene )
		Cannon:setReadyToFire( true ) -- Enable fire
end


function scene:setShotsFired( shots )
	ballFired = shots
end


function scene:applyPickup( pickupType )
	print( '  Applied ' .. pickupType .. ' pickup' )

	-- Allows for implementation of alt pickups later
	-- Apply game logic on pickup's desc.
	if pickupType == 'Ball' then
		Cannon:addAmmo( 1 )

	elseif pickupType == 'Shockwave' then
		BlockFactory:hitAll(1)
		print('\tAll blocks hit for: 1')
	end
end
 

function scene:show( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
 
	elseif ( phase == "did" ) then
		Cannon:setListening( true ) -- Enable cannon
		Runtime:addEventListener( "accelerometer", function (  )
			composer.gotoScene( 'scenes.pause', { time = 300, effect = 'fade', params = { sceneFrom = self } } )
		end )
	end
end

 
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		Cannon:setListening( false ) -- Disable cannon
 
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