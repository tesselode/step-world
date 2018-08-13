Note = require 'class.gameplay.note'

class NoteField
	scale: 32
	baseSpacing: 2

	initNotes: =>
		@notes = {}
		for noteData in *@chartData.notes
			table.insert @notes, Note noteData

	new: (@songData, @chartData) =>
		@initNotes!
		@previousPosition = 0
		@position = 0
		@receptorAlpha = .5

	setPosition: (position) =>
		@previousPosition = @position
		@position = position
		if @previousPosition % 1 > @position % 1
			@receptorAlpha = 1

	update: (dt) =>
		@receptorAlpha += (.5 - @receptorAlpha) * 10 * dt

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
		.translate 0, -@position * @baseSpacing
		note\draw @baseSpacing for note in *@notes
		.pop!
