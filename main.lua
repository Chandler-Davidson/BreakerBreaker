display.setStatusBar(display.HiddenStatusBar)

local composer = require('composer')

local json = require('json')
local settingsTable = {}
local scoreTable = {}

-- Load json table from memory
local function loadFromFile( path )	
	local filePath = system.pathForFile( path, system.DocumentsDirectory )
	local file = io.open( filePath, 'r' )

	if file then
		local contents = file:read( '*a' )
		io.close( file )

		return json.decode( contents )
	end

	return {}
end

-- Check if files exist, otherwise fill in as default
local function checkFile(  )
	if ( settingsTable == nil or #settingsTable == 0 ) then
		settingsTable = { "PLAYER", 1, 5 }
	end

	if ( scoreTable == nil or #scoreTable == 0 ) then
		scoreTable = { 0 }
	end
end

-- Check if files are valid
checkFile()

-- Load settings and scores
settingsTable = loadFromFile( "settings.json" )
scoreTable = loadFromFile( "scores.json" )

-- Define game settings as globals --
composer.setVariable( 'playerName', settingsTable[1] )
audio.setVolume( settingsTable[2] )
composer.setVariable( 'ballSpeed', settingsTable[3] )
composer.setVariable( 'highScore', scoreTable[1] )

composer.gotoScene( 'scenes.menu' )


-- TODO --

-- Game:
-- 	1. Difficulty ramping is not fun, needs to be smarter
-- 		1. Maybe have a set amount of points needed for each wave, then
--		   split those points across a random # of blocks
-- 	3. Combo counter???
-- 		1. Attach a counter to the ball?
-- 		2. Maybe balls grow stronger?
-- 	4. Occasionally check verticle movement, balls can take forever moving horizontally
-- 	5. Highscore

-- Pickups:
-- 	1. Pickups can spawn inside blocks and are removed if they are
-- 	2. New pickup ideas
-- 		Currently:
--			1. Add ammo
--			2. Hit all blocks (shockwave)

-- Cannon:
-- 	1. Reticle not cute, visual rework
-- 	2. Visual cue for canceling shots

-- UI:
-- 	1. Needs?
-- 	2. Design?

-- Look and Feel:
-- 1. Needs?

-- Menu:
-- 1. Main menu
--  	1. Credits
-- 2. Store?
-- 3. Facebook/Twitter?