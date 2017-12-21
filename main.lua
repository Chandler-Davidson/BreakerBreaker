display.setStatusBar(display.HiddenStatusBar)

local composer = require('composer')

-- Define initial game settings as globals --
composer.setVariable( 'playerName', 'PLAYER' )
composer.setVariable( 'ballSpeed', 5 )
audio.setVolume( 1 )
composer.setVariable( 'highScore', 5 )

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