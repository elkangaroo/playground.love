require('lib')

local app = {}
app.version = 0.1
app.scale = 50
app.orientation = layout_flat
app.layout = nil
app.radius = 3
app.grid = {}

function love.load(...)
  args = {}
  args.mode = 'line'
  args.mouse = nil

  load_layout(app.orientation)
  load_grid()
end

function love.update(dt)

end

function love.draw()
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1, 1)
  love.graphics.setLineWidth(2)
  draw_grid(app.layout, app.grid, args)
end

function love.focus(focused)

end

function love.quit()

end

function love.keypressed(key, scancode, isrepeat)
  if tonumber(key) ~= nil then
    app.radius = tonumber(key)
    load_layout(app.orientation)
    load_grid()
  end

  if 'f' == key then
    app.orientation = layout_flat
    load_layout(app.orientation)
  end
  if 'p' == key then
    app.orientation = layout_pointy
    load_layout(app.orientation)
  end

  if 'escape' == key then
    love.event.push('quit')
  end
end

function love.keyreleased(key, scancode)

end

function love.mousepressed(x, y, button, istouch, presses)

end

function love.mousereleased(x, y, button, istouch, presses)

end

function love.mousemoved(x, y, dx, dy, istouch)
  mouseHex = pixel_to_hex(app.layout, Point(love.mouse.getPosition()))
  args.mouse = hex_round(mouseHex)
end

function love.wheelmoved(dx, dy)
  if dy > 0 or (dy < 0 and app.scale > 10) then
    app.scale = app.scale + dy * 2
    load_layout(app.orientation)
  end
end

function unpack_vertices(vert)
  local list = {}
  for i = 1, #vert do
    table.insert(list, vert[i].x)
    table.insert(list, vert[i].y)
  end
  return list
end

function load_grid()
  app.grid = {}
  for q = - app.radius, app.radius do
    local r1 = math.max(-app.radius, - q - app.radius)
    local r2 = math.min(app.radius, - q + app.radius)
    for r = r1, r2 do
      table.insert(app.grid, Hex(q, r, - q -r))
    end
  end
end

function load_layout(orientation)
  width, height = love.graphics.getDimensions()
  app.layout = Layout(orientation, Point(app.scale, app.scale), Point(width / 2, height / 2))
end

function draw_hex(layout, hex, args)
  local vertices = unpack_vertices(polygon_corners(layout, hex))
  love.graphics.polygon(args.mode, vertices)
end

function draw_grid(layout, grid, args)
  for i = 1, #grid do
    local hex = grid[i]
    love.graphics.setColor(0.8, 0.8, 0.8)
    if args.mouse and hex_equals(hex, args.mouse) then
      draw_hex(layout, hex, {mode = 'fill'})
    else
      draw_hex(layout, hex, {mode = 'line'})
    end
  end
end
