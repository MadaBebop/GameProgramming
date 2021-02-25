------------------
--- LIBRERIE
------------------
local composer = require "composer"
local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"
local robot = require 'game.hero.robot' -- includiamo il file che gestisce l'eroe
local bossC = require 'game.boss.bossCreate' -- includiamo il file che gestisce il boss

----------------
--- Variabili
----------------
--Creazione della variabile contenente i dati della mappa e la mappa stessa
local map, hero, boss

-- Create a new Composer scene
local scene = composer.newScene()
local sceneGroup

function winGame()
	if (boss.isDead) then
		audio.fadeOut({channel = 1, time = 400})
		hero.isDead = true
		composer.removeScene('scene.victory')
		composer.gotoScene('scene.victory', {effect = 'fade', time = 500})
	end
end


function gameOver()
	if (hero.isDead) then
		composer.removeScene('scene.gameOver')
		composer.gotoScene('scene.gameOver', {effect = 'fade', time = 500})
	end
end

---------
--CREATE
---------
function scene:create( event )

	local sceneGroup = self.view  -- Add scene display objects to this group
	--sounds here*
	--end sounds
	-- Se si contengono degli oggettifisici nella mappa bisogna caricare prima la fisica!
	physics.start()
	physics.setDrawMode("hybrid")
	physics.setGravity( 0, 32 )

	-- Creazione delle variabili della mappa (con annessi tiles)
	local filename = event.params.map or 'scene/maps/boss/boss.json'
	local pathToTile = event.params.path or 'scene/maps/lvl2'-- La scena del boss utilizza gli stessi sprite del livello 2
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, pathToTile)

	-- Eroe ---
	hero = robot.createRobot()
	-- Boss ---
	boss = bossC.createBoss()

-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )
sceneGroup:insert( hero )
sceneGroup:insert( boss )

end
---------------
-- fine CREATE
---------------

-- Ninete camera scroll visto che la mappa è piccola

---------
-- SHOW
---------
function scene:show( event )
local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		--Centramento della mappa
		map.x = 0
		map.y = 0
		--
		hero.x = 20
		hero.y = 300
		--
		boss.x = 420
		boss.y = 120


		Runtime:addEventListener('enterFrame', gameOver)
		Runtime:addEventListener('enterFrame', winGame)

	elseif ( phase == "did" ) then
		-- Avviare un rumore di cambio scena

	end

end --end show

---------
--Inizio HIDE
---------
function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then

		Runtime:removeEventListener('enterFrame', gameOver)
		Runtime:removeEventListener('enterFrame', winGame)
	elseif ( phase == "did" ) then

	end

end
-------------
--- fine HIDE
-------------

----------------
--Inizio DESTROY
----------------
function scene:destroy( event )
local sceneGroup = self.view

end
----------------
--- fine DESTROY
----------------

---------
--ASCOLTATORI
---------
scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene --fine
