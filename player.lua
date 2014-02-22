local player_size = screen.width / 32
player = {
		width = player_size,
		height = player_size,
		yVel = 0,
		jumpVel = (screen.height / 4) * 3,
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
	
	if self.y > screen.height - self.height then
		self.y = screen.height - self.height
		self.yVel = -(self.yVel / 2)
		game.lost = true
	elseif self.y < 0 then
		self.y = 0
		self.yVel = 0
		game.lost = true
	end
end

function player:draw()
	love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	round_rectangle(self.x, self.y, self.width, self.height, screen.width / 120)
end

function player:jump()
	self.yVel = -self.jumpVel
end