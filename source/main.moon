SongData = require 'class.data.song-data'

songData = SongData 'max 300.sm'
print #songData.charts['dance-single']['Hard'].notes

love.keypressed = (key) ->
	love.event.quit! if key == 'escape'
