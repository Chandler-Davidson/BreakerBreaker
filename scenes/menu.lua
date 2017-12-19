local composer = require('composer')
local scene = composer.newScene()
local widget = require('widget')

-- Display group used to clear text upon removal of scene
local textGroup
 
function scene:create( event )
	local sceneGroup = self.view

	-- Commonly used coordinates
	local _W, _H, _CX, _CY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

	-- Load Audio --
	local clickSound = audio.loadSound( 'sounds/kenney_uiaudio/Audio/click1.ogg' )

	-- BACGROUND --
	local background = display.newRect(sceneGroup, 0, 0, 570, 600)
	background.fill = {
		type = 'gradient',
		color1 = { 22/255, 110/255, 252/255 },
		color2 = { 135/255, 181/255, 255/255 } }
		
	background.x = _W / 2
	background.y = _H / 2

	-- TITLE --
	local titleGroup = display.newGroup()
	titleGroup.x, titleGroup.y = _CX, 50

	sceneGroup:insert( titleGroup )

	local title = display.newText( { 
		parent = titleGroup, 
		text = " Breaker Breaker", 
		font = "kenvector_future_thin.ttf", 
		fontSize = 30,
		align = 'center' } )

	local subtitle = display.newText( {
		parent = titleGroup,
		y = 50,
		text = "The greatest tennis game             ",
		font = "kenvector_future_thin.ttf", 
		fontSize = 15,
		align = 'center' } )

	local subsubtitle = display.newText( {
		parent = titleGroup,
		x = 113, y = 50,
		text = "ever.",
		font = "kenvector_future_thin.ttf", 
		fontSize = 15,
		align = 'center' } )

	-- Animate the title into place
	transition.from( title, {time = 500, delay = 1, y = 1000, transition = easing.outExpo} )
	transition.from( subtitle, {time = 500, delay = 2000, y = -500, transition = easing.outExpo} )
	transition.from( subsubtitle, {time = 500, delay = 4500, y = -500, transition = easing.outExpo} )

	-- CREDITS --
	-- List students' names
	local creditText = display.newText( {
		parent = titleGroup,
		parent = sceneGroup,  
		text = "Chandler Davidson\nAssets: Kenney.nl",
		x = 95, y = _H + 20, 
		font = "kenvector_future_thin.ttf", 
		fontSize = 15 } )

	-- Animate the credits into place
	transition.from( creditText, {time = 800, delay = 800, y = -200, transition = easing.outExpo} )

	-- PLAY BUTTON --
	-- Start the game, using a smooth transition
	self.playButton = widget.newButton( {
		parent = sceneGroup,
		defaultFile = 'uipack_fixed/PNG/blue_button04.png',
		overFile = 'uipack_fixed/PNG/blue_button02.png',
		width = 120, height = 60,
		x = _CX, y = _CY,
		label = ' Play!', labelAlign = 'center',
		font = 'kenvector_future_thin.ttf', fontSize = 20,
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			audio.play( clickSound )
			composer.gotoScene( 'scenes.game', {time = 200, effect = 'slideRight'} )
		end } )
	sceneGroup:insert( self.playButton )


	-- OPTIONS BUTTON
	-- Change settings, using a smooth transition
	self.optionsButton = widget.newButton( {
		parent = sceneGroup,
		defaultFile = 'uipack_fixed/PNG/blue_button04.png',
		overFile = 'uipack_fixed/PNG/blue_button02.png',
		width = 130, height = 60,
		x = _CX, y = _CY + 100,
		label = ' Options', labelAlign = 'center',
		font = 'kenvector_future_thin.ttf', fontSize = 20,
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = function ( )
			audio.play( clickSound )
			composer.gotoScene( 'scenes.options', {time = 500, effect = 'slideUp', params = { sceneFrom = 'scenes.menu' } })
		end } )
	sceneGroup:insert( self.optionsButton )
end

function scene:show( event )
 
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Called when the scene is still off screen (but is about to come on screen).
	elseif ( phase == "did" ) then
		-- Called when the scene is now on screen.
		-- Insert code here to make the scene come alive.
		-- Example: start timers, begin animation, play audio, etc.
	end
end
 
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Called when the scene is on screen (but is about to go off screen).
		-- Insert code here to "pause" the scene.
		-- Example: stop timers, stop animation, stop audio, etc.
	elseif ( phase == "did" ) then
		-- Called immediately after scene goes off screen.
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	titleGroup:removeSelf()
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene