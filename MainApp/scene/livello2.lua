------------------
--- LIBRERIE
------------------
local composer = require "composer"
local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"
local robot = require 'game.hero.robot'
----------------
--- Variabili
----------------

local map, hero, siringe -- variabili della mappa, eroe e siringa
-- Limiti della mappa
local mapLimitLeft = 0
local mapLimitRight = 960

-- Create a new Composer scene
local scene = composer.newScene()
local sceneGroup

---------
--iniio CREATE
---------
function scene:create( event )

	sceneGroup = self.view  -- Add scene display objects to this group
	sceneGroup.anchorX = 0
	sceneGroup.anchorY = 0
	sceneGroup.anchorChildren = true

	physics.start()
	physics.setDrawMode("normal")
	physics.pause()
	physics.setGravity( 0, 32 )

	-- Inserisco nella variabile mappa i dati inerenti alla mappa .json
	local filename = 'scene/maps/lvl2/livello2.json'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, "scene/maps/lvl2")

	map.anchorX = 0
	map.anchorY = 0

	-- Eroe
	hero = robot.createRobot()
	hero.x = 200
	hero.y = 200

	-- Siringe
	siringe = display.newImage('scene/maps/lvl2/siringe.png')
	physics.addBody(siringe, 'static')


	-- Insert our game items in the correct back-to-front order
	sceneGroup:insert( map )
	sceneGroup:insert( hero )
	sceneGroup:insert( siringe )
end -- fine del create

---------------
-- fine CREATE
---------------

--------------------------------
-- CAMERA SCROLL
--------------------------------
local function moveCamera (event)
	local offsetX = 100
	local heroWidth = hero.width
	local displayLeft = -sceneGroup.x
	-- local nonScrollingWidth = display.contentWidth - offsetX momentaneamente lo commento
	local nonScroll = display.contentWidth - heroWidth

	if (hero.x >= mapLimitLeft + heroWidth and hero.x <= mapLimitRight - heroWidth) then
		if (hero.x > displayLeft + nonScroll) then
			sceneGroup.x = -hero.x + nonScroll
		elseif (hero.x < displayLeft + heroWidth) then
			sceneGroup.x = -hero.x + heroWidth
		end
	end
end
---------------------
-- fine CAMERA SCROLL
---------------------

---------
-- inizio SHOW
---------
function scene:show( event )
	local sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then
		Runtime:addEventListener('enterFrame', moveCamera)
	elseif ( phase == "did" ) then
		-- Avviare un rumore di cambio scena?

	end


end
---------
--- fine SHOW
--------

---------
-- inizio HIDE
---------
function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:removeEventListener('enterFrame', moveCamera)
	end

end
-------------
--- fine HIDE
-------------

-----------
-- inizio DESTROY
-----------
function scene:destroy( event )
  --collectgarbage()

end
----------------
--- fine DESTROY
----------------

---------
--ASCOLTATORI
---------
-- Ascoltatori scene
scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
--Ascoltatori oggetti


return scene --fine
