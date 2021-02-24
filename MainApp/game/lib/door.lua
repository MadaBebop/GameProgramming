local M = {}

local composer = require 'composer'

function M.createDoor()

    local door = display.newRect(20,20 , 20,20 , 20,20 , 20,20)
    physics.addBody(door, 'static', {isSensor = true})
	door:setFillColor( 0.5 )
	door.type = 'door'

    local scene = composer.getScene(composer.getSceneName('current'))

    function collision(event) 
        local phase = event.phase
        local other = event.other

        if (phase == 'began') then
            if (other.type == 'robot') then 
                print('colliding')
                composer.gotoScene('scene.cutScene', {params = {map = door.map, path = door.path}})
            end
        end
    end

    door:addEventListener('collision',collision)

    return door
end

return M