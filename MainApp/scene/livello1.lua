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

	
	physics.setDrawMode("hybrid")
	physics.start()
	local startLine = display.newLine(0,0, 0, display.contentHeight)

	local filename = 'scene/maps/lvl1/livello1.json'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, "scene/maps/lvl1")

	--Posizionamento della mappa
	map.anchorX = 0
	map.anchorY = 0
	
	local sc = display.screenOriginX
	map.x = sc
	print(sc)

	--Carico il personaggio
	hero = robot.createRobot()
	hero.x = 200
	hero.y = 200

-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )

end -- fine del creazione

-- local function enterFrame (event) 
-- 	if hero and hero.x and not hero.isDead then
-- 		local x, y = hero:localToContent(0,0)
-- 		x = display.contentCenterX - x 
-- 		map.x = map.x + x
-- 	end
-- end


---------
-- SHOW
---------
function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then
		-- Runtime:addEventListener('enterFrame', enterFrame)
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
		-- Runtime:removeEventListener('enterFrame', enterFrame)

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
