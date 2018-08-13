NoteField = require 'class.gameplay.note-field'

class Song
	new: (@songData, chartType, difficulty) =>
		@noteField = NoteField @songData, @songData.charts[chartType][difficulty]
		with @music = love.audio.newSource @songData.tags['MUSIC'], 'stream'
			\play!

	update: (dt) =>
		@noteField\update dt, @music\tell!, @music\isPlaying!

	draw: =>
		@noteField\draw!
