------------------
--- LIBRERIE
------------------
local composer = require "composer"
local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"
local robot = require 'game.hero.robot' -- includiamo il file che gestisce l'eroe
local bossC = require 'game.boss.boss' -- includiamo il file che gestisce il boss

----------------
--- Variabili
----------------
--Creazione della variabile contenente i dati della mappa e la mappa stessa
local map, hero, boss

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
	physics.setGravity( 0, 20 )

	-- Creazione delle variabili della mappa (con annessi tiles)
	local filename = 'scene/maps/boss/boss.json'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, "scene/maps/lvl2") -- La scena del boss utilizza gli stessi sprite del livello 2

	-- Eroe ---
	hero = robot.createRobot()
	hero.x = 300
	hero.y = 300

	-- Boss ---
	boss = bossC.createBoss()
	boss.x = 200
	boss.y = 200

	--Centramento della mappa
	map.x = 0
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

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene --fine
