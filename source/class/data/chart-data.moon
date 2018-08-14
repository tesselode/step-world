NoteData = require 'class.data.note-data'

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
			time = @readMeasure * 4 + (lineNum - 1) * 4 / #@readLines
			for column = 1, #line
				noteType = line\sub column, column
				if noteType == '3'
					@heldNotes[column]\setEndTime time
					@heldNotes[column] = nil
				elseif noteType ~= '0'
					note = NoteData column, time, noteType
					table.insert @notes, note
					if noteType == '2' or noteType == '4'
						@heldNotes[column] = note
		@readLines = {}
		@readMeasure += 1

	new: =>
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
