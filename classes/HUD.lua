local composer = require('composer')

local HUD = {}

local json = require( "json" )
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local sceneGroup = display.newGroup( )
local highScore
local roundCount
local bestCounter
local ammoCounter

local function loadScores()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0 }
	end
end

function HUD:spawn(  )
	loadScores()

	highScore = scoresTable[1]

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

	ammoCounter = display.newText( {
		parent = sceneGroup,
		text = "Ammo: 1",
		x = _W - 50, y = _H,
		font = "kenvector_future_thin.ttf",
		fontSize = 20
		} )
end

function HUD:newRound(  )
	roundCount.text = roundCount.text + 1

	if (tonumber( roundCount.text ) > highScore) then
		bestCounter.text = "Best: " .. roundCount.text
	end
end

function HUD:setAmmo( a )
	ammoCounter.text = "Ammo: " .. a
end

function HUD:setActive( a )
	roundCount.alpha = a
	bestCounter.alpha = a
	ammoCounter.alpha = a
end

function HUD:remove(  )
	roundCount:removeSelf( )
	bestCounter:removeSelf( )
	self = nil
end

return HUD