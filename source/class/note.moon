class
	setEndTime: (@endTime) =>

	new: (@column, @time, @noteType) =>

	drawDebug: => with love.graphics
		.circle 'fill', @column * 4, @time * 8, 2, 64
