local w, h = 120, 80
local dw, dh = love.graphics.getDimensions()
local cw, ch = dw/w, dh/h

local game = require("game")
local map = game.random(w, h)
local paused = true

function love.keypressed (key)
  if key == ' ' or key == 'space' then
    if paused == true then
      paused = false
    elseif paused == false then
      paused = true
    end
  end
  return paused
end

function mouseDraw ()
  -- edit map using the mouse
  local x, y = love.mouse.getPosition()
  local x2 = math.ceil(x/cw)
  local y2 = math.ceil(y/ch)
  if love.mouse.isDown('l') then
    map[x2][y2] = 1
    paused = true
  elseif love.mouse.isDown('r') then
    map[x2][y2] = 0
    paused = true
  else
    --paused = false
  end
  return x2, y2
end

function love.load ()
  time = 0
end

function love.update(dt)
  -- edit map using the mouse
  --local x, y = love.mouse.getPosition()
  --local x2 = math.ceil(x/cw)
  --local y2 = math.ceil(y/ch)
  --if love.mouse.isDown('l') then
  --  map[x2][y2] = 1
  --  paused = true
  --elseif love.mouse.isDown('r') then
  --  map[x2][y2] = 0
  --  paused = true
  --else
  --  --paused = false
  --end
  mouseDraw ()
  -- update the map
  if not paused then
    map = game.step(map)
    time = time + 1
  end
end

function love.draw()
  for i = 1, w do
    for j = 1, h do
      if map[i][j] == 1 then
        love.graphics.setColor (0,255,255)
        love.graphics.rectangle('fill', cw*i - cw, ch*j - ch, cw, ch)
      end
    end
  end

  love.graphics.setColor (255,0,0)
  --if paused == false then
    local x, y = love.mouse.getPosition()
    local x2 = math.ceil(x/cw)
    local y2 = math.ceil(y/ch)
    love.graphics.rectangle ('line', x2*(cw)-cw,y2*(ch)-ch, ch,cw)
  --end
  love.graphics.setColor (255,255,255)
  love.graphics.print ("population "..game.getPopulation (map), 10, 10)
  love.graphics.print ("generations "..time, 10, 20)
  if paused == true then
    love.graphics.print ("Press space to pause or unpause, left mouse button to add living cells, and right mouse to 'kill' cells", 10, 30)
  end
end
