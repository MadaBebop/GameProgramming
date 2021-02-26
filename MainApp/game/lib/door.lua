local M = {}

local composer = require 'composer'

function M.createDoor()

    local door = display.newRect(0,0,16,32)
    door.isVisible = false
	door.type = 'door'

    local scene = composer.getScene(composer.getSceneName('current'))

    function collision(event) 
        local phase = event.phase
        local other = event.other

        if (phase == 'began') then
            if (other.type == 'robot') then
                other.isDead = true
                composer.removeScene('scene.cutScene')
                composer.gotoScene('scene.cutScene', {params = {map = door.map, path = door.path}})
            end
        end
    end

    door:addEventListener('collision',collision)

    return door
end

return M