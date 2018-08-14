class SongData
	parseBpmChanges: =>
		for bpmChange in @tags['BPMS']\gmatch '[^,;]+'
			position, bpm = bpmChange\match '(.-)=([^,;]+)'
			position, bpm = tonumber(position), tonumber(bpm)
			table.insert @bpmChanges, {:position, :bpm}

	parseStops: =>
		for stop in @tags['STOPS']\gmatch '[^,;]+'
			position, length = stop\match '(.-)=([^,;]+)'
			position, length = tonumber(position), tonumber(length)
			table.insert @stops, {:position, :length}

	getBpmChangeTimes: =>
		@bpmChanges[1].time = 0
		for i = 2, #@bpmChanges
			c = @bpmChanges[i]
			p = @bpmChanges[i - 1]
			c.time = p.time + (c.position - p.position) / (p.bpm / 60)
		for stop in *@stops
			for bpmChange in *@bpmChanges
				if bpmChange.position > stop.position
					bpmChange.time += stop.length
		for bpmChange in *@bpmChanges
			with bpmChange
				print .position, .time, .bpm

	processTimingEvents: =>
		@parseBpmChanges!
		@parseStops!
		@getBpmChangeTimes!

	load: (filename) =>
		section = 'tags'
		local chart
		for line in love.filesystem.lines filename
			if section == 'tags'
				if line == '#NOTES:'
					section = 'notes'
					@processTimingEvents!
					chart = {}
				elseif line\sub(1, 1) == '#'
					tag, value = line\match '#(.*):(.*);'
					@tags[tag] = value

	new: (filename) =>
		@tags = {}
		@bpmChanges = {}
		@stops = {}
		@charts = {}
		@load filename
