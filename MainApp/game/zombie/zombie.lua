local M = {}

function M.createZombie()
    -- idle sheet
    local idleData = {width = 65, height = 78, numFrames = 15, sheetContentWidth = 975, sheetContentHeight = 78}
    local idleSheet = graphics.newImageSheet("robotfree/zombie/IdleSheet.png", idleData)

    -- walk sheet
    local walkData = {width = 65, height = 78, numFrames = 10, sheetContentWidth = 650, sheetContentHeight = 78}
    local walkSheet = graphics.newImageSheet("robotfree/zombie/walkSheet.png", walkData)

    local deathData = {width = 63, height = 53, numFrames = 12, sheetContentWidth = 756, sheetContentHeight = 53}
    local deathSheet = graphics.newImageSheet('robotfree/zombie/zombieDeathSheet.png', deathData)


    local zombieSequences = {
        {
            name = 'Idle',
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
        },
        {
            name = "Death",
            sheet = deathSheet,
            start = 1,
            count = 12,
            time = 500,
            loopCount = 1,
            loopDirection = "forward"
        }   
    }

    local zombie = display.newSprite(idleSheet, zombieSequences)
    local type = 'zombie'
    local zombieShape = {}
    physics.addBody(zombie, 'dynamic', {friction = 1.0, density = 3.5})
    zombie:scale(-1, 1)
    zombie:setSequence('Idle')
    zombie:play()
    zombie.isFixedRotation = true


    return zombie
end

return M