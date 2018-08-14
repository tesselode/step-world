SongData = require 'class.data.song-data'

songData = SongData 'max 300.sm'
for note in *songData.charts['dance-single']['Hard'].notes
	with note
		print .position, .time

love.keypressed = (key) ->
	love.event.quit! if key == 'escape'
