class ChartData
	addInfo: (info) => with @info
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
		for note in *@notes
			local currentBpmChange
			for i = #@timingEvents.bpmChanges, 1, -1
				bpmChange = @timingEvents.bpmChanges[i]
				if bpmChange.position <= note.position
					currentBpmChange = bpmChange
					break
			with currentBpmChange
				note.time = .time + (note.position - .position) / (.bpm / 60)
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
