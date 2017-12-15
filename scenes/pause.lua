composer = require('composer')
local scene = composer.newScene()
local widget = require('widget')

-- Display group used to clear text upon removal of scene
local textGroup
 
function scene:create( event )
	local sceneGroup = self.view

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
			text = "Options", 
			font = "kenvector_future_thin.ttf", 
			fontSize = 30,
			align = 'center'} )

	-- CONTROLS --
		-- Name Text Field --
		self.nameField = native.newTextField( 90, 100, 100, 30 )
			sceneGroup:insert(self.nameField)
			self.nameField.align = "center"
			self.nameField.font = native.newFont( 'kenvector_future_thin.ttf', 20 )
			self.nameField:setTextColor( .8 )
			self.nameField.inputType = 'no-emoji' -- Only allow text
			self.nameField.width = 150
			self.nameField.x = _CX + 30
			self.nameField.y = 120
			self.nameField.placeholder = "Player"

			self.nameField:addEventListener( "userInput", function ( event )
				if event.phase == 'began' then
					self.nameField.text = '' -- Clear the field upon editing
				end
			end )


			-- Labels --
			local nameFieldBackground = display.newRoundedRect( sceneGroup, _CX + 30, 120, 155, 35, 5 )
			nameFieldBackground:setFillColor( .8 ) -- Acts as a stroke width

			local textFieldLabel = display.newText( { 
				parent = sceneGroup, 
				text = "Name", 
				font = "kenvector_future_thin.ttf", 
				fontSize = 15,
				x = _CX - 90,
				y = 120,
				align = 'center'} )

			-- Assign Label Colors --
		  	textFieldLabel:setFillColor(.5, .5, .5)

		-- Sound Control --
 		self.audioSwitch = widget.newSwitch( {
	        left = _CX - 70,
	        top = 190,
	        style = "onOff",
	        id = "self.audioSwitch",
	        initialSwitchState = true,
	        onPress = function (  )
	        	audio.play( switchSound )
	        end } )

			sceneGroup:insert(self.audioSwitch)

			-- Labels --
			local soundLabel = display.newText( { 
				parent = sceneGroup, 
				text = "Sound", 
				font = "kenvector_future_thin.ttf", 
				fontSize = 15,
				x = _CX - 85,
				y = 170,
				align = 'center' } )

			local soundOnLabel = display.newText( { 
				parent = sceneGroup, 
				text = "ON", 
				font = "kenvector_future_thin.ttf", 
				fontSize = 10,
				x = _CX + 1,
				y = 205,
				align = 'center' } )

	      	local soundOffLabel = display.newText( { 
				parent = sceneGroup, 
				text = "OFF", 
				font = "kenvector_future_thin.ttf", 
				fontSize = 10,
				x = _CX - 95,
				y = 205,
				align = 'center' } )

	      	-- Assign Label Colors --
	      	soundLabel:setFillColor(.5, .5, .5)
		  	soundOnLabel:setFillColor(.5, .5, .5)
		  	soundOffLabel:setFillColor(.5, .5, .5)

		-- Sensitivity Slider --
			sliderCurrentValue = display.newText( sceneGroup, '5', display.contentCenterX + 2, display.contentCenterY + 90, 'kenvector_future_thin.ttf', 20 )
			sliderCurrentValue:setFillColor(.5, .5, .5)

			local sliderOptions = 
			{
				frames = 
				{
					{	-- Slider Handle Up
						x = 190,
           				y = 276,
			            width = 28,
			            height = 42
        			},

        			-- Slider Bar Horizontal
					{
						x = 0,
           				y = 380,
			            width = 190,
			            height = 4
        			},

        			-- Slider End Circles
					{
						x = 138,
           				y = 478,
			            width = 8,
			            height = 10
        			},
				}
			}

			local sliderSheet = graphics.newImageSheet( "uipack_fixed/Spritesheet/greySheet.png", sliderOptions )

		 	self.slider = widget.newSlider( {
			 	sheet = sliderSheet,
			 	middleFrame = 2, frameWidth = 5, frameHeight = 5, fillFrame = 2,
			 	handleFrame = 1, handleWidth = 18, handleHeight = 27,
		        x = display.contentCenterX,
		        y = display.contentCenterY +60,
		        orientation = "horizontal",
		        height = 200,
		        value = 50,  -- Start slider at 50% (optional)
		        listener = function (  )
		        	if self.slider.value <= 10 then
		        		self.slider.value = 10
		        	end

		        	sliderCurrentValue.text = math.floor( self.slider.value / 10 )
		        end } )
			sceneGroup:insert( self.slider )

			-- Labels --
	  		local sensitivityLabel = display.newText( { 
				parent = sceneGroup, 
				text = "Sensitivity", 
				font = "kenvector_future_thin.ttf", 
				fontSize = 15,
				x = _CX - 65,
				y = 260,
				align = 'center' } )

	  		local sliderLabelLow = display.newText( { 
				parent = sceneGroup, 
				text = "0", 
				font = "kenvector_future_thin.ttf", 
				fontSize = 15,
				x = _CX - 95,
				y = 330,
				align = 'center' } )

	    	local sliderLabelHigh = display.newText( { 
				parent = sceneGroup, 
				text = "10", 
				font = "kenvector_future_thin.ttf", 
				fontSize = 15,
				x = _CX + 100,
				y = 330,
				align = 'center' } )

    		-- Assign Label Colors --
		  	sensitivityLabel:setFillColor(.5, .5, .5)
		  	sliderLabelLow:setFillColor(.5, .5, .5)
	  		sliderLabelHigh:setFillColor(.5, .5, .5)

	-- EXIT BUTTONS --
		-- Accept Button --
		local acceptButton = widget.newButton( {
			defaultFile = 'uipack_fixed/PNG/green_button01.png',
			overFile = 'uipack_fixed/PNG/green_button02.png',
			label = '  Accept', labelColor = { default = {1, 1, 1} },
			font = 'kenvector_future_thin.ttf',
			width = 150, height = 40,
			x = 195, y = _H -90,
			onRelease = function ( )
				print('Changes accepted')

				audio.play( clickSound )

				-- Set all of the game settings
				composer.setVariable( 'playerName', string.upper( self.nameField.text ) )
				audio.setVolume( self.audioSwitch.isOn and 1 or 0 )
				composer.setVariable( 'playerSensitivity', math.floor (self.slider.value / 10))

				-- Return to the appropriate scene
				if event.params.sceneFrom then
					-- In pause menu
					composer.gotoScene( 'scenes.game', { time = 200, effect = 'slideRight' } )
				else
					-- In main menu
					composer.gotoScene( 'scenes.menu', { time = 200, effect = 'slideRight' } )
				end

			end } )
			sceneGroup:insert( acceptButton )

		-- Back Button --
		self.backButton = widget.newButton( {
			defaultFile = 'uipack_fixed/PNG/green_boxCross.png',
			width = 40, height = 40,
			x = 70, y = _H -90,
			onRelease = function ( )
				print('Changes removed')

				audio.play( clickSound )
				
				if event.params.sceneFrom then
					composer.gotoScene( 'scenes.game', { time = 200, effect = 'slideRight' } )
				else
					composer.gotoScene( 'scenes.menu', { time = 200, effect = 'slideRight' } )
				end		
			end } )
			sceneGroup:insert( self.backButton )
end

function scene:show( event )
 
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then

		-- Fill in fields from memory
		self.slider.value = composer.getVariable( 'playerSensitivity' ) * 10
		self.nameField.text = composer.getVariable( 'playerName' )
		self.audioSwitch.value = audio.getVolume( ) == 0 and false or true
	
	end
end
 
function scene:hide( event )
 
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene