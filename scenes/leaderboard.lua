local widget = require('widget')
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )


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


local function saveScores( lastScore )

	if ( lastScore > scoresTable[1] ) then
		scoresTable[1] = lastScore

		local file = io.open( filePath, "w" )

		if file then
			file:write( json.encode( scoresTable ) )
			io.close( file )
		end

		-- Return true that the new score was accepted
		return true
	end

	return false
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view

    -- Load the previous scores
    loadScores()

    -- Save the new score, store if the score is >
    local newScore = saveScores( event.params.score )

    local clickSound = audio.loadSound( 'sounds/kenney_uiaudio/Audio/click1.ogg' )
	local switchSound = audio.loadSound( 'sounds/kenney_uiaudio/Audio/switch1.ogg' )

	-- Commonly used coordinates
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	-- BACKGROUND --
		-- Scene Background --
		local background = display.newRect(sceneGroup, 0, 0, 570, 600)
		background.fill = {
			type = 'gradient',
			color1 = { 8/255, 158/255, 0/255 },
			color2 = { 104/255, 183/255, 95/255 } }

		background.x = _W / 2
		background.y = _H / 2

		-- Menu Background --
		local menuBackground = display.newRoundedRect(sceneGroup, 0, 0, 250, 350, 12)
		menuBackground:setFillColor( .9 )
		menuBackground.strokeWidth = 2
		menuBackground:setStrokeColor( 0.7 )
		menuBackground.x = _W / 2
		menuBackground.y = _H / 2 +20

	-- TITLE --
	local title = display.newText( { 
		parent = sceneGroup,
		x = _CX, y = 50,
		text = "Game Over", 
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		align = 'center'} )

	local newScoreText = display.newText( { 
		parent = sceneGroup,
		x = _CX + 3, y = 130,
		width = display.contentWidth,
		text = event.params.score, 
		font = "kenvector_future_thin.ttf", 
		fontSize = 50,
		align = 'center'} )

	local bestText = display.newText( { 
		parent = sceneGroup,
		x = _CX, y = 180,
		text = "Best: " .. scoresTable[1], 
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		align = 'center'} )

	-- EXIT BUTTONS --
		-- Accept Button --
		local acceptButton = widget.newButton( {
			defaultFile = 'uipack_fixed/PNG/green_button01.png',
			overFile = 'uipack_fixed/PNG/green_button02.png',
			label = '  Play Again', labelColor = { default = {1, 1, 1} },
			font = 'kenvector_future_thin.ttf',
			width = 150, height = 40,
			x = 195, y = _H -90,
			onRelease = function ( )
				audio.play( clickSound )

				-- Return to the appropriate scene
				composer.gotoScene( 'scenes.game', { time = 200, effect = 'slideRight' } )

			end } )
			sceneGroup:insert( acceptButton )

		-- Back Button --
		local backButton = widget.newButton( {
			defaultFile = 'uipack_fixed/PNG/green_boxCross.png',
			width = 40, height = 40,
			x = 70, y = _H -90,
			onRelease = function ( )
				audio.play( clickSound )
				
				-- Return to the appropriate scene
				composer.gotoScene( 'scenes.menu', { time = 200, effect = 'slideRight' } )
			end } )
			sceneGroup:insert( backButton )

		-- Donate Button --
		local donateButton = widget.newButton( {
			defaultFile = 'uipack_fixed/PNG/blue_button01.png',
			overFile = 'uipack_fixed/PNG/blue_button02.png',
			label = '  Donate', labelColor = { default = {1, 1, 1} },
			font = 'kenvector_future_thin.ttf',
			width = 150, height = 40,
			x = _CX, y = _H - 190,
			onRelease = function ( )
				audio.play( clickSound )
				
				-- Return to the appropriate scene
				system.openURL( "http://www.chandlerdavidson.com" )
			end } )
			sceneGroup:insert( donateButton )
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
		composer.removeScene( "highscores" )
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
