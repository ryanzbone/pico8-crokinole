-- Pico-8 game template

function _init()
    -- Initialize game state
    disc = {
        x = 64,          -- Initial x position (bottom center of the board)
        y = 120,         -- Initial y position (bottom center of the board)
        radius = 2,      -- Disc radius
        speed = 3,       -- Initial speed
        angle = 0.75,      -- Initial angle (facing upward)
        slowingFactor = .95,  -- Rate at which the disc slows down
        shooting = false,  -- Flag to check if the disc is currently shooting
    }
        
end

function _draw()
    cls()
    drawBoard()
    drawDisc()

end

function drawDisc()
    circfill(disc.x, disc.y, disc.radius, 9)  -- Color 9 is yellow
end


function drawBoard()
-- Clear the screen

-- Define scaling factor (adjust as needed)
local scalingFactor = 4  -- Adjust this value based on your preference

-- Define dimensions in inches
local outerCircleRadius = 12 * scalingFactor
local boardRadius = 4 * scalingFactor
local middleCircleRadius = 8 * scalingFactor
local centerHoleRadius = 1.375 * scalingFactor

-- Draw the outer filled circle in red
circfill(64, 64, outerCircleRadius, 8)  -- Color 8 is red


-- Draw the middle filled circle in blue
circfill(64, 64, middleCircleRadius, 12)  -- Color 12 is blue

-- Draw the board filled circle in green

circfill(64, 64, boardRadius, 11)  -- Color 11 is green

-- Draw the inner filled circle (center hole) in black
circfill(64, 64, centerHoleRadius, 0)  -- Color 0 is black


-- Draw the outer circle
circ(64, 64, outerCircleRadius, 7)

-- Draw the board circle
circ(64, 64, boardRadius, 7)

-- Draw the middle circle
circ(64, 64, middleCircleRadius, 7)

-- Draw the inner circle (center hole)
circ(64, 64, centerHoleRadius, 7)

-- Draw lines at 45, 135, 225, and 315 degrees (in Pico-8's turns)
local function drawRotatedLine(turns)
    local x1 = 64 + middleCircleRadius * cos(turns)
    local y1 = 64 - middleCircleRadius * sin(turns)
    local x2 = 64 + outerCircleRadius * cos(turns)
    local y2 = 64 - outerCircleRadius * sin(turns)
    line(x1, y1, x2, y2, 7)
end

drawRotatedLine(0.125)  -- 45 degrees
drawRotatedLine(0.375)  -- 135 degrees
drawRotatedLine(0.625)  -- 225 degrees
drawRotatedLine(0.875)  -- 315 degrees

end 

function _update()
    if disc.shooting then
        -- Update disc position and speed
        disc.x = disc.x + disc.speed * cos(disc.angle)
        disc.y = disc.y - disc.speed * sin(disc.angle)
        disc.speed = disc.speed * disc.slowingFactor

        -- Check if the disc has come to a stop
        if disc.speed < 0.1 then
            disc.shooting = false
            disc.speed = 0
        end
    else
        -- Player input to shoot the disc
        if btnp(5) then  -- 'x' key
            disc.shooting = true
        end
    end
end
