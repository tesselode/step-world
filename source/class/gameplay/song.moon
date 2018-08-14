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

	keypressed: (key) =>
		keyColumn = key == 'left' and 1 or key == 'down' and 2 or key == 'up' and 3 or key == 'right' and 4
		for note in *@noteField.notes
			with note
				if not .wasHit and keyColumn == .noteData.column and math.abs(@musicTime - .noteData.time) < 1/6
					\hit!
					break

	draw: =>
		@noteField\draw @position
		love.graphics.print @musicTime
