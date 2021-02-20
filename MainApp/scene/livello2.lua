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
--Creazione della variabile contenente i dati della mappa e la mappa stessa
local map, hero
local mapLimitLeft = 0
local mapLimitRight = 960

-- Create a new Composer scene
local scene = composer.newScene()
local sceneGroup

---------
--CREATE
---------
function scene:create( event )

	local sceneGroup = self.view  -- Add scene display objects to this group
	sceneGroup.anchorX = 0
	sceneGroup.anchorY = 0
	sceneGroup.anchorChildren = true

	--sounds here*

	physics.setDrawMode("normal")
	physics.setGravity( 0, 32 )
	physics.start()


	local filename = 'scene/maps/lvl2/livello2.json'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, "scene/maps/lvl2")

	map.anchorX = 0
	map.anchorY = 0

	-- Eroe
	hero = robot.createRobot()
	hero.x = 200
	hero.y = 200


-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )
sceneGroup:insert( hero )

end -- fine del creazione

-- Funzione per il camera scroll
local function moveCamera (event)
	local offsetX = 100
	local heroWidth = hero.width
	local displayLeft = -sceneGroup.x
	local nonScrollingWidth = display.contentWidth - offsetX
	local nonScroll = display.contentWidth - heroWidth
	
	if (hero.x >= mapLimitLeft + heroWidth and hero.x <= mapLimitRight - heroWidth) then
		if (hero.x > displayLeft + nonScrollingWidth) then
			sceneGroup.x = -hero.x + nonScrollingWidth
		elseif (hero.x < displayLeft + offsetX) then
			sceneGroup.x = -hero.x + offsetX
		end
	end
end

---------
-- SHOW
---------
function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then
		Runtime:addEventListener('enterFrame', moveCamera)
	elseif ( phase == "did" ) then
		-- Avviare un rumore di cambio scena

	end

end --end show

---------
-- HIDE
---------
function scene:hide( event )

	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:removeEventListener('enterFrame', moveCamera)
	end

end -- end hide

---------
-- DESTROY
---------
function scene:destroy( event )
  --collectgarbage()

end -- end destroy

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
