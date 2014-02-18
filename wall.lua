local wall_width = screen.width / 10

wall = {
		d = {},
		space = 200,
		width = wall_width,
		tick = 0,
		spawn_rate = 1.5,
		extra = 30
	}

function wall:spawn(x, y)
	self.d[#self.d + 1] = {
			{x = x, y = -self.extra, width = self.width, height = y + self.extra},
			{x = x, y = y + self.space, width = self.width, height = screen.height - (y + self.space) + self.extra}
		}
end

function wall:clear()
	self.d = nil
	self.d = {}
end

function wall:update(dt)
	--spawning
	self.tick = self.tick + dt
	if self.tick > self.spawn_rate then
		wall:spawn(screen.width, love.math.random(10, screen.height - self.space - 10))
		self.tick = 0
	end

	for i,v in ipairs(self.d) do
		local rem = false
		for _,s in ipairs(v) do
			s.x = s.x - game.speed * dt
			if (s.x + s.width) < 0 then
				rem = true
			end
		end
		if rem then
			table.remove(self.d, i)
		end
	end
end

function wall:draw()
	for i,v in ipairs(self.d) do
		for _,s in ipairs(v) do
			love.graphics.setColor(146, 201, 87, 255)
			--love.graphics.rectangle("fill", s.x, s.y, s.width, s.height)
			round_rectangle(s.x, s.y, s.width, s.height, 12)
		end
	end
end