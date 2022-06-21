--gps distance points
calcGeoDistanceMeters=function(lat1,lon1,lat2,lon2)
 --https://www.ridgesolutions.ie/index.php/2013/11/14/algorithm-to-calculate-speed-from-two-gps-latitude-and-longitude-points-and-time-difference/
 -- radius of earth in meters
 local r=6378100
 -- Convert degrees to radians
 local lat1r = lat1 * (math.pi / 180.0)
 local lon1r = lon1 * (math.pi / 180.0)
 local lat2r = lat2 * (math.pi / 180.0)
 local lon2r = lon2 * (math.pi / 180.0)
 -- P
 local rho1 = r * math.cos(lat1r)
 local z1 = r * math.sin(lat1r)
 local x1 = rho1 * math.cos(lon1r)
 local y1 = rho1 * math.sin(lon1r)
 -- Q
 local rho2 = r * math.cos(lat2r)
 local z2 = r * math.sin(lat2r)
 local x2 = rho2 * math.cos(lon2r)
 local y2 = rho2 * math.sin(lon2r)
 -- Dot product
 local dot = (x1 * x2 + y1 * y2 + z1 * z2)
 local cos_theta = dot / (r * r)
 --
 local theta = math.acos(cos_theta)
 -- Distance in Meters
 return (r * theta)
end

--check if point in polygon
createPickablePolygon=function(points)
 -- Takes in a table with a sequence of ints for the (x, y) of each point of the polygon.
 -- Example: {x1, y1, x2, y2, x3, y3, ...}
 -- Note: no need to repeat the first point at the end of the table, the testing function
 -- already handles that.
 local poly = {}
 local lastX = points[#points-1]
 local lastY = points[#points]
 for index = 1, #points-1, 2 do
  local px = points[index]
  local py = points[index+1]
  -- Only store non-horizontal edges.
  if py ~= lastY then
   local index = #poly
   poly[index+1] = px
   poly[index+2] = py
   poly[index+3] = (lastX - px) / (lastY - py)
  end
  lastX = px
  lastY = py
 end
 return poly
end

isPointInPolygon=function(x, y, poly)
 -- Takes in the x and y of the point in question, and a 'poly' table created by
 -- createPickablePolygon(). Returns true if the point is within the polygon, otherwise false.
 -- Note: the coordinates of the test point and the polygon points are all assumed to be in
 -- the same space.

 -- Original algorithm by W. Randolph Franklin (WRF):
 -- https://wrf.ecse.rpi.edu//Research/Short_Notes/pnpoly.html

 local lastPX = poly[#poly-2]
 local lastPY = poly[#poly-1]
 local inside = false
 for index = 1, #poly, 3 do
  local px = poly[index]
  local py = poly[index+1]
  local deltaX_div_deltaY = poly[index+2]
  -- 'deltaX_div_deltaY' is a precomputed optimization. The original line is:
  -- if ((py > y) ~= (lastPY > y)) and (x < (y - py) * (lastX - px) / (lastY - py) + px) then
  if ((py > y) ~= (lastPY > y)) and (x < (y - py) * deltaX_div_deltaY + px) then
      inside = not inside
  end
  lastPX = px
  lastPY = py
 end
 return inside
end
