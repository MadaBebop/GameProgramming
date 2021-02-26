local composer = require 'composer'

local scene = composer.newScene()

-- VARIABILI
local victory
local victoryAudio



function scene:create(event)
    local sceneGroup = self.view

    -- Creazione dell'immagine di background e caricamento del suono di vittoria
    victory = display.newImageRect(sceneGroup, 'scene/img/victory.png', 480, 320)
    victoryAudio = audio.loadSound('music/victorySound.mp3')
end



-- Funzione per tornare al menu
local function returnToMenu()
    composer.removeScene('scene.menu')
    composer.gotoScene('scene.menu', {effect = 'fade', time = 500})

end


function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == 'will') then
        -- Posizionamento del background
        victory.x = display.contentCenterX
        victory.y = display.contentCenterY

    elseif (phase == 'did') then
        -- Assegno a victory un ascoltatore di tipo tap, cosi da poter lanciare la funzione
        -- returnToMenu quando si tappa sul background
        victory.tap = returnToMenu
        victory:addEventListener('tap', returnToMenu)
        audio.play(victoryAudio, {loop = -1, channel = 3})

    end
end


function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == 'will') then        
        -- Rimuovo l'ascoltatore tap associato ed eseguo una dissolvenza per l'audio
        victory:removeEventListener('tap', returnToMenu)
        audio.fadeOut({channel = 3, time= 400})

    elseif (phase == 'did') then

    end
end


function scene:destroy( event )
	local sceneGroup = self.view

end



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
