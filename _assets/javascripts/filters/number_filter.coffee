class PTB.Filters.NumberFilter extends PTB.Filter
	name: 'number-filter'
	options: []

	constructor: (@e)->
		@attributes = 
			reverse: @e.attributes['number-filter-reverse']?
			isDate: @e.attributes['number-filter-date']?
		super @e
		@bind()
		@readConditions()

	bind: ->
		@eValueStart = @e.$$('.number-filter-value-start')
		@eValueEnd = @e.$$('.number-filter-value-end')

		@eValueStart.addEventListener 'change', => @onChange()
		@eValueEnd.addEventListener 'change', => @onChange()

	onChange: ->
		@readConditions()
		@fire('change')

	readConditions: ->
		@valueStart = parseFloat @eValueStart.value
		@valueEnd = parseFloat @eValueEnd.value
		@filterOutFirstNumber = false
		if isNaN(@valueStart)
			@valueStart = null
		if isNaN(@valueEnd)
			@valueEnd = null

		selectedOption = @options[@eValueStart.selectedIndex]
		if selectedOption
			@filterOutFirstNumber = /\>/.test selectedOption[1]

	createOptions: ->
		@parseOptions()
		@insertOptions()

	insertOptions: ->
		for option in @options
			eOption = document.createElement('option')
			eOption.value = option[0]
			eOption.innerText = option[1]
			@eValueStart.appendChild eOption
			if not /\>/.test option[1]
				@eValueEnd.appendChild eOption.cloneNode(true)

	parseOptions: ->
		@options = [] # We create a new array
		@rawOptions = @e.attributes['filter-options']
		if @rawOptions
			@rawOptions = @rawOptions.nodeValue
			@rawOptions = @rawOptions.split(',')
			for rawOption in @rawOptions
				valueText = rawOption.split(' ')
				if valueText.length == 1
					valueText.push(valueText[0])
				valueText[0] = parseFloat valueText[0]
				@options.push valueText


	filter: (games, rejected)->
		# We need 2 arrays so we can show/hide the appropiate games without having
		# hide/show all first, or iterate through all the games to check which are rejected
		# removing the accepted. It's around 8 times faster, I tested. ~5ms vs ~40ms, it's a lot!
		accepted = []
		for game in games
			attrVal = game.attributes[@filterValueName]
			if not @valueStart? and not @valueEnd?
				accepted.push game
			else if @attributes.isDate
				accepted.push game
			else
				attrVal = 0 if not attrVal?
				isRejected = false
				isRejected = attrVal < @valueStart if @valueStart?
				if not isRejected and @valueStart? and @filterOutFirstNumber
					console.log 'Filtr first!'
					isRejected = attrVal == @valueStart
				isRejected = attrVal > @valueEnd if not isRejected and @valueEnd?
				
				if isRejected
					rejected.push game
				else
					accepted.push game
		accepted