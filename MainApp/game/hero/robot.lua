local composer = require 'composer'

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
    local rectangle = { -7,12 , 7,12 , 7,-12 ,-7,-12 } -- HitBox che verrà applicata all'eroe
    physics.addBody(robot, "dynamic", {bounce = 0,0 , shape = rectangle })
    robot:scale(0.5,0.5) -- L'eroe viene scalato

    local isFacing = 'right'
    robot.isDead = false
    robot.isFixedRotation = true
    robot.jumping = false
    robot.type = 'robot'

    -- Funzione per il movimento del robot, per questo progetto nello specifico il personaggio si muoverà esclusivamente
    -- tramite tastiera con la seguente mappatura dei tasti:
    --     d = movimento verso destra
    --     a = movimento verso sinistra
    --     spacebar = salto
    --     k = sparo
    local function key (event)
        local keyName = event.keyName
        local phase = event.phase

        if (robot.isDead) then
            return
        else
            if (phase == 'down') then -- Quando un tasto viene premuto
                if ('d' == keyName) then 
                    -- controllo se il personaggio è girato verso sx, se è così allora lo scalo e setto isFacing a destra
                    if (isFacing == 'left') then
                        robot:scale(-1, 1)
                        isFacing = 'right'
                    end
                    robot:setSequence("Run")
                    robot:play()
                    robot:setLinearVelocity(120, 0)
                elseif ('a' == keyName) then
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
                if (not robot.isDead) then
                    robot:setSequence("Idle")
                    robot:play()
                    robot:setLinearVelocity(0, 0)
                end
            end
        end
    end

    -- Ascoltatore del timer, questa funzione in particolare è utile per far si che l'utente non possa premere ripetutamente la spacebar
    -- così evitiamo che l'eroe esegua ripetutamente la funzione di salto, portandolo in una sorta di "volo"
    local function listener (event)
      robot.jumping = false -- dopo un secondo la fase di salto finisce, indipendentemente da altre pressione della spacebar
    end

    -- Funzione dedicata al salto dell'eroe, si setta la sequenza corretta, si fa partire l'animazione e si applica un impulso lineare
    function robot:jumpRobot(event)
        if not robot.jumping then
            robot:setSequence("Jump")
            robot:play()
            robot:applyLinearImpulse(0, -0.05 ) -- salto
            robot.jumping = true  -- il robot sta saltando
            timer.performWithDelay(1000,listener) -- delay per il passaggio da fase di salto a quella di non salto
        end
    end


    -- Funzione per lo sparo, si occupa della creazione di un oggetto "proiettile"
    function robot:shoot(event)
        robot:setSequence('Shoot')
        robot:play()
        
        local proiettile = display.newImage('game/hero/robotfree/pngTagliate/Bullet_000.png')
        physics.addBody(proiettile, 'dynamic')
        proiettile.gravityScale = 0
        proiettile.isBullet = true
        proiettile.type = 'bullet'
        proiettile.isFixedRotation = true

        if (isFacing == 'right') then
            proiettile.x = robot.x + (robot.width / 2)
            proiettile.y = robot.y
            proiettile:setLinearVelocity(120, 0)
        else
            proiettile:scale(-1, 1)
            proiettile.x = robot.x - (robot.width / 2)
            proiettile.y = robot.y
            proiettile:setLinearVelocity(-120, 0)
        end
    end

    -- Funzione per la morte dell'eroe che si occupa della parte grafica e della rimozione degli ascoltatori associati
    local function death()
        robot.isDead = true
        robot:setSequence('Death')
        robot:play()
        removeEventListeners()
    end

    -- Funzione per la collisione, si controlla il tipo dell'oggetto colliso 
    function collision (event)
        local phase = event.phase
        local other = event.other

        if (phase == 'began') then
            if (other.type == 'zombie' or other.type == 'trap') then
                death()
            elseif (phase == 'ended') then
                robot:removeSelf()
                robot = nil
             end
        end
    end

    -- Funzione che viene richiamata durante la morte del personaggio, rimuove gli ascoltatori ad esso associato
    function removeEventListeners()
        robot:removeEventListener('collision', collision)
        Runtime:removeEventListener('key', key)
    end

    -- Ascoltatori
    Runtime:addEventListener("key", key)
    robot:addEventListener('collision', collision)

    return robot

end

return M
