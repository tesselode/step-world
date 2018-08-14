ChartData = require 'class.data.chart-data'

class SongData
	parseBpmChanges: =>
		for bpmChange in @tags['BPMS']\gmatch '[^,;]+'
			position, bpm = bpmChange\match '(.-)=([^,;]+)'
			position, bpm = tonumber(position), tonumber(bpm)
			table.insert @timingEvents.bpmChanges, {:position, :bpm}

	parseStops: =>
		for stop in @tags['STOPS']\gmatch '[^,;]+'
			position, length = stop\match '(.-)=([^,;]+)'
			position, length = tonumber(position), tonumber(length)
			table.insert @timingEvents.stops, {:position, :length}

	getBpmChangeTimes: =>
		@timingEvents.bpmChanges[1].time = 0
		for i = 2, #@timingEvents.bpmChanges
			c = @timingEvents.bpmChanges[i]
			p = @timingEvents.bpmChanges[i - 1]
			c.time = p.time + (c.position - p.position) / (p.bpm / 60)
		for stop in *@timingEvents.stops
			for bpmChange in *@timingEvents.bpmChanges
				if bpmChange.position > stop.position
					bpmChange.time += stop.length

	processTimingEvents: =>
		@parseBpmChanges!
		@parseStops!
		@getBpmChangeTimes!

	load: (filename) =>
		section = 'tags'
		local chart
		for line in love.filesystem.lines filename
			if line == '#NOTES:'
				@processTimingEvents! if section == 'tags'
				section = 'notes'
				chart = ChartData @timingEvents
			elseif section == 'tags'
				if line\sub(1, 1) == '#'
					tag, value = line\match '#(.*):(.*);'
					@tags[tag] = value
			elseif section == 'notes'
				if line\sub(-1) == ':'
					chart\addInfo line\match '%s*(.*):'
				elseif line == ','
					chart\endMeasure!
				elseif line == ';'
					with chart
						\endMeasure!
						\finishLoading!
						chartType, difficulty = .info.chartType, .info.difficulty
						@charts[chartType] = @charts[chartType] or {}
						@charts[chartType][difficulty] = chart
						section = 'none'
				else
					chart\addLine line

	new: (filename) =>
		@tags = {}
		@timingEvents =
			bpmChanges: {}
			stops: {}
		@charts = {}
		@load filename
