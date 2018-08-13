Song = require 'class.gameplay.song'
SongData = require 'class.data.song-data'

songData = SongData!
songData\load 'paranoia.sm'
song = Song songData, 'dance-single', 'Hard'

love.update = (dt) ->
	song\update dt

love.keypressed = (key) ->
	love.event.quit! if key == 'escape'

love.draw = ->
	song\draw!
