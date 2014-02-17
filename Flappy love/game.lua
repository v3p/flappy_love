local i = love.graphics.newImage("data/img/bg.png")

local c_images = {}
for i=1, 3 do
	c_images[#c_images + 1] = love.graphics.newImage("data/img/cloud/"..i..".png")
end
game = {
	gravity = 1000,
	speed = 400,
	font = {love.graphics.newFont(64), love.graphics.newFont(32)},
	bg = {
			img = i,
			s = {
				{x = 0},
				{x = i:getWidth()}
			}
		},
	cloud = {},
	cloud_tick = 0,
	cloud_spawnRate_ = {2, 12},
	cloud_spawnRate = 5,
	started = false,
	lost = false,
	canvas = love.graphics.newCanvas(screen.width, screen.height),
	score = 0,
	dead_wait = 1,
	dead_tick = 0,
	dead_skip = false
}

function game:initialize()
	love.graphics.setBackgroundColor(hsl(140, 150, 126))
	player:initialize((screen.width / 4) * 1, (screen.height / 2) - (player.width / 2))
end

function game:reset()
	player:initialize((screen.width / 4) * 1, (screen.height / 2) - (player.width / 2))
	self.started = false
	self.lost = false
	wall:clear()
	self.score = 0
	self.dead_skip = false
end

function game:update(dt)
	if game.lost then
		dt = dt * 0.05
		self.dead_tick = self.dead_tick + (dt * 12)
		if self.dead_tick > self.dead_wait then
			self.dead_skip = true
			self.dead_tick = 0
		end
	end
	if self.started then
		player:update(dt)
		wall:update(dt)
	end

	for i,v in ipairs(self.bg.s) do
		v.x = v.x - (self.speed / 8) * dt
		if v.x < -self.bg.img:getWidth() then
			v.x = self.bg.img:getWidth()
		end
	end

	--Clouds
	self.cloud_tick = self.cloud_tick + dt
	if self.cloud_tick > self.cloud_spawnRate then
		self.cloud[#self.cloud + 1] = {
				x = screen.width,
				y = love.math.random(0, 300),
				speed = love.math.random(0, 64),
				img = c_images[love.math.random(1, 3)]
			}
	
		self.cloud_tick = 0
		self.cloud_spawnRate = love.math.random(self.cloud_spawnRate_[1], self.cloud_spawnRate_[2])
	end
	
	for i,v in ipairs(self.cloud) do
		v.x = v.x - (self.speed + v.speed) / 5 * dt
		if v.x < -v.img:getWidth() then
			table.remove(self.cloud, i)
		end
	end
	
	--Collision
	if not game.lost then
		for i,v in ipairs(wall.d) do
			local col = false
			for _,s in ipairs(v) do
				if checkCollision(player.x, player.y, player.width, player.height, s.x, s.y, s.width, s.height) then
					col = true
				end
			end
			if col then
				game.lost = true
			end
		end
	end
	
	--game
	self.score = self.score + dt

end

function game:draw()
	self.canvas:clear()
	love.graphics.setCanvas(self.canvas)
	
	for i,v in ipairs(self.bg.s) do
		love.graphics.draw(self.bg.img, v.x, 0)
	end
	for i,v in ipairs(self.cloud) do
		love.graphics.setColor(255, 255, 255, 180)
		love.graphics.draw(v.img, v.x, v.y)
	end
	wall:draw()
	player:draw()
	
	love.graphics.setCanvas()
	
	if self.lost then love.graphics.setShader(blackwhite) end
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas)
	love.graphics.setShader()
	if self.lost then
		love.graphics.setColor(180, 0, 0, 255)
		love.graphics.setFont(self.font[1])
		love.graphics.print("Wasted", (screen.width / 2) - (love.graphics.getFont():getWidth("Wasted") / 2), (screen.height / 2) - (love.graphics.getFont():getHeight() / 2))
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.setFont(self.font[2])
		love.graphics.print("Score: "..math.floor(self.score), (screen.width / 2) - (love.graphics.getFont():getWidth("Score: "..math.floor(self.score)) / 2), (screen.height / 2) - (love.graphics.getFont():getHeight() / 2) + 64)
	else
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.setFont(self.font[2])
		love.graphics.print("Score: "..math.floor(self.score), 16, 16)
	end
end

function game:keypressed(key)
	if not self.starter then self.started = true end
	if self.lost and self.dead_skip then
		game:reset()
	end
	if key == "w" or key == "up" or key == " " then
		if not self.lost then
			player:jump()
		end
	end
end

function game:mousepressed(x, y, key)
	if key == "l" then
		
	end
end