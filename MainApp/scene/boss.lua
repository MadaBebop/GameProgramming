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

-- Funzione che controlla se il boss è morto, se true allora viene lanciata la scena di Victory
-- N.B. la proprietà isDead dell'eroe viene settata a true per evitare input al personaggio durante il cambio di scena
function winGame()
	if (boss.isDead) then
		audio.fadeOut({channel = 1, time = 400})
		hero.isDead = true
		composer.removeScene('scene.victory')
		composer.gotoScene('scene.victory', {effect = 'fade', time = 500})
	end
end

-- Funzione che controlla se l'eroe è morto, se true allora viene lanciata la scena di Game Over
function gameOver()
	if (hero.isDead) then
		audio.fadeOut({channel = 1, time = 400})
		composer.removeScene('scene.gameOver')
		composer.gotoScene('scene.gameOver', {effect = 'fade', time = 500})
	end
end

---------
--CREATE
---------
function scene:create( event )

	local sceneGroup = self.view  

	physics.start()
	physics.setDrawMode("normal")
	physics.setGravity( 0, 32 )

	-- Creazione della mappa grazie alla libreria Ponytiled 
	local filename = 'scene/maps/boss/boss.json'
	local pathToTile = 'scene/maps/lvl2'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, pathToTile)
	

	-- Carico il personaggio
	hero = robot.createRobot()

	-- Carico il boss
	boss = bossC.createBoss()

	-- I vari display objects vengono inseriti del al gruppo della scena corrente
	sceneGroup:insert( map )
	sceneGroup:insert( hero )
	sceneGroup:insert( boss )

end
---------------
-- fine CREATE
---------------


---------
-- SHOW
---------
function scene:show( event )
local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Posizionamento dei vari display objects
		map.x = 0
		map.y = 0
		--
		hero.x = 20
		hero.y = 300
		--
		boss.x = 420
		boss.y = 120

		-- Ascoltatori
		Runtime:addEventListener('enterFrame', gameOver)
		Runtime:addEventListener('enterFrame', winGame)

	elseif ( phase == "did" ) then
		

	end

end 
---------
--- fine SHOW
--------


---------
--Inizio HIDE
---------
function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then

		-- Rimozione degli ascoltatori di scena
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
