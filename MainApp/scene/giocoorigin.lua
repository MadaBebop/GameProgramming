-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require('physics')
local zombie = require('scene.zombie')
local xeon = require('scene.xeon')

physics.setDrawMode("hybrid")
physics.start()

--creazione della piattaforma
local platform = display.newRect(0, display.contentHeight - 10, 3840, 20)
physics.addBody(platform, "static", {bounce = 0, friction = 0.5})

-- pulsanti temporanei per testare movimento e salto
local button = display.newRect(560,display.contentCenterY,50,50)
local jump = display.newRect(750,display.contentCenterY,50,50)

--creazione dello zombie + movimento + ronda
local enemy = zombie.new()
zombie.initialize(enemy, 400, 200)
zombie.movement(enemy, 130, 300, 600)

-- creazione personaggio + funzione per movimento + funzione salto
local hero = xeon.new()
xeon.create(hero, 700, 700)

local function xeonMove(event)
    xeon.moveXeon(hero, event)
end

local function xeonJump(event)
    xeon.jumpXeon(hero, event)
end



button:addEventListener("touch", xeonMove)
jump:addEventListener("tap", xeonJump)
