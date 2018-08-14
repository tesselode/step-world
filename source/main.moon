SongData = require 'class.data.song-data'

songData = SongData 'max 300.sm'

love.keypressed = (key) ->
	love.event.quit! if key == 'escape'
