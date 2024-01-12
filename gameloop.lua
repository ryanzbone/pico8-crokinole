-- Pico-8 game template



function _init()
    -- Initialize game state
   
    board = {
        outerCircleRadius = 12,  -- Outer circle radius
        middleCircleRadius = 8,  -- Middle circle radius
        innerCircleRadius = 4,   -- Inner circle radius
        centerHoleRadius = 0.8,  -- Center hole radius
        scalingFactor = 4,       -- Scaling factor
        originX = 64,            -- Origin x position
        originY = 64,            -- Origin y position
    }
    -- initialize discs collection, add a disc to it via addDisc   
    discs = {}
    addDisc()
end

function addDisc()
    local disc = {
        x = board.originX, -- Initial x position (center of the board)
        y = board.originY + (board.outerCircleRadius * board.scalingFactor),  -- Initial y position (bottom center of the outer circle)
        radius = 2,      -- Disc radius
        speed = 6,       -- Initial speed
        powerMultiplier = 0.5,  -- Power multiplier
        angle = 0.75,      -- Initial angle (facing upward)
        positionAngle=0.75, -- Position on the outer board circle in turns
        slowingFactor = 0.95,  -- Rate at which the disc slows down
        state = "selectPosition",  -- Initial state
    }
    add(discs, disc)
end

function _draw()
    cls()
    drawBoard(board)
    drawDiscs()
end

function drawDiscs()
    for i, disc in pairs(discs) do
        drawSingleDisc(disc)
    end
end

function drawSingleDisc(disc)
    circfill(disc.x, disc.y, disc.radius, 9)  -- Color 9 is yellow
    if disc.state == "selectAngle" then
        local lineLength = 5
        for i = 0, lineLength, 0.5 do
            local x = disc.x + i * cos(disc.angle)
            local y = disc.y - i * sin(disc.angle)
            pset(x, y, 7)  -- Color 7 is white (dotted line)
        end
    end

    -- draw power meter if in choosePower state with a horizontal white box filled with a green bar. 
    -- The length of the green bar is the power multiplier
    if disc.state == "choosePower" then
        local powerMeterWidth = 20
        local powerMeterHeight = 2
        local powerMeterX = disc.x - powerMeterWidth / 2
        local powerMeterY = disc.y + disc.radius * 2 + 1
        rect(powerMeterX - 1, powerMeterY - 1, powerMeterX + powerMeterWidth + 1, powerMeterY + powerMeterHeight + 1, 7)  -- Color 7 is white
        rectfill(powerMeterX, powerMeterY, powerMeterX + powerMeterWidth * disc.powerMultiplier, powerMeterY + powerMeterHeight, 11)  -- Color 11 is green
    end
end

function drawBoard(board)
    local scalingFactor = board.scalingFactor

    -- Draw the outer filled circle in red
    --circfill(board.originX, board.originY, board.outerCircleRadius * scalingFactor, 8)  -- Color 8 is red

    -- Draw the middle filled circle in blue
    --circfill(board.originX, board.originY, board.middleCircleRadius * scalingFactor, 12)  -- Color 12 is blue

    -- Draw the board filled circle in green
    --circfill(board.originX, board.originY, board.innerCircleRadius * scalingFactor, 11)  -- Color 11 is green

    -- Draw the inner filled circle (center hole) in black
    --circfill(board.originX, board.originY, board.centerHoleRadius * scalingFactor, 0)  -- Color 0 is black

    -- Draw the outer circle
    circ(board.originX, board.originY, board.outerCircleRadius * scalingFactor, 7)

    -- Draw the board circle
    circ(board.originX, board.originY, board.innerCircleRadius * scalingFactor, 7)

    -- Draw the middle circle
    circ(board.originX, board.originY, board.middleCircleRadius * scalingFactor, 7)

    -- Draw the inner circle (center hole)
    circ(board.originX, board.originY, board.centerHoleRadius * scalingFactor, 7)

    -- Draw lines at 45, 135, 225, and 315 degrees (in Pico-8's turns)
    local function drawRotatedLine(turns)
        local x1 = board.originX + board.middleCircleRadius * scalingFactor * cos(turns)
        local y1 = board.originY - board.middleCircleRadius * scalingFactor * sin(turns)
        local x2 = board.originX + board.outerCircleRadius * scalingFactor * cos(turns)
        local y2 = board.originY - board.outerCircleRadius * scalingFactor * sin(turns)
        line(x1, y1, x2, y2, 7)
    end

    drawRotatedLine(0.125)  -- 45 degrees
    drawRotatedLine(0.375)  -- 135 degrees
    drawRotatedLine(0.625)  -- 225 degrees
    drawRotatedLine(0.875)  -- 315 degrees
end

function chooseStartingPosition(disc)
    -- Move the disc to the left
    if btn(0) and disc.positionAngle > 0.625 then
        disc.positionAngle = disc.positionAngle - 0.01
    end

    -- Move the disc to the right
    if btn(1) and disc.positionAngle < 0.875 then
        disc.positionAngle = disc.positionAngle + 0.01
    end
    
    disc.x=board.originX + board.outerCircleRadius * cos(disc.positionAngle) * board.scalingFactor
    disc.y=board.originY + board.outerCircleRadius * sin(disc.positionAngle) * board.scalingFactor


    -- Select position and move to angle selection
    if btnp(5) then  -- 'x' key
        disc.state = "selectAngle"
    end
end

-- Function to choose the shooting angle between 0 and 180 degrees
function chooseShootingAngle(disc)
    -- Rotate the disc angle to the left
    if btn(0) then
        disc.angle = disc.angle - 0.01
    end

    -- Rotate the disc angle to the right
    if btn(1) then
        disc.angle = disc.angle + 0.01
    end

    -- Shoot the disc and move to the choosePower state
    if btnp(5) then  -- 'x' key
        disc.state = "choosePower"
    end
end

-- Function to choose the power multiplier between 0 and 1 for the disc which will be multiplied by the disc's speed
function choosePower(disc)
    -- Increase the power multiplier
    if btn(1) and disc.powerMultiplier < 1 then
        disc.powerMultiplier = disc.powerMultiplier + 0.05
    end

    -- Decrease the power multiplier
    if btn(0) and disc.powerMultiplier > 0 then
        disc.powerMultiplier = disc.powerMultiplier - 0.05
    end

    -- Shoot the disc and move to the moving state
    if btnp(5) then  -- 'x' key
        disc.state = "moving"
        disc.speed = disc.speed * disc.powerMultiplier
    end
end

-- Function to shoot the disc and transition between states
function shootDisc(disc)
    if disc.state == "selectPosition" then
        chooseStartingPosition(disc)
    elseif disc.state == "selectAngle" then
        chooseShootingAngle(disc)
    elseif disc.state == "choosePower" then
        choosePower(disc)
    elseif disc.state == "moving" then
        moveDisc(disc)
    elseif disc.state == "stopped" then
        -- do nothing
    end
end

function moveDisc(disc)
    -- Update disc position and speed
    disc.x = disc.x + disc.speed * cos(disc.angle)
    disc.y = disc.y - disc.speed * sin(disc.angle)
    disc.speed = disc.speed * disc.slowingFactor

    -- Check if the disc has come to a stop
    if disc.speed < 0.1 then
        disc.state = "stopped"
        disc.speed = 0
    end

end
-- Main update function
function _update()
    updateDiscs()
    -- if every disc is stopped, add a new disc
    if discs[#discs].state == "stopped" then
        addDisc()
    end
end

-- update discs collection
function updateDiscs()
    for i, disc in pairs(discs) do
        shootDisc(disc)
    end
end