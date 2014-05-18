class PTB.Filters.NumberFilter extends PTB.Filter
	name: 'number-filter'
	options: []

	constructor: ->
		super
		@bind()
		@readValues()
		@findPlaceholder()

	bind: ->
		@eValueStart = @e.$$('.number-filter-value-start')
		@eValueEnd = @e.$$('.number-filter-value-end')

		@eValueStart.addEventListener 'change', => @onChange()
		@eValueEnd.addEventListener 'change', => @onChange()

	onChange: ->
		@applyPlaceholder()
		@readValues()
		@fire('change')

	readValues: ->
		@valueStart = @parseValue @eValueStart.value
		@valueEnd = @parseValue @eValueEnd.value
		@filterOutFirstNumber = false

	parseValue: (value)->
		parsedValue = {
			number: parseFloat(value.replace('>', '')),
			open: />/.test(value)
		}
		parsedValue.value = null if isNaN(parsedValue.value)
		parsedValue

	createOptions: ->
		@parseOptions()
		@insertOptions()

	insertOptions: ->
		for option in @options
			eOption = document.createElement('option')
			eOption.value = option[0]
			eOption.innerText = option[1]
			@eValueStart.appendChild eOption
			if not /\>/.test option[0]
				@eValueEnd.appendChild eOption.cloneNode(true)

	parseOptions: ->
		@options = [] # We create a new array
		@rawOptions = @e.attributes['filter-options']
		if @rawOptions
			@rawOptions = @rawOptions.nodeValue
			@rawOptions = @rawOptions.split(',')
			for rawOption in @rawOptions
				valueAndText = rawOption.replace(' ', '///').split('///') # This is just lazy to allow spaces after the first space
				if valueAndText.length == 1
					valueAndText.push(valueAndText[0])
				valueAndText[0] = @parseOptionsValue(valueAndText[0], valueAndText[1])
				valueAndText[1] = @parseOptionsText(valueAndText[1], valueAndText[0])
				@options.push valueAndText

	parseOptionsValue: (value)-> value
	parseOptionsText: (text)-> text


	filter: (games, rejected)->
		# We need 2 arrays so we can show/hide the appropiate games without having
		# hide/show all first, or iterate through all the games to check which are rejected
		# removing the accepted. It's around 8 times faster, I tested. ~5ms vs ~40ms, it's a lot!
		accepted = []
		for game in games
			attrVal = game.attributes[@filterValueName]
			if not @valueStart.number? and not @valueEnd.number?
				accepted.push game
			else
				attrVal = 0 if not attrVal?
				isRejected = false
				isRejected = attrVal < @valueStart.number if @valueStart.number?
				if not isRejected and @valueStart.number? and @valueStart.open
					isRejected = attrVal == @valueStart.number
				isRejected = attrVal > @valueEnd.number if not isRejected and @valueEnd.number?
				
				if isRejected
					rejected.push game
				else
					accepted.push game
		accepted

	findPlaceholder: ->
		@eStartPlaceholder = @eValueStart.children[@eValueStart.selectedIndex]
		@eEndPlaceholder = @eValueEnd.children[@eValueEnd.selectedIndex]

	applyPlaceholder: ->
		if @eValueStart.value == ''
			@eStartPlaceholder.selected = true
		@eValueStart.classList.toggle('placeholdered', @eValueStart.value == '')

		if @eValueEnd.value == ''
			@eEndPlaceholder.selected = true
		@eValueEnd.classList.toggle('placeholdered', @eValueEnd.value == '')