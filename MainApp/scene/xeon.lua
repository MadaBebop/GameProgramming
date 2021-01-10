local M = {}

function M.new()
    -- xeon walk sheet
    local xeonWalkData = {width = 49, height = 58, numFrames = 10, sheetContentWidth = 490, sheetContentHeight = 58}
    local xeonWalkSheet = graphics.newImageSheet("scene/img/xeonWalk.png", xeonWalkData)

    -- xeon jump sheet
    local jumpData = {width = 43, height = 63, numFrames = 12, sheetContentWidth = 516, sheetContentHeight = 63}
    local jumpSheet = graphics.newImageSheet("scene/img/jumpSheet.png", jumpData)

    local xeonSequences = {
        {
            name = "walk",
            sheet = xeonWalkSheet,
            start = 1,
            count = 10,
            time = 700,
            loopCount = 0,
            loopDirection = "forward"
        },
        {
            name = "jump",
            sheet = jumpSheet,
            start = 1,
            count = 12,
            time = 1500,
            loopCount = 1,
            loopDirection = "forward"
        }
    }

    local xeon = display.newSprite (xeonWalkSheet, xeonSequences)
    physics.addBody(xeon, "dynamic", {bounce = 0})
    xeon.isFixedRotation = true

    return xeon
end

--xeon move
function M.moveXeon(xeon, event)
    if (event.phase == "began") then
        xeon:setSequence("walk")
        xeon:play()
        xeon:setLinearVelocity(50, 0)
    elseif(event.phase == "ended") then
        xeon:pause()
        xeon:setLinearVelocity(0,0)
    end
end

--xeon jump
function M.jumpXeon(xeon, event)
    xeon:setSequence("jump")
    xeon:play()
    xeon:applyLinearImpulse(0, -0.25, xeon.x, xeon.y)
end

function M.create(xeon, xPos, yPos)
    xeon.x = xPos
    xeon.y = yPos
    xeon:scale(2,2)
    xeon:setSequence("walk")
end



return M
