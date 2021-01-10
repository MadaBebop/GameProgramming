local M = {}


function M.new()
    -- idle sheet
    local idleData = {width = 65, height = 78, numFrames = 15, sheetContentWidth = 975, sheetContentHeight = 78}
    local idleSheet = graphics.newImageSheet("scene/img/IdleSheet.png", idleData)

    -- walk sheet
    local walkData = {width = 65, height = 78, numFrames = 10, sheetContentWidth = 650, sheetContentHeight = 78}
    local walkSheet = graphics.newImageSheet("scene/img/walkSheet.png", walkData)

    -- sequences
    local zombieSeqs = {
        {
            name = "Idle",
            sheet = idleSheet,
            start = 1,
            count = 15,
            time = 1500,
            loopCount = 0,
            loopDirection = "bounce"
        },
        {
            name = "Walk",
            sheet = walkSheet,
            start = 1,
            count = 10,
            time = 500,
            loopCount = 0,
            loopDirection = "forward"
        }
    }

    local zombie = display.newSprite(idleSheet, zombieSeqs)
    physics.addBody(zombie, "dynamic", {bounce = 0})
    zombie.isFixedRotation = true

    return zombie

end

-- posizionamento dello zombie
function M.initialize(zombie, xPos, yPos)
    zombie.x = xPos
    zombie.y = yPos
    zombie:scale(1.5, 1.5)
    zombie:setSequence("Idle")
    zombie:play()
end

-- attivazione della ronda
function M.movement(zombie, speed, from, to)
    zombie:setSequence("Walk")
    zombie:play()
    zombie:setLinearVelocity(speed, 0)

    -- activate ronda movement
    local function ronda(event)
        if (zombie.x >= to) then
            zombie:scale(-1, 1)
            zombie:setLinearVelocity(-130, 0)
        elseif (zombie.x <= from) then
            zombie:scale(-1, 1)
            zombie:setLinearVelocity(130, 0)
        end
    end

    Runtime:addEventListener("enterFrame", ronda)
end


return M
