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
		-- the first bpm change is at beat 0. from there, we can calculate the rest
		@timingEvents.bpmChanges[1].time = 0
		for i = 2, #@timingEvents.bpmChanges
			c = @timingEvents.bpmChanges[i]
			p = @timingEvents.bpmChanges[i - 1]
			c.time = p.time + (c.position - p.position) / (p.bpm / 60)
		-- stops are simple, they just delay all the future bpm changes by their length
		for stop in *@timingEvents.stops
			for bpmChange in *@timingEvents.bpmChanges
				if bpmChange.position > stop.position
					bpmChange.time += stop.length

	processTimingEvents: =>
		-- first parse the position (in beats) of each bpm change and stop,
		-- then figure out the time in seconds that they occur.
		@parseBpmChanges!
		@parseStops!
		@getBpmChangeTimes!

	-- loads an .sm file
	load: (filename) =>
		-- tags are always at the top of the .sm file, so we're loading those first
		section = 'tags'
		local chart
		for line in love.filesystem.lines filename
			-- start of a new stepchart
			if line == '#NOTES:'
				-- if we were just parsing tags, we're done now, so let's process the bpm changes and stops
				@processTimingEvents! if section == 'tags'
				section = 'notes'
				-- create a new chart
				chart = ChartData @timingEvents
			-- parse tags
			elseif section == 'tags'
				if line\sub(1, 1) == '#'
					tag, value = line\match '#(.*):(.*);'
					@tags[tag] = value
			-- parse chart info and notes
			elseif section == 'notes'
				-- chart info ends with a ":"
				if line\sub(-1) == ':'
					chart\addInfo line\match '%s*(.*):'
				---- reading notes ----
				-- for each measure (4 beats) of a song, .sm files hold a varying number of lines of notes.
				-- this tells us the timing of each note. since we don't know how many lines are in a measure
				-- until we reach the end of a measure, we send each line to the chart data instance, and when we
				-- reach the end of the measure, we tell the chart data instance to go back and figure out the timing
				-- of each note.
				elseif line == ','
					-- end of a measure, process the notes we've read in that measure
					chart\endMeasure!
				elseif line == ';'
					-- end of the chart. process the notes of that measure, process the chart data,
					-- and add the chart data to the song data
					with chart
						\endMeasure!
						\finishLoading!
						chartType, difficulty = .info.chartType, .info.difficulty
						@charts[chartType] = @charts[chartType] or {}
						@charts[chartType][difficulty] = chart
						section = 'none'
				else
					-- add a note line, which we'll parse later when we reach the end of a measure
					chart\addLine line

	new: (filename) =>
		@tags = {}
		@timingEvents =
			bpmChanges: {}
			stops: {}
		@charts = {}
		@load filename
