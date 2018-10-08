class ChartData
	addInfo: (info) => with @info
		-- this info is always listed in the same order in an .sm file,
		-- so we can read in the info one by one
		if not .chartType
			.chartType = info
		elseif not .author
			.author = info
		elseif not .difficulty
			.difficulty = info
		elseif not .meter
			.meter = info

	addLine: (line) =>
		table.insert @readLines, line

	endMeasure: =>
		-- figure out the position (in beats) of each note based on the current
		-- measure number and the number of lines in the current measure.
		-- we also remember hold notes and mark their end position when we read that data.
		for lineNum, line in ipairs @readLines
			position = @readMeasure * 4 + (lineNum - 1) * 4 / #@readLines
			for column = 1, #line
				noteType = line\sub column, column
				if noteType == '3'
					@heldNotes[column].endPosition = position
					@heldNotes[column] = nil
				elseif noteType ~= '0'
					note = {:column, :position, :noteType}
					table.insert @notes, note
					if noteType == '2' or noteType == '4'
						@heldNotes[column] = note
		@readLines = {}
		@readMeasure += 1

	getNoteTimes: =>
		-- gets the time that each note occurs in seconds.
		-- this is how we know if the player hit a note at the correct time
		-- during gameplay without having to do bpm/stop calculations later.
		for note in *@notes
			-- get the current bpm at the note's position
			local currentBpmChange
			for i = #@timingEvents.bpmChanges, 1, -1
				bpmChange = @timingEvents.bpmChanges[i]
				if bpmChange.position <= note.position
					currentBpmChange = bpmChange
					break
			-- get the note's time as a function of the current bpm,
			-- the note's position relative to the start of the current bpm change,
			-- and the starting time of the bpm change.
			with currentBpmChange
				note.time = .time + (note.position - .position) / (.bpm / 60)
		-- stops are simple, they just add a fixed delay to every future note
		for stop in *@timingEvents.stops
			for note in *@notes
				if note.position > stop.position
					note.time += stop.length
	
	cleanup: =>
		@readMeasure = nil
		@readLines = nil
		@heldNotes = nil

	finishLoading: =>
		@getNoteTimes!
		@cleanup!

	new: (@timingEvents) =>
		@info =
			chartType: nil
			author: nil
			difficulty: nil
			meter: nil
			groove: nil
		@notes = {}
		@readMeasure = 0
		@readLines = {}
		@heldNotes = {}
