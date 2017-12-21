local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local scoresGroup
local newHighScore
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
	local sceneGroup = self.view

	newHighScore = event.params.score


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

		-- local names = load from memory
		local t = { {'chandler', 325}, {'megan', 25}, {'chris', 666}, {'carolyn', 2} }

		table.insert( t, { composer.getVariable( 'playerName' ), newHighScore } )

		-- Sort from high to low
		local function compare( a, b )
    		return a[2] > b[2]  -- Note ">" as the operator
		end
 
		table.sort( t, compare )

		-- Change out displayObject's text from table
		local tCount = 1;
		for i = 1, #t * 2, 2 do
			scoresGroup[i].text = t[tCount][1]
			scoresGroup[i+1].text = t[tCount][2]
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