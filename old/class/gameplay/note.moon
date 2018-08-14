class Note
	new: (@noteData) =>

	draw: (spacing) => with love.graphics
		.circle 'fill', @noteData.column, @noteData.time * spacing, 1/4, 64
