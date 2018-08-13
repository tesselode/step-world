Song = require 'class.song'

paranoia = Song!
paranoia\load 'paranoia.sm'

scrollY = 0

love.update = (dt) ->
	scrollY -= 100 * dt if love.keyboard.isDown 'up'
	scrollY += 100 * dt if love.keyboard.isDown 'down'

love.keypressed = (key) ->
	love.event.quit! if key == 'escape'

love.draw = -> with love.graphics
	.push 'all'
	.scale 2
	.translate 0, -scrollY
	paranoia.charts['dance-single']['Hard']\drawDebug!
	.pop!
