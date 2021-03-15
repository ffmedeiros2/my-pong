
Paddle = Class{
    width = 5,
    height = 20,
    speed = 200
}

function Paddle:init(x, y, windowWidth, windowHeight)
    self.x = x
    self.y = y
    self.windowWidth = windowWidth
    self.windowHeight = windowHeight
    self.dy = 0
end

function Paddle:setDirection(direction)
    if direction == 'up' then
        self.dy = -1 * self.speed
    elseif direction == 'down' then
        self.dy = self.speed
    end
end

function Paddle:stop()
    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy*dt)
    else
        self.y = math.min(self.windowHeight - Paddle.height, self.y + self.dy*dt)
    end
end

function Paddle:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, Paddle.width, Paddle.height)
end
