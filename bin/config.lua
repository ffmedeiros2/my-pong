local _M = {}

local RETRO_FONT = 'assets/fonts/font.ttf'

_M.difficultRate = 0.03

_M.window = {
    DEFAULT_WIDTH = 1280,
    DEFAULT_HEIGHT = 720,
    VIRTUAL_WIDTH = 432,
    VIRTUAL_HEIGHT = 243
}

_M.fonts = {
    NORMAL = love.graphics.newFont(RETRO_FONT, 8),
    BIG = love.graphics.newFont(RETRO_FONT, 16),
    X_BIG = love.graphics.newFont(RETRO_FONT, 32)
}

_M.player1 = {
    INITIAL_POS_X = 10,
    INITIAL_POS_Y = 30,
    SCORE_POS_X = _M.window.VIRTUAL_WIDTH/2 - 50,
    SCORE_POS_Y = _M.window.VIRTUAL_HEIGHT/3
}

_M.player2 = {
    INITIAL_POS_X = _M.window.VIRTUAL_WIDTH - 10,
    INITIAL_POS_Y = _M.window.VIRTUAL_HEIGHT - 30,
    SCORE_POS_X = _M.window.VIRTUAL_WIDTH/2 + 30,
    SCORE_POS_Y = _M.window.VIRTUAL_HEIGHT/3
}

_M.text = {
    WELCOME = 'Welcome to Pong!',
    BEGIN_INSTRUCTION = 'Press Enter to Begin!',
    SERVE_INSTRUCTION = 'Press Enter to Serve!',
    RESTART_INSTRUCTION = 'Press Enter to restart!'
}

_M.sounds = {
    paddle_hit = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
    score = love.audio.newSource('assets/sounds/score.wav', 'static'),
    wall_hit = love.audio.newSource('assets/sounds/wall_hit.wav', 'static')
}

return _M
