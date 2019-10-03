-- Generated code -- CC0 -- No Rights Reserved -- http://www.redblobgames.com/grids/hexagons/

-- POINT --

function Point(x, y)
  return {x = x, y = y}
end

-- HEX --

function Hex(q, r, s)
  assert(not (math.floor (0.5 + q + r + s) ~= 0), "q + r + s must be 0")
  return {q = q, r = r, s = s}
end

function hex_equals (a, b)
  return a.q == b.q and a.r == b.r and a.s == b.s;
end

function hex_add (a, b)
  return Hex(a.q + b.q, a.r + b.r, a.s + b.s)
end

function hex_subtract (a, b)
  return Hex(a.q - b.q, a.r - b.r, a.s - b.s)
end

function hex_scale (a, k)
  return Hex(a.q * k, a.r * k, a.s * k)
end

function hex_rotate_left (a)
  return Hex(-a.s, - a.q, - a.r)
end

function hex_rotate_right (a)
  return Hex(-a.r, - a.s, - a.q)
end

hex_directions = {
  Hex(1, 0, - 1), Hex(1, - 1, 0), Hex(0, - 1, 1),
  Hex(-1, 0, 1), Hex(-1, 1, 0), Hex(0, 1, - 1)
}
function hex_direction (direction) -- direction from 0 to 5
  return hex_directions[1 + direction]
end

function hex_neighbor (hex, direction)
  return hex_add(hex, hex_direction(direction))
end

hex_diagonals = {
  Hex(2, - 1, - 1), Hex(1, - 2, 1), Hex(-1, - 1, 2),
  Hex(-2, 1, 1), Hex(-1, 2, - 1), Hex(1, 1, - 2)
}
function hex_diagonal_neighbor (hex, direction)
  return hex_add(hex, hex_diagonals[1 + direction])
end

function hex_length (hex)
  return math.floor((math.abs(hex.q) + math.abs(hex.r) + math.abs(hex.s)) / 2)
end

function hex_distance (a, b)
  return hex_length(hex_subtract(a, b))
end

function hex_round (h)
  local qi = math.floor(math.floor (0.5 + h.q))
  local ri = math.floor(math.floor (0.5 + h.r))
  local si = math.floor(math.floor (0.5 + h.s))
  local q_diff = math.abs(qi - h.q)
  local r_diff = math.abs(ri - h.r)
  local s_diff = math.abs(si - h.s)
  if q_diff > r_diff and q_diff > s_diff then
    qi = -ri - si
  else
    if r_diff > s_diff then
      ri = -qi - si
    else
      si = -qi - ri
    end
  end
  return Hex(qi, ri, si)
end

function hex_lerp (a, b, t)
  return Hex(a.q * (1.0 - t) + b.q * t, a.r * (1.0 - t) + b.r * t, a.s * (1.0 - t) + b.s * t)
end

function hex_linedraw (a, b)
  local N = hex_distance(a, b)
  local a_nudge = Hex(a.q + 0.000001, a.r + 0.000001, a.s - 0.000002)
  local b_nudge = Hex(b.q + 0.000001, b.r + 0.000001, b.s - 0.000002)
  local results = {}
  local step = 1.0 / math.max(N, 1)
  for i = 0, N do
    table.insert(results, hex_round(hex_lerp(a_nudge, b_nudge, step * i)))
  end
  return results
end

-- OFFSET --

function OffsetCoord(col, row)
  return {col = col, row = row}
end

EVEN = 1
ODD = -1
function qoffset_from_cube (offset, h)
  local col = h.q
  local row = h.r + math.floor((h.q + offset * (bit32.band(h.q, 1))) / 2)
  return OffsetCoord(col, row)
end

function qoffset_to_cube (offset, h)
  local q = h.col
  local r = h.row - math.floor((h.col + offset * (bit32.band(h.col, 1))) / 2)
  local s = -q - r
  return Hex(q, r, s)
end

function roffset_from_cube (offset, h)
  local col = h.q + math.floor((h.r + offset * (bit32.band(h.r, 1))) / 2)
  local row = h.r
  return OffsetCoord(col, row)
end

function roffset_to_cube (offset, h)
  local q = h.col - math.floor((h.row + offset * (bit32.band(h.row, 1))) / 2)
  local r = h.row
  local s = -q - r
  return Hex(q, r, s)
end

-- DOUBLECORD --

function DoubledCoord(col, row)
  return {col = col, row = row}
end

function qdoubled_from_cube (h)
  local col = h.q
  local row = 2 * h.r + h.q
  return DoubledCoord(col, row)
end

function qdoubled_to_cube (h)
  local q = h.col
  local r = math.floor((h.row - h.col) / 2)
  local s = -q - r
  return Hex(q, r, s)
end

function rdoubled_from_cube (h)
  local col = 2 * h.q + h.r
  local row = h.r
  return DoubledCoord(col, row)
end

function rdoubled_to_cube (h)
  local q = math.floor((h.col - h.row) / 2)
  local r = h.row
  local s = -q - r
  return Hex(q, r, s)
end

-- ORIENTATION --

function Orientation(f0, f1, f2, f3, b0, b1, b2, b3, start_angle)
  return {f0 = f0, f1 = f1, f2 = f2, f3 = f3, b0 = b0, b1 = b1, b2 = b2, b3 = b3, start_angle = start_angle}
end

-- LAYOUT --

function Layout(orientation, size, origin)
  return {orientation = orientation, size = size, origin = origin}
end

layout_pointy = Orientation(math.sqrt(3.0), math.sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, math.sqrt(3.0) / 3.0, - 1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
layout_flat = Orientation(3.0 / 2.0, 0.0, math.sqrt(3.0) / 2.0, math.sqrt(3.0), 2.0 / 3.0, 0.0, - 1.0 / 3.0, math.sqrt(3.0) / 3.0, 0.0)
function hex_to_pixel (layout, h)
  local M = layout.orientation
  local size = layout.size
  local origin = layout.origin
  local x = (M.f0 * h.q + M.f1 * h.r) * size.x
  local y = (M.f2 * h.q + M.f3 * h.r) * size.y
  return Point(x + origin.x, y + origin.y)
end

function pixel_to_hex (layout, p)
  local M = layout.orientation
  local size = layout.size
  local origin = layout.origin
  local pt = Point((p.x - origin.x) / size.x, (p.y - origin.y) / size.y)
  local q = M.b0 * pt.x + M.b1 * pt.y
  local r = M.b2 * pt.x + M.b3 * pt.y
  return Hex(q, r, - q - r)
end

function hex_corner_offset (layout, corner)
  local M = layout.orientation
  local size = layout.size
  local angle = 2.0 * math.pi * (M.start_angle - corner) / 6.0
  return Point(size.x * math.cos(angle), size.y * math.sin(angle))
end

function polygon_corners (layout, h)
  local corners = {}
  local center = hex_to_pixel(layout, h)
  for i = 0, 5 do
    local offset = hex_corner_offset(layout, i)
    table.insert(corners, Point(center.x + offset.x, center.y + offset.y))
  end
  return corners
end
