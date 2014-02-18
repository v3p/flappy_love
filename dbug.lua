dbug = {}

love.filesystem.setIdentity(love.window.getTitle())

local config = {
		fps = {show = true, x = 12, y = screen.height - 24, color = {255, 255, 255, 255}},
		font = love.graphics.newFont(12),
		log = {enabled = false}
	}
local _log_file = "dbug_log.txt"
local log_file = love.filesystem.newFile(_log_file)



local console = {
		show = true,
		x = 12,
		y = love.graphics.getHeight() - 24,
		line_height = 24,
		lines = {},
		max_lines = 12,
		alpha = 255,
		fade_speed = 1024,
		duration = 3
	}
local color = {
		text = {255, 255, 255}
	}
	
function dbug.init()
	--if not love.filesystem.exists(_log_file) then dbug.writeToLog("Log file created.", "dbug") end
	--dbug.writeToLog("Game Initialized.", "dbug")
end

function dbug.print(text, _color, duration)
	_color = _color or color.text
	duration = duration or console.duration
	console.lines[#console.lines + 1] = {text = text, color = _color, alpha = _color[4] or console.alpha, duration = duration, gone = false, tick = 0} 
	print(text)
	fix_lines()
	dbug.writeToLog("Console: "..text, "dbug")
end
	
function dbug.update(dt)
	for i,v in ipairs(console.lines) do
		v.tick = v.tick + dt
		if v.tick > v.duration then
			v.alpha = v.alpha - console.fade_speed * dt
			if v.alpha < 0 then
				v.alpha = 0
				table.remove(console.lines, i)
			end
		end
	end
end

function dbug.draw()
	love.graphics.setFont(config.font)
	--console
	for i,v in ipairs(console.lines) do
		love.graphics.setColor(v.color[1], v.color[2], v.color[3], v.alpha)
		love.graphics.print(v.text, v.x, v.y)
	end
	love.graphics.setColor(255, 255, 255, 255)

	--FPS
	if config.fps.show then
		love.graphics.setColor(config.fps.color)
		love.graphics.print(love.timer.getFPS(), config.fps.x, config.fps.y)
	end
end

--LOCAL METHODS
function fix_lines()
	for i,v in ipairs(console.lines) do
		v.y = console.y - (console.line_height * #console.lines) + (i * console.line_height)
		v.x = console.x
		v.alpha = (255 / #console.lines) * i
	end
	
	if #console.lines > console.max_lines then table.remove(console.lines, 1) end
end

function dbug.writeToLog(text, source)
	source = source or "user"
	if source == "user" then text = "user: "..text end
	local d = os.date("%c")
	text = d.." "..text
	log_file:open("a")
	log_file:write("\r\n"..text)
	log_file:close()
end

function dbug.quit()
	dbug.writeToLog("Game Closed.", "dbug")
end

return dbug


















