push = require 'lib.push'
Class = require 'lib.hump.class'

require 'src.Paddle'
require 'src.Ball'

local config = require 'config'



function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Pong')

	math.randomseed(os.time())

	love.graphics.setFont(config.fonts.NORMAL)

	push:setupScreen(
		config.window.VIRTUAL_WIDTH,
		config.window.VIRTUAL_HEIGHT,
		config.window.DEFAULT_WIDTH,
		config.window.DEFAULT_HEIGHT,
		{
			fullscreen = false,
			resizable = true,
			vsync = true,
			canvas = false
		}
	)

	player1 = Paddle(
		config.player1.INITIAL_POS_X,
		config.player1.INITIAL_POS_Y,
		config.window.VIRTUAL_WIDTH,
		config.window.VIRTUAL_HEIGHT
	)
    player2 = Paddle(
		config.player2.INITIAL_POS_X,
		config.player2.INITIAL_POS_Y,
		config.window.VIRTUAL_WIDTH,
		config.window.VIRTUAL_HEIGHT
	)
	ball = Ball(
		config.window.VIRTUAL_WIDTH,
		config.window.VIRTUAL_HEIGHT
	)

	player1Score = 0
    player2Score = 0

	servingPlayer = math.random(2)
	winningPlayer = 0

	gameState = 'start'
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.update(dt)
	if gameState == 'serve' then
		ball:servedBy(servingPlayer)
	elseif gameState == 'play' then
		if ball:collides(player1) or ball:collides(player2) then
			ball:hitBack(config.difficultRate)
			config.sounds.paddle_hit:play()
		end
		ball:checkVerticalBoundary()
	end

	if ball.x < 0 then
		servingPlayer = 1
		player2Score = player2Score + 1
		config.sounds['score']:play()

		ball:reset()
		if player2Score == 10 then
			winningPlayer = 2
			gameState = 'done'
		else
			gameState = 'serve'
		end
	end

	if ball.x > config.window.VIRTUAL_WIDTH then
		servingPlayer = 2
		player1Score = player1Score + 1
		config.sounds['score']:play()

		ball:reset()
		if player1Score == 10 then
			winningPlayer = 1
			gameState = 'done'
		else
			gameState = 'serve'
		end
	end

	if love.keyboard.isDown('w') then
		player1:setDirection('up')
	elseif love.keyboard.isDown('s') then
		player1:setDirection('down')
	else
		player1:stop()
	end

	if love.keyboard.isDown('up') then
		player2:setDirection('up')
	elseif love.keyboard.isDown('down') then
		player2:setDirection('down')
	else
		player2:stop()
	end

	if gameState == 'play' then
		ball:update(dt)
	end

	player1:update(dt)
	player2:update(dt)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		elseif gameState == 'done' then
			gameState = 'serve'

			player1Score = 0
			player2Score = 0

			if winningPlayer == 1 then
				servingPlayer = 2
			else
				servingPlayer = 1
			end
		end
	end
end

function love.draw()
	-- given that push is being used we have to use the vitual dimensions in this part to print properly
	push:start()

	love.graphics.clear(40/255, 45/255, 52/255, 255/255)

	if gameState == 'start' then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(config.fonts.NORMAL)
		love.graphics.printf(
			config.text.WELCOME, 0, 10, config.window.VIRTUAL_WIDTH, 'center'
		)
		love.graphics.printf(
			config.text.BEGIN_INSTRUCTION, 0, 20, config.window.VIRTUAL_WIDTH, 'center'
		)
	elseif gameState == 'serve' then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(config.fonts.NORMAL)
		love.graphics.printf(
			servingPlayerMessage(), 0, 10, config.window.VIRTUAL_WIDTH, 'center'
		)
        love.graphics.printf(
			config.text.SERVE_INSTRUCTION, 0, 20, config.window.VIRTUAL_WIDTH, 'center'
		)
	elseif gameState == 'done' then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(config.fonts.BIG)
		love.graphics.printf(
			winngPlayerMessage(), 0, 10, config.window.VIRTUAL_WIDTH, 'center'
		)
		love.graphics.setFont(config.fonts.NORMAL)
		love.graphics.printf(
			config.text.RESTART_INSTRUCTION, 0, 30, config.window.VIRTUAL_WIDTH, 'center'
		)
	end

	displayScore()

	player1:render()
	player2:render()
	ball:render()

	displayFps()

	push:finish()
end

function displayFps()
	love.graphics.setFont(config.fonts.NORMAL)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.printf(
		'FPS: ' .. tostring(love.timer.getFPS()), 0, 2, config.window.VIRTUAL_WIDTH, 'center'
	)
end

function displayScore()
	love.graphics.setFont(config.fonts.X_BIG)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(
		tostring(player1Score), config.player1.SCORE_POS_X, config.player1.SCORE_POS_Y
	)
	love.graphics.print(
		tostring(player2Score), config.player2.SCORE_POS_X, config.player2.SCORE_POS_Y
	)
end

function servingPlayerMessage()
	return 'Player ' .. tostring(servingPlayer) .. 's serve!'
end

function winngPlayerMessage()
	return 'Player ' .. tostring(winningPlayer) .. ' wins!'
end
