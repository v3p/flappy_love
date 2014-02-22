screen = {
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}

--Loading Files
tween = require("tween")
require "dbug"
require "player"
require "wall"
require "game"
require "menu"	

--File stuff
save_file = {}
save = love.filesystem.newFile("save.txt")
if love.filesystem.exists("save.txt") then
	for line in save:lines() do
		local s = line:find("=")
		line = line:sub(s + 1)
		save_file[#save_file + 1] = line
	end
end

	
local state = {
		game = "game",
		menu = "menu"
	}
	
local game_state = state.game
	
function love.load()
	game:initialize()
	dbug.init()
end

function love.update(dt)
	if game_state == state.game then
		game:update(dt)
	elseif game_state == state.menu then
		menu:update(dt)
	end
	dbug.update(dt)
	tween.update(dt)
end

function love.draw()
	if game_state == state.game then
		game:draw()
	elseif game_state == state.menu then
		menu:draw()
	end
	dbug.draw()
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == "g" then
		dbug.print("New high score!", {146, 201, 87})
	end
	if game_state == state.game then
		game:keypressed(key)
	elseif game_state == state.menu then
		menu:keypressed(key)
	end
end

function love.resize(w, h)
	screen.width, screen.height = w, h
end

function love.mousepressed(x, y, key)
	if game_state == state.game then
		game:mousepressed(x, y, key)
	elseif game_state == state.menu then
		menu:mousepressed(x, y, key)
	end
end

function getDistance(x1, y1, x2, y2)
	local dx = x1-x2
	local dy = y1-y2
	return math.sqrt((dx * dx + dy * dy))
end

function hsl(h, s, l, a)
	if type(h) == "table" then
		h,s,l,a = h[1], h[2], h[3], h[4] or 255
	end
    if s<=0 then return l,l,l,a end
    h, s, l = h/256*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	if type(x1) == "table" then
		box_1 = x1
		box_2 = x2
		x1 = box_1[1]
		y1 = box_1[2]
		w1 = box_1[3]
		h1 = box_1[3]
		
		x2 = box_2[1]
		y2 = box_2[2]
		w2 = box_2[3]
		h2 = box_2[3]	
	end

  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function round_rectangle(x, y, width, height, radius)
	--RECTANGLES
	love.graphics.rectangle("fill", x + radius, y, width - (radius * 2), height)
	love.graphics.rectangle("fill", x, y + radius, radius, height - (radius * 2))
	love.graphics.rectangle("fill", x + (width - radius), y + radius, radius, height - (radius * 2))
	
	--ARCS
	love.graphics.arc("fill", x + radius, y + radius, radius, math.rad(-180), math.rad(-90))
	love.graphics.arc("fill", x + width - radius , y + radius, radius, math.rad(-90), math.rad(0))
	love.graphics.arc("fill", x + radius, y + height - radius, radius, math.rad(-180), math.rad(-270))
	love.graphics.arc("fill", x + width - radius , y + height - radius, radius, math.rad(0), math.rad(90))
end

--SHADERS
blackwhite = love.graphics.newShader([[
		vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
        {
			vec4 pixel = Texel(tex, tc);
			number p = (pixel.r + pixel.g + pixel.b) / 3.0;
			pixel.r = p;
			pixel.g= p;
			pixel.b = p;
			return pixel;
		}
	]])

