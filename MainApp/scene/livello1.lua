------------------
--- LIBRERIE
------------------
-- Libreria Composer
local composer = require "composer"
-- importo la libreria ponytiled
local tiled = require "com.ponywolf.ponytiled"
-- Libreria Fisica
local physics = require "physics"
-- importo la libreria json
local json = require "json"
----------------
--- Variabili
----------------
--Creazione della variabile contenente i dati della mappa e la mappa stessa
local map

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
	physics.setDrawMode("debug")
	physics.start()
	-- gravità? physics.setGravity( 0, 32 )

local mapData = json.decodeFile("system.pathForFile(“maps/tiles/livello1.json", system.ResourceDirectory)
map = tiled.new(mapData, "maps/tiles") -- l'errore è qui

	--Centramento della mappa
	map.x,map.y = display.contentCenterX - map.designedWidth/2, display.contentCenterY - map.designedHeight/2

-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )

end -- fine del creazione


---------
-- SHOW
---------
function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then
		tiled.fadeIn() -- Dissolvenza fx. ?
		Runtime:addEventListener( "enterFrame", enterFrame )
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
		Runtime:removeEventListener( "enterFrame", enterFrame )
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
