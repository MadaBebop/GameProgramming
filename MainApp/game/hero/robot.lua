local M = {}

function M.createRobot()

    --========== CARICO TUTTE LE ANIMAZIONI DEL ROBOT + PROIETTILE ===========================
    local idleData = {width = 57, height = 56, numFrames = 10, sheetContentWidth = 570, sheetContentHeight = 56}
    local idleSheet = graphics.newImageSheet("game/hero/robotfree/idleSheet.png", idleData)

    local runData = {width = 57, height = 56, numFrames = 8, sheetContentWidth = 456, sheetContentHeight = 56}
    local runSheet = graphics.newImageSheet("game/hero/robotfree/runSheet.png", runData)

    local deathData = {width = 57, height = 56, numFrames = 10, sheetContentWidth = 570, sheetContentHeight = 56}
    local deathSheet = graphics.newImageSheet("game/hero/robotfree/deathSheet.png", deathData)

    local jumpData = {width = 57, height = 56, numFrames = 10, sheetContentWidth = 570, sheetContentHeight = 56}
    local jumpSheet = graphics.newImageSheet("game/hero/robotfree/jumpSheet.png", jumpData)

    local shootData = {width = 57, height = 56, numFrames = 4, sheetContentWidth = 228, sheetContentHeight = 56}
    local shootSheet = graphics.newImageSheet("game/hero/robotfree/shootSheet.png", shootData)

    local proiettileData = {width = 14, height = 11, numFrames = 5}
    local proiettileSheet = graphics.newImageSheet("game/hero/robotfree/pro.png", proiettileData)

    local robotSequences = {
        {
            name = "Idle",
            sheet = idleSheet,
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            loopDirection = "forward"
        },
        {
            name = "Run",
            sheet = runSheet,
            start = 1,
            count = 8,
            time = 500,
            loopCount = 0,
            loopDirection = "forward"
        },
        {
            name = "Death",
            sheet = deathSheet,
            start = 1,
            count = 10,
            time = 500,
            loopCount = 1,
            loopDirection = "forward"
        },
        {
            name = "Jump",
            sheet = jumpSheet,
            start = 1,
            count = 10,
            time = 800,
            loopCount = 1,
            loopDirection = "forward"
        },
        {
            name = "Shoot",
            sheet = shootSheet,
            start = 1,
            count = 4,
            time = 500,
            loopCount = 1,
            loopDirection = "forward"
        }
    }

    --==================== FINE ANIMAZIONI =======================--

    local robot = display.newSprite(idleSheet, robotSequences)
    robot:setSequence("Idle")
    robot:play()
    robot:scale(0.5,0.5) -- scalato l'eroe a metà
    local rectangle = { -7,12 , 7,12 , 7,-12 ,-7,-12 } --HitBox
    physics.addBody(robot, "dynamic", {bounce = 0,0 , shape = rectangle })
    local isFacing = 'right'
    local isDead = false
    robot.isFixedRotation = true
    robot.jumping = false


    local function key (event)
        local keyName = event.keyName
        local phase = event.phase
        if (phase == 'down') then -- Quando un tasto viene premuto
            if ('d' == keyName) then
                -- d = movimento verso destra
                -- controllo se il personaggio è girato verso sx, se è così allora lo scalo e setto isFacing a destra
                if (isFacing == 'left') then
                    robot:scale(-1, 1)
                    isFacing = 'right'
                end
                robot:setSequence("Run")
                robot:play()
                robot:setLinearVelocity(120, 0)
            elseif ('a' == keyName) then
                -- a = movimento verso sinistra
                -- controllo se il personaggio è girato verso dx, se è così allora lo scalo e setto isFacing a sinistra
                if (isFacing == 'right') then
                    robot:scale(-1, 1)
                    isFacing = 'left'
                end
                robot:setSequence("Run")
                robot:play()
                robot:setLinearVelocity(-120, 0)
            elseif ('k' == keyName) then
                robot:shoot()
            elseif ('space' == keyName) then
                robot:jumpRobot()
            end
        elseif (phase == 'up') then -- Quando il tasto viene rilasciato
            robot:setSequence("Idle")
            robot:play()
            robot:setLinearVelocity(0, 0)
            robot.jumping = false
        end
    end


    function robot:jumpRobot(event)
        if not robot.jumping then
            robot:setSequence("Jump")
            robot:play()
            robot:applyLinearImpulse(0, -0.12 )
            robot.jumping = true
        end


        -- Funzione locale per "ascoltare" quando l'animazione del salto termina e settare la sequenza idle
        local function spriteListener(event)
            if (event.phase == "ended") then
                robot:setSequence("Idle")
                robot:play()
            end
        end

        robot:addEventListener("sprite", spriteListener)
    end


    -- Funzione per lo sparo
    function robot:shoot(event)
        robot:setSequence('Shoot') 
        robot:play()
        local proiettile = display.newImage('game/hero/robotfree/pngTagliate/Bullet_000.png')
        proiettile.name = 'proiettile'
        physics.addBody(proiettile, 'kinematic')
        if (isFacing == 'right') then
            proiettile.x = robot.x + 25
            proiettile.y = robot.y
            proiettile:setLinearVelocity(120, 0)
        else
            proiettile:scale(-1, 1)
            proiettile.x = robot.x - 25
            proiettile.y = robot.y
            proiettile:setLinearVelocity(-120, 0)
        end
    end

    Runtime:addEventListener("key", key)

    return robot

end


function M.shootRobot(robot, event)
    robot:setSequence("Shoot")
    robot:play()

    local proiettile = display.newSprite(proiettileSheet, proiettileSequences)
    proiettile.x = robot.x + 30
    proiettile.y = robot.y - 13
    proiettile:play()
    physics.addBody(proiettile, "kinematic")
    proiettile:setLinearVelocity(200,0)
end

return M
