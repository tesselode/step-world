class Note
	new: (@noteData) =>
		@wasHit = false

	hit: => @wasHit = true

	draw: (spacing) => with love.graphics
		if not @wasHit
			.circle 'fill', @noteData.column, @noteData.position * spacing, 1/4, 64
