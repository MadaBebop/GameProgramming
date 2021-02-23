local M = {}

local composer = require 'composer'

function M.createDoor()

    local scene = composer.getScene(composer.getSceneNAme('current'))

    function collision(event) 
        local phase = event.phase
        local other = event.other

        if (phase == 'began') then
            if (other == 'hero') then 
                composer.gotoScene('scene.refresh', {params = {
                    map = self.map
                }})
            end
        end
    end
end

return M