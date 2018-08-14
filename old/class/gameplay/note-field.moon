Note = require 'class.gameplay.note'

class NoteField
	scale: 32
	baseSpacing: 2

	initNotes: =>
		@notes = {}
		for noteData in *@chartData.notes
			table.insert @notes, Note noteData

	initListeners: =>
		@listeners = {
			conversation\listen 'on beat', ->
				@receptorAlpha = 1
		}

	new: (@songData, @chartData) =>
		@initNotes!
		@receptorAlpha = .5
		@initListeners!

	update: (dt) =>
		@receptorAlpha += (.5 - @receptorAlpha) * 10 * dt

	cleanup: =>
		conversation\deafen listener for listener in *@listeners

	drawReceptors: => with love.graphics
		.push 'all'
		.setColor 1, 1, 1, @receptorAlpha
		for i = 1, 4 do
			.circle 'fill', i, 0, 1/4, 64
		.pop!

	draw: (position) => with love.graphics
		.push 'all'
		.translate .getWidth! / 2, 64
		.scale @scale
		.translate -2.5, 0
		@drawReceptors!
		.translate 0, -position * @baseSpacing
		note\draw @baseSpacing for note in *@notes
		.pop!
