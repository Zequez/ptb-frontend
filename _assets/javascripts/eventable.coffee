class PTB.Eventable
	callbacks: {}

	on: (eventName, callback)->
		@callbacks = {} if @callbacks == PTB.Eventable::callbacks
		@callbacks[eventName] ||= []
		@callbacks[eventName].push callback

	fire: (eventName, args...)->
		if @callbacks[eventName]
			for callback in @callbacks[eventName]
				callback(args...)