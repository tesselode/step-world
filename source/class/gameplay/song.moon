NoteField = require 'class.gameplay.note-field'

class Song
	new: (@songData, chartType, difficulty) =>
		@noteField = NoteField @songData, @songData.charts[chartType][difficulty]
		@bpm = @songData.bpmChanges[1].bpm
		@previousTime = 0
		@time = 0
		@previousPosition = 0
		@position = 0
		@stopTimer = 0
		with @music = love.audio.newSource @songData.tags['MUSIC'], 'stream'
			\play!

	update: (dt) =>		
		@previousTime = @time
		@time = @music\tell!
		musicDt = @time - @previousTime
		@previousPosition = @position
		if @stopTimer > 0
			@stopTimer -= musicDt
		if @stopTimer <= 0
			@position -= @stopTimer
			@stopTimer = 0
			@position += @bpm / 60 * musicDt
		for bpmChange in *@songData.bpmChanges
			with bpmChange
				if @previousPosition < .position and @position >= .position
					@bpm = .bpm
		for stop in *@songData.stops
			with stop
				if @previousPosition < .position and @position >= .position
					@stopTimer = .length
		with @noteField
			\setPosition @position
			\update dt

	draw: =>
		@noteField\draw!
