class Note
	new: (@noteData) =>

	draw: (spacing) => with love.graphics
		.circle 'fill', @noteData.column, @noteData.position * spacing, 1/4, 64
