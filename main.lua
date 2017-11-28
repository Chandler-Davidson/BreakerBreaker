display.setStatusBar(display.HiddenStatusBar)

local composer = require('composer')

composer.gotoScene( 'scenes.game' )


-- TODO --

-- Game:
-- 	1. Move blocks after all balls are dead. Currently: Move block on shoot.
-- 	2. Difficulty needs to ramp. Currently: static
-- 	3. Combo counter???
-- 		1. Maybe balls grow stronger?
-- 	4. Check if ball is stuck
-- 		1. Occasionally check verticle movement

-- Pickups:
-- 	1. Pickups need to live outisde of blocks
-- 	2. New pickup ideas
-- 	3. Random pickup spawn times

-- Cannon:
-- 	1. Reticle and ball shot don't align perfectly
-- 	2. Canceling shots
-- 	3. Only draw reticle to first block