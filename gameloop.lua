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
        color = 2,  -- Initial color (red)
        vx = 0,  -- x velocity
        vy = 0,  -- y velocity
        mass = 1,  -- mass of the disc (all discs have the same mass for simplicity)
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
    circfill(disc.x, disc.y, disc.radius, disc.color)  -- Color 9 is yellow
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
        local speed = disc.speed * disc.powerMultiplier
        disc.vx = speed * cos(disc.angle)
        disc.vy = -speed * sin(disc.angle)
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
    -- Update position based on velocity
    local newX = disc.x + disc.vx
    local newY = disc.y + disc.vy
    
    local collision = false
    for i, otherDisc in pairs(discs) do
        if otherDisc ~= disc and otherDisc.state ~= "selectPosition" then
            if checkCollision({x=newX, y=newY, radius=disc.radius}, otherDisc) then
                collision = true
                resolveCollision(disc, otherDisc)
                -- Set the other disc to "moving" state if it was stopped
                if otherDisc.state == "stopped" then
                    otherDisc.state = "moving"
                    otherDisc.color = 2  -- Change color back to red (or whatever color you use for moving discs)
                end
            end
        end
    end
    
    -- Update position
    disc.x = newX
    disc.y = newY
    
    -- Apply friction
    local friction = 0.95
    disc.vx = disc.vx * friction
    disc.vy = disc.vy * friction
    
    -- Check if the disc has come to a stop
    if abs(disc.vx) < 0.1 and abs(disc.vy) < 0.1 then
        disc.state = "stopped"
        disc.vx = 0
        disc.vy = 0
        disc.color = 12  -- Change color to blue
    end
end
function resolveCollision(disc1, disc2)
    local dx = disc2.x - disc1.x
    local dy = disc2.y - disc1.y
    local distance = sqrt(dx*dx + dy*dy)
    
    -- Normal vector
    local nx = dx / distance
    local ny = dy / distance
    
    -- Relative velocity
    local rvx = disc2.vx - disc1.vx
    local rvy = disc2.vy - disc1.vy
    
    -- Velocity along the normal
    local velAlongNormal = rvx * nx + rvy * ny
    
    -- Do not resolve if velocities are separating
    if velAlongNormal > 0 then return end
    
    -- Coefficient of restitution (1 for perfectly elastic collisions)
    local e = 0.8
    
    -- Calculate impulse scalar
    local j = -(1 + e) * velAlongNormal
    j = j / (1/disc1.mass + 1/disc2.mass)
    
    -- Apply impulse
    disc1.vx = disc1.vx - (j * nx) / disc1.mass
    disc1.vy = disc1.vy - (j * ny) / disc1.mass
    disc2.vx = disc2.vx + (j * nx) / disc2.mass
    disc2.vy = disc2.vy + (j * ny) / disc2.mass
    
    -- Move discs apart to prevent sticking
    local percent = 0.2 -- usually 20% to 80% of the overlap
    local slop = 0.01 -- usually 0.01 to 0.1
    local penetration = 2 * disc1.radius - distance
    if penetration > slop then
        local correction = (penetration / (disc1.mass + disc2.mass)) * percent
        disc1.x = disc1.x - correction * nx * disc1.mass
        disc1.y = disc1.y - correction * ny * disc1.mass
        disc2.x = disc2.x + correction * nx * disc2.mass
        disc2.y = disc2.y + correction * ny * disc2.mass
    end
end


-- Function to check if two discs are colliding
function checkCollision(disc1, disc2)
    local distance = sqrt((disc1.x - disc2.x)^2 + (disc1.y - disc2.y)^2)
    if distance < disc1.radius + disc2.radius then
        return true
    else
        return false
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