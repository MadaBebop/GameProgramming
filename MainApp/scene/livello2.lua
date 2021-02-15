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


-- Create a new Composer scene
local scene = composer.newScene()

---------
--CREATE
---------
function scene:create( event )

	local sceneGroup = self.view  -- Add scene display objects to this group

	--sounds here*
	--end sounds

	-- Se si contengono degli oggettifisici nella mappa bisogna caricare prima la fisica!
	physics.setDrawMode("hybrid")
	physics.start()

	local filename = 'scene/maps/lvl2/livello2.json'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, "scene/maps/lvl2")

	-- Eroe
	hero = robot.createRobot()
	hero.x = 200
	hero.y = 200
	
	--Centramento della mappa
	map.x = -30
	map.y = 0

-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )

end -- fine del creazione


---------
-- SHOW
---------
function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then

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
