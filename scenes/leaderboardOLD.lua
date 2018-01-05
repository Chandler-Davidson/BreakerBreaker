local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local json = require("json")
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )


local scoresGroup
local newScore
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function loadScores()
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
 
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end

local function saveScores()
    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end
 
function scene:create( event )
 
	local sceneGroup = self.view

	newScore = event.params.score

	loadScores()

	-- BACKGROUND --
		local background = display.newRect(sceneGroup, 0, 0, 570, 600)
		background.fill = {
			type = 'gradient',
			color1 = { 0, 0, 0 },
			color2 = { 55/255, 60/255, 70/255 } 
		}
			
		background.x = display.contentWidth / 2
		background.y = display.contentHeight / 2


	-- Scene title
	local title = display.newText( {
		parent = sceneGroup,
		text = "Leaderboard",
		x = display.contentCenterX, y = 15,
		font = "kenvector_future_thin.ttf",
		fontSize = 35,
		} )

	-- Ease in title
	transition.from( title, { y = -150, time = 200, delay = 1500 } )

	-- Draw name + scores in table
	scoresGroup = display.newGroup( )
	scoresGroup.x, scoresGroup.y = display.contentCenterX, 50

	-- Draw dynamically
	for i = 1, 10 do
		local name = display.newText( {
			parent = scoresGroup,
			text = "name",
			x = -55, y = 35 * i,
			width = 180, align = 'left',
			font = "kenvector_future_thin.ttf",
			fontSize = 30,} )

		local score = display.newText( {
			parent = scoresGroup,
			text = "000",
			x = 120, y = 35 * i,
			width = 65, align = 'right',
			font = "kenvector_future_thin.ttf", 
			fontSize = 30,} )

		-- Ease in both
		transition.from( name, { y = -150, time = 200, delay = 100 * i } )
		transition.from( score, { y = -150, time = 200, delay = 100 * i } )
	end
end
 
 
function scene:show( event )
 
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then

		table.insert( scoresTable, { composer.getVariable( 'playerName' ), newHighScore } )

		-- Sort from high to low
		local function compare( a, b )
    		return a[2] > b[2]  -- Note ">" as the operator
		end
 
		table.sort( scoresTable, compare )

		saveScores()

		-- Change out displayObject's text from table
		local tCount = 1;
		for i = 1, #scoresTable * 2, 2 do
			scoresGroup[i].text = scoresTable[tCount][1]
			scoresGroup[i+1].text = scoresTable[tCount][2]
			tCount = tCount + 1
		end
 
	elseif ( phase == "did" ) then

		-- Possibly add blinking score

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