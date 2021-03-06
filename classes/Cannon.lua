local Ball = require('Classes.Ball')

local Cannon = { }

local sceneLink 	-- Used to update the shotsFired

-- Cannon properties
local balls = {}
local velocityHolder = {}
local fireSpeed = require('composer').getVariable( 'ballSpeed' ) * -100
local ammoCount = 1			-- Track ammo available
local listening = false 	-- Is game scene visible?
local readyToFire = false 	-- Have all balls returned?

local reticleLine -- Var for common displayObj

local _CX = display.contentCenterX
local _CY = display.contentCenterY

-- Function: drawReticle
-- Description: Updates the reticle
local function drawReticle( x, y )
	-- Clean any prexisting reticle
	if reticleLine then
		 reticleLine:removeSelf( )
	end

	-- Draw a line from the 'cannon' to the cursor
	reticleLine = display.newLine( _CX, _CY + 250, x, y )
	reticleLine.strokeWidth = 5
end

-- Function: removeReticle
-- Description: Removes the drawn reticle
local function removeRecticle(  )
	reticleLine:removeSelf( )
	reticleLine = nil
end

-- Function: shoot
-- Description: Fires balls upon tap's location
function Cannon:shoot( x, y )
	-- Disable fire until next wave
	readyToFire = false

	-- Calculate shot's trajectory
	deltaX = _CX - x
	deltaY = _CY + 200 - y

	normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
	normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))

	if ( sceneLink ) then
		sceneLink:setShotsFired( ammoCount )
	end

	-- Loop through firiing each ball
	timer.performWithDelay( 200, function (  )
		local tempBall = Ball:new()
		tempBall:spawn( normDeltaX * fireSpeed, normDeltaY * fireSpeed )

		table.insert( balls, tempBall )
	end, ammoCount )
end

function Cannon:refactor( )
	local newT = {}

	if balls then
		for i=1,#balls do
			if balls[i] and balls[i].shape then
				table.insert( newT, balls[i] )
			end
		end

		balls = newT
	end
end

-- Function: Cannon:spawn
-- Description: Init obj
function Cannon:spawn( scene )
	sceneLink = scene

	Runtime:addEventListener( 'touch', function ( event )

		if ( listening and readyToFire ) then

			drawReticle( event.x, event.y )

			if event.phase == 'ended' then

				-- Calc distance of reticleLine
				local distance = math.sqrt( 
					math.pow( _CX - event.x, 2 ) + 
					math.pow( _CY + 250 - event.y, 2 ) )

				-- Allows cancelling shots
				if ( distance > 150 ) then
					self:shoot( event.x , event.y )
				end

				-- Clean reticle
				removeRecticle()

			end
		end

	end )
end

-- Function: Cannon:addAmmo
-- Description: Adds ammo to inventory
function Cannon:addAmmo( ammo )
	ammoCount = ammoCount + ammo
	print( '\tNew ammoCount: ' .. ammoCount )
end

function Cannon:getAmmo(  )
	return ammoCount
end

-- Function: setListening
-- Description: enable/disable cannon based upon game scene's current state
function Cannon:setListening( state )
	listening = state
	
	self:refactor()

	for i = 1, #balls do
		balls[i]:setActive( state )
	end
end

-- Function: setReadyToFire
-- Description: enable/disable cannon
function Cannon:setReadyToFire( state )
	readyToFire = state
end

return Cannon