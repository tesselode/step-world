ChartData = require 'class.data.chart-data'

class SongData
	new: =>
		@tags = {}
		@bpmChanges = {}
		@charts = {}

	loadBpmChanges: =>
		for bpmChange in @tags['BPMS']\gmatch '.-=.-,'
			position, bpm = bpmChange\match '(.-)=(.-),'
			position = tonumber position
			bpm = tonumber bpm
			table.insert @bpmChanges, {:position, :bpm}
		for i, bpmChange in ipairs @bpmChanges
			if i == 1
				assert bpmChange.position == 0
				bpmChange.time = 0
			else
				positionDifference = bpmChange.position - @bpmChanges[i - 1].position
				timeDifference = positionDifference / (@bpmChanges[i - 1].bpm / 60)
				bpmChange.time = @bpmChanges[i - 1].time + timeDifference

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
