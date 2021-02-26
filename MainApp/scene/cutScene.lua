-- CUTSCENE --
-- Serve per passare da una scena all'altra, cancellando la precedente
-- Viene utilizzata nello specifico per i passaggi di scena tra livello 1 / livello 2 / livello boss


local composer = require( "composer" )

-- Variabile utilizzata per salvare il nome della scena da cui siamo arrivati
-- Così da poterla eliminare semplicemente
local prevScene = composer.getSceneName( "previous" )


local scene = composer.newScene()

function scene:show( event )

	local phase = event.phase
	
	local options = {params = {}}
	if ( phase == "will" ) then
		composer.removeScene( prevScene ) -- Rimuoviamo la scena precedente
	elseif ( phase == "did" ) then
		if (prevScene == 'scene.livello1') then -- Qua controlliamo da che scena siamo arrivati
			composer.removeScene('scene.livello2')
			composer.gotoScene('scene.livello2', options) -- avvio il livello 2
		else
			composer.removeScene('scene.boss')
			composer.gotoScene('scene.boss', options)
		end
	end
end

scene:addEventListener( "show", scene )

return scene
