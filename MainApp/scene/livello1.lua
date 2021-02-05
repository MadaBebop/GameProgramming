

-- Composer
local composer = require "composer"
-- Fisica
local physics = require('physics')

-- importo la libreria ponytiled
local tiled = require "com.ponywolf.ponytiled"

-- importo la libreria json
local  json = require "json"

--Creazione della variabile contenente i DATI della mappa
local mapData = json.decodeFile("system.pathForFile(“maps/tiles/livello1.json", system.ResourceDirectory))

-- Creazione della variabile mappa
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


-- Inizio della fisica prima del caricamento della mappa
physics.setDrawMode("hybrid")
-- gravità? physics.setGravity( 0, 32 )
physics.start()

--Caricamento della mappa
map = tiled.new(mapData, "maps/tiles")

--Individuazione campione, nemici  etc.

-- Toccare la rotella per tornare al menu ?
-- function rotella:tap(event)
	-- fx.fadeOut( function()
		--	composer.gotoScene( "scene.menu")
	-- end )
-- end
-- con l'ascoltatore associato -> rotella:addEventListener("tap")

-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )
-- sceneGroup:insert( rotella )

end -- fine del creazione

-- Function to scroll the map?

local function enterFrame(event)

	local elapsed = event.time
	-- DA IMPLEMENTARE MAGARI IN UNO DEI FILE CON FUNZIONI
	-- ESEMPIO DI SCROLLING DEL PERSONAGGIO EROE
	--if hero and hero.x and hero.y and not hero.isDead then
		---local x, y = hero:localToContent( 0, 0 )
		--x, y = display.contentCenterX - x, display.contentCenterY - y
		--map.x, map.y = map.x + x, map.y + y
		-- Easy parallax
		--if parallax then
			--parallax.x, parallax.y = map.x / 6, map.y / 8  -- Affects x more than y
		--end
	--end
	--end -- fine funzione
	--
end -- fine

---------
-- SHOW
---------
function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then
		fx.fadeIn() -- Dissolvenza
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
