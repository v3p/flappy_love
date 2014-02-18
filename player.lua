local player_size = screen.width / 32
player = {
		width = player_size,
		height = player_size,
		yVel = 0,
		jumpVel = 500,
		maxVel = 1000
	}

function player:initialize(x, y)
	self.x = x
	self.y = y
end

function player:update(dt)
	self.yVel = self.yVel + game.gravity * dt
	if self.yVel > self.maxVel then
		self.yVel = self.maxVel
	end
	
	self.y = self.y + self.yVel * dt
	
	if self.y < 0 or (self.y + self.height) > screen.height then
		game.lost = true
	end
end

function player:draw()
	love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	round_rectangle(self.x, self.y, self.width, self.height, 6)
end

function player:jump()
	self.yVel = -self.jumpVel
end