Note = require 'class.gameplay.note'

music = love.audio.newSource 'paranoia.ogg', 'stream'

class NoteField
	scale: 32
	baseSpacing: 2

	initNotes: =>
		@notes = {}
		for noteData in *@chartData.notes
			table.insert @notes, Note noteData

	new: (@chartData) =>
		@initNotes!
		@bpm = 180
		music\play!
		@previousTime = 0
		@previousScroll = 0
		@scroll = 0
		@receptorAlpha = .5

	update: (dt) =>
		@previousScroll = @scroll
		@scroll = music\tell! * @bpm / 60 if music\isPlaying!

		@receptorAlpha += (.5 - @receptorAlpha) * 10 * dt
		if @previousScroll % 1 > @scroll % 1
			@receptorAlpha = 1

	drawReceptors: => with love.graphics
		.push 'all'
		.setColor 1, 1, 1, @receptorAlpha
		for i = 1, 4 do
			.circle 'fill', i, 0, 1/4, 64
		.pop!

	draw: => with love.graphics
		.push 'all'
		.translate .getWidth! / 2, 64
		.scale @scale
		.translate -2.5, 0
		@drawReceptors!
		.translate 0, -@scroll * @baseSpacing
		note\draw @baseSpacing for note in *@notes
		.pop!
		.print @scroll
