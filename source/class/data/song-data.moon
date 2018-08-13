ChartData = require 'class.data.chart-data'

class SongData
	new: =>
		@tags = {}
		@bpmChanges = {}
		@charts = {}

	loadBpmChanges: =>
		for bpmChange in @tags['BPMS']\gmatch '.-=.-,'
			position, bpm = bpmChange\match '(.-)=(.-),'
			table.insert @bpmChanges, {:position, :bpm}

	load: (filename) =>
		readingNotes = false
		local chart
		for line in love.filesystem.lines filename
			if line == '#NOTES:'
				readingNotes = true
				chart = ChartData!
			elseif readingNotes
				if line\sub(-1) == ':'
					chart\addInfo line\match '%s*(.*):'
				elseif line == ','
					chart\endMeasure!
				elseif line == ';'
					chart\endMeasure!
					readingNotes = false
					chartType, difficulty = chart.info.chartType, chart.info.difficulty
					@charts[chartType] = @charts[chartType] or {}
					@charts[chartType][difficulty] = chart
				else
					chart\addLine line
			else
				if line\sub(1, 1) == '#'
					tag, value = line\match '#(.*):(.*);'
					@tags[tag] = value
		@loadBpmChanges!
