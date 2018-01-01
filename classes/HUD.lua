local composer = require('composer')

local HUD = {}

local sceneGroup = display.newGroup( )
local highScore = composer.getVariable( 'highScore' )
local roundCount
local bestCounter

function HUD:spawn(  )
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	roundCount = display.newText( {
		parent = sceneGroup,
		text = '0',
		x = _W - 20, y = -15,
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		} )

	bestCounter = display.newText( {
		parent = sceneGroup,
		text = "Best:  " .. highScore,
		x = 75, y = -15,
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		} )
end

function HUD:newRound(  )
	roundCount.text = roundCount.text + 1

	if (tonumber( roundCount.text ) > highScore) then
		bestCounter.text = "Best: " .. roundCount.text
	end
end

function HUD:setActive( a )
	roundCount.alpha = a
	bestCounter.alpha = a
end

function HUD:remove(  )
	roundCount:removeSelf( )
	bestCounter:removeSelf( )
	self = nil
end

return HUD