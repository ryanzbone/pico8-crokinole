-- Pico-8 game template

function _init()
    -- Initialize game state
    
end

function _draw()
-- Clear the screen
-- Clear the screen
cls()

-- Define scaling factor (adjust as needed)
local scalingFactor = 4  -- Adjust this value based on your preference

-- Define dimensions in inches
local outerCircleRadius = 12 * scalingFactor
local boardRadius = 4 * scalingFactor
local middleCircleRadius = 8 * scalingFactor
local centerHoleRadius = 1.375 * scalingFactor

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
    -- Update game logic
end

