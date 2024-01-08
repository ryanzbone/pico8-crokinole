-- Pico-8 game template

function _init()
    -- Initialize game state
    
end

function _draw()
 -- Clear the screen
    cls()

    -- Define scaling factor (adjust as needed)
    local scalingFactor = 3  -- Adjust this value based on your preference

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

    -- Draw lines at 0, 90, 180, and 270 degrees
    -- for _, angle in ipairs({0, 90, 180, 270}) do
    --     local x1 = 64 + middleCircleRadius * cos(angle * 3.14159 / 180)
    --     local y1 = 64 + middleCircleRadius * sin(angle * 3.14159 / 180)
    --     local x2 = 64 + outerCircleRadius * cos(angle * 3.14159 / 180)
    --     local y2 = 64 + outerCircleRadius * sin(angle * 3.14159 / 180)
    --     line(x1, y1, x2, y2, 7)
    -- end

    line(64, 64 - middleCircleRadius, 64, 64 - outerCircleRadius, 7)
    line(64 + middleCircleRadius, 64, 64 + outerCircleRadius, 64, 7)
    line(64, 64 + middleCircleRadius, 64, 64 + outerCircleRadius, 7)
    line(64 - middleCircleRadius, 64, 64 - outerCircleRadius, 64, 7)
    

end 

function _update()
    -- Update game logic
end

