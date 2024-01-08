-- Pico-8 game template

function _init()
    -- Initialize game state
   
    board = {
        outerCircleRadius = 12,  -- Outer circle radius
        middleCircleRadius = 8,  -- Middle circle radius
        innerCircleRadius = 4,   -- Inner circle radius
        centerHoleRadius = 0.8,  -- Center hole radius
        scalingFactor = 4,       -- Scaling factor
    }

    disc = {
        x = 64,          -- Initial x position (center of the board)
        y = 64 + (board.outerCircleRadius) * board.scalingFactor,  -- Initial y position (bottom center of the outer circle)
        radius = 2,      -- Disc radius
        speed = 3,       -- Initial speed
        angle = 0.75,      -- Initial angle (facing upward)
        slowingFactor = 0.95,  -- Rate at which the disc slows down
        state = "selectPosition",  -- Initial state
    }
end

function _draw()
    cls()
    drawBoard(board)
    drawDisc()
end

function drawDisc()
    circfill(disc.x, disc.y, disc.radius, 9)  -- Color 9 is yellow
    if disc.state == "selectAngle" then
        local lineLength = 5
        for i = 0, lineLength, 0.5 do
            local x = disc.x + i * cos(disc.angle)
            local y = disc.y - i * sin(disc.angle)
            pset(x, y, 7)  -- Color 7 is white (dotted line)
        end
    end
end

function drawBoard(board)
    local scalingFactor = board.scalingFactor

    -- Draw the outer filled circle in red
    circfill(64, 64, board.outerCircleRadius * scalingFactor, 8)  -- Color 8 is red

    -- Draw the middle filled circle in blue
    circfill(64, 64, board.middleCircleRadius * scalingFactor, 12)  -- Color 12 is blue

    -- Draw the board filled circle in green
    circfill(64, 64, board.innerCircleRadius * scalingFactor, 11)  -- Color 11 is green

    -- Draw the inner filled circle (center hole) in black
    circfill(64, 64, board.centerHoleRadius * scalingFactor, 0)  -- Color 0 is black

    -- Draw the outer circle
    circ(64, 64, board.outerCircleRadius * scalingFactor, 7)

    -- Draw the board circle
    circ(64, 64, board.innerCircleRadius * scalingFactor, 7)

    -- Draw the middle circle
    circ(64, 64, board.middleCircleRadius * scalingFactor, 7)

    -- Draw the inner circle (center hole)
    circ(64, 64, board.centerHoleRadius * scalingFactor, 7)

    -- Draw lines at 45, 135, 225, and 315 degrees (in Pico-8's turns)
    local function drawRotatedLine(turns)
        local x1 = 64 + board.middleCircleRadius * scalingFactor * cos(turns)
        local y1 = 64 - board.middleCircleRadius * scalingFactor * sin(turns)
        local x2 = 64 + board.outerCircleRadius * scalingFactor * cos(turns)
        local y2 = 64 - board.outerCircleRadius * scalingFactor * sin(turns)
        line(x1, y1, x2, y2, 7)
    end

    drawRotatedLine(0.125)  -- 45 degrees
    drawRotatedLine(0.375)  -- 135 degrees
    drawRotatedLine(0.625)  -- 225 degrees
    drawRotatedLine(0.875)  -- 315 degrees
end

function chooseStartingPosition()
    -- Move the disc to the left
    if btn(0) then
        disc.x = disc.x - 1
    end

    -- Move the disc to the right
    if btn(1)  then
        disc.x = disc.x + 1
    end

    -- Select position and move to angle selection
    if btnp(5) then  -- 'x' key
        disc.state = "selectAngle"
    end
end

-- Function to choose the shooting angle between 0 and 180 degrees
function chooseShootingAngle()
    -- Rotate the disc angle to the left
    if btn(0) then
        disc.angle = disc.angle - 0.01
    end

    -- Rotate the disc angle to the right
    if btn(1) then
        disc.angle = disc.angle + 0.01
    end

    -- Ensure the angle is between 0 and 180 degrees
   -- disc.angle = mid(0, disc.angle, 180)

    -- Shoot the disc and move to the moving state
    if btnp(5) then  -- 'x' key
        disc.state = "moving"
    end
end

-- Function to shoot the disc and transition between states
function shootDisc()
    if disc.state == "selectPosition" then
        chooseStartingPosition()
    elseif disc.state == "selectAngle" then
        chooseShootingAngle()
    elseif disc.state == "moving" then
        moveDisc()
    elseif disc.state == "stopped" then
        -- make a new disc
    end
end

function moveDisc()
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
    shootDisc()
end