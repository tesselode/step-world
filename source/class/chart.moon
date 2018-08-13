Note = require 'class.note'

class
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
		heldNotes = {}
		for lineNum, line in ipairs @readLines
			time = @readMeasure * 4 + (lineNum - 1) * 4 / #@readLines
			for column = 1, #line
				noteType = line\sub column, column
				if noteType == '3'
					assert heldNotes[column]
					heldNotes[column]\setEndTime time
					heldNotes[column] = nil
				elseif noteType ~= '0'
					note = Note column, time, noteType
					table.insert @notes, note
					if noteType == '2' or noteType == '4'
						heldNotes[column] = note
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

	drawDebug: =>
		for note in *@notes
			note\drawDebug!
		for measureNum = 1, @readMeasure
			love.graphics.line 0, measureNum * 32, 100, measureNum * 32 
