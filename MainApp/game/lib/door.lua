-- Modulo per la porta, all'atto pratico è un oggetto da porre nei pressi della vera e propria porta (inserita tramite Tiled) 
local M = {}

local composer = require 'composer'

function M.createDoor()

    -- Sagoma della porta
    local door = display.newRect(0,0,16,32) 
    door.isVisible = false
	door.type = 'door'

    local scene = composer.getScene(composer.getSceneName('current'))

    function collision(event) 
        local phase = event.phase
        local other = event.other

        if (phase == 'began') then
            if (other.type == 'robot') then
                -- N.B. in questo passaggio la proprietà isDead viene settata a true per far si che il giocatore non possa interagire con il personaggio
                -- durante il cambio di scena
                other.isDead = true
                composer.removeScene('scene.cutScene')
                composer.gotoScene('scene.cutScene')
            end
        end
    end

    door:addEventListener('collision',collision)

    return door
end

return M