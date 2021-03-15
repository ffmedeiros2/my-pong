local config = require "my-pong.bin.config"

Ball = Class{
    width = 4,
    height = 4,
    hitBackFactor = 2
}

function Ball:init(windowWidth, windowHeight)
    self.windowWidth = windowWidth
    self.windowHeight = windowHeight
    
    self:reset()
end

function Ball:reset()
    self.x = self.windowWidth/2 - self.width
    self.y = self.windowHeight/2 - self.height
    -- self.dx = math.random(2) == 1 and 100 or -100
    -- self.dy = math.random(-50, 50)
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + Ball.width then
        return false
    end
    if self.y > paddle.y + paddle.height or paddle.y > self.y + Ball.height then
        return false
    end
    return true
end

function Ball:servedBy(player)
    self.dy = math.random(-50, 50)
    ball.dx = player == 1 and math.random(140, 200) or -math.random(140, 200)
end

function Ball:hitBack(rate)
    self.dx = -self.dx*(1 + rate)
    self.x = self.dx > 0 and self.x + (Ball.width + Ball.hitBackFactor) or
        self.x - (Ball.width + Ball.hitBackFactor)

    ball.dy = self.dy > 0 and math.random(10, 150) or -math.random(10, 150)
end

function Ball:checkVerticalBoundary()
    if self.y <= 0 then
        self.y = Ball.hitBackFactor
        self.dy = -self.dy
        config.sounds.wall_hit:play()
    end

    if self.y >= self.windowHeight - Ball.height then
        self.y = self.windowHeight - (Ball.height + Ball.hitBackFactor)
        self.dy = -self.dy
        config.sounds.wall_hit:play()
    end
end

function Ball:update(dt)
    self.x = self.x + self.dx*dt
    self.y = self.y + self.dy*dt
end

function Ball:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, Ball.width, Ball.height)
end
