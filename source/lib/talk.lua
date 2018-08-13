local talk = {}

local Conversation = {}
Conversation.__index = Conversation

function Conversation:listen(message, f)
	local listener = {message = message, f = f}
	self._listeners[listener] = true
	return listener
end

function Conversation:say(message, ...)
	for listener, _ in pairs(self._listeners) do
		if listener.message == message then
			listener.f(...)
		end
	end
end

function Conversation:deafen(listener)
	self._listeners[listener] = nil
end

function talk.new()
	return setmetatable({
		_listeners = {},
	}, Conversation)
end

return talk
