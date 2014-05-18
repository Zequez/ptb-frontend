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
			selected: value != ''
		}
		parsedValue.number = null if isNaN(parsedValue.number)
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
		console.log @valueStart, @valueEnd
		for game in games
			attrVal = game.attributes[@filterValueName]
			# If the filter is deactivated
			if not @valueStart.selected and not @valueEnd.selected
				accepted.push game
			# If the value is null, we only accept it
			# if the start filter is deactivated
			# or if the start filter is null
			else if attrVal == null
				if not @valueStart.selected or @valueStart.number == null
					accepted.push game
				else 
					rejected.push game
			else
				numberStart = if (@valueStart.number == null) then 0 else @valueStart.number
				numberEnd = @valueEnd.number
				isRejected = false
				if @valueStart.selected
					isRejected = attrVal < numberStart
				if not isRejected and @valueStart.selected and @valueStart.open
					isRejected = attrVal == numberStart
				if not isRejected and @valueEnd.selected
					isRejected = attrVal > @valueEnd.number
				
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