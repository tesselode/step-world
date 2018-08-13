NoteField = require 'class.gameplay.note-field'
SongData = require 'class.data.song-data'

songData = SongData!
songData\load 'paranoia.sm'
noteField = NoteField songData.charts['dance-single']['Hard']

love.update = (dt) ->
	noteField\update dt

love.keypressed = (key) ->
	love.event.quit! if key == 'escape'

love.draw = ->
	noteField\draw!
