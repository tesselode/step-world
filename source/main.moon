export conversation = require('lib.talk').new!

Song = require 'class.gameplay.song'
SongData = require 'class.data.song-data'

songData = SongData 'max 300.sm'
song = Song songData, 'dance-single', 'Hard'

love.update = (dt) ->
	song\update dt

love.keypressed = (key) ->
	song\keypressed key
	love.event.quit! if key == 'escape'

love.draw = ->
	song\draw!
