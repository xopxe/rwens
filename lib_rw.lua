local math=math
local abs, min = math.abs, math.min

local m = {
  get_random_direction = function ()
    local a = 2 * math.pi * math.random()
    return math.cos(a), math.sin(a)
  end,
  isin_range2 = function (x1,y1,x2,y2, w, R, R2)
    local absdifx = abs(x1-x2)
    local dx = min( absdifx, w - absdifx)
    if dx>R then return false end
    local absdify = abs(y1-y2)
    local dy = min( absdify, w - absdify) 
    if dy>R then return false end
    return (dx^2+dy^2) < R2
  end

}

return m