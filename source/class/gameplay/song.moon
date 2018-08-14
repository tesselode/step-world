NoteField = require 'class.gameplay.visual.note-field'

class Song
	new: (@songData, chartType, difficulty) =>
		@noteField = NoteField @songData, @songData.charts[chartType][difficulty]
		@bpm = @songData.timingEvents.bpmChanges[1].bpm
		@previousMusicTime = 0
		@musicTime = 0
		@previousPosition = 0
		@position = 0
		@stopTimer = 0
		with @music = love.audio.newSource @songData.tags['MUSIC'], 'stream'
			\play!

	updateScrolling: (musicDt) =>
		@previousPosition = @position
		if @stopTimer > 0
			@stopTimer -= musicDt
		if @stopTimer <= 0
			@position -= @stopTimer
			@stopTimer = 0
			@position += @bpm / 60 * musicDt
		for bpmChange in *@songData.timingEvents.bpmChanges
			with bpmChange
				if @previousPosition < .position and @position >= .position
					@bpm = .bpm
		for stop in *@songData.timingEvents.stops
			with stop
				if @previousPosition < .position and @position >= .position
					@stopTimer = .length

	musicTick: =>
		@previousMusicTime = @musicTime
		@musicTime = @music\tell!
		@musicTime - @previousMusicTime

	update: (dt) =>		
		musicDt = @musicTick!
		@updateScrolling musicDt
		conversation\say 'on beat' if @previousPosition % 1 > @position % 1
		@noteField\update dt

	draw: =>
		@noteField\draw @position
