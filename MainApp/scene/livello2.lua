------------------
--- LIBRERIE
------------------
local composer = require "composer"
local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"
local robot = require 'game.hero.robot'
local zombie = require 'game.zombie.zombie'
local door = require 'game.lib.door'
local syringe = require 'game.lib.syringe'

----------------
--- Variabili
----------------

local map, hero, enemy, siringa, porta -- variabili della mappa, eroe e siringa
-- Limiti della mappa
local mapLimitLeft = 0
local mapLimitRight = 960

-- Create a new Composer scene
local scene = composer.newScene()
local sceneGroup



function gameOver()
	if (hero.isDead) then
		audio.fadeOut({channel = 1, time = 400})
		composer.removeScene('scene.gameOver')
		composer.gotoScene('scene.gameOver', {effect = 'fade', time = 500})
	end
end

---------------
--inizio CREATE
---------------
function scene:create( event )

	sceneGroup = self.view  -- Add scene display objects to this group
	sceneGroup.anchorX = 0
	sceneGroup.anchorY = 0
	sceneGroup.anchorChildren = true

	physics.start()
	physics.setDrawMode("normal")
	physics.setGravity( 0, 32 )


	-- Inserisco nella variabile mappa i dati inerenti alla mappa .json
	local filename = event.params.map or 'scene/maps/lvl2/livello2.json'
	local pathToTile = event.params.path or 'scene/maps/lvl2'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, pathToTile)

	--Posizionamento della mappa
	map.anchorX = 0
	map.anchorY = 0

	-- Eroe
	hero = robot.createRobot()

	--caricamento nemico
	enemy1 = zombie.createZombie()
	enemy2 = zombie.createZombie()

	-- Siringe
	siringa = syringe.createSyringe()

	-- Porta
	porta = door.createDoor()
	porta.map = 'scene/maps/boss/boss.json'
	porta.path = 'scene/maps/lvl2'




	-- GRUPPI SCENE --
	-- Insert our game items in the correct back-to-front order
	sceneGroup:insert( map )
	sceneGroup:insert( hero )
	sceneGroup:insert( enemy1 )
	sceneGroup:insert( enemy2 )
	sceneGroup:insert( siringa )
	sceneGroup:insert( porta )


end
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
	local nonScroll = display.contentWidth / 2

	if (hero.x >= mapLimitLeft + offsetX and hero.x <= mapLimitRight - nonScroll) then
		if (hero.x > displayLeft + nonScroll) then
			sceneGroup.x = -hero.x + nonScroll
		elseif (hero.x < displayLeft + offsetX) then
			sceneGroup.x = -hero.x + offsetX
		end
	end
	return true
end
---------------------
-- fine CAMERA SCROLL
---------------------

---------------
-- inizio SHOW
--------------
function scene:show( event )
	sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		--Pos. Eroe
			hero.x = 100
			hero.y = 200
		--Pos. Enemies
			enemy1.x = 860
			enemy1.y = 90

			enemy2.x = 310
			enemy2.y = 170
			enemy2:scale(-1,1)
		--Pos. Siringe
			siringa.x = 120
			siringa.y = 97
		-- Pos. Porta
			porta.x = 935
			porta.y = 80

		--Ascoltatore per lo scrolling e per il gameover
		Runtime:addEventListener('enterFrame', moveCamera)
		Runtime:addEventListener('enterFrame', gameOver)


	elseif ( phase == "did" ) then

	end


end
---------
--- fine SHOW
--------

---------
-- inizio HIDE
---------
function scene:hide( event )
	sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then
		-- Rimozione degli ascoltatori
		Runtime:removeEventListener('enterFrame', moveCamera)
		Runtime:removeEventListener('enterFrame', gameOver)
		
	elseif ( phase == "did" ) then

	end

end
-------------
--- fine HIDE
-------------

-----------
-- inizio DESTROY
-----------
function scene:destroy( event )
	sceneGroup = self.view


end
----------------
--- fine DESTROY
----------------


-- Ascoltatori scene
scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")


return scene 
