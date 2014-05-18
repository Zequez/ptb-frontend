class PTB.FiltersContainer extends PTB.DOMElement
	name: 'filters-container'

	@filters: []
	filters: []

	constructor: ->
		# We search filters in the DOM by the name of the filter
		for filter in FiltersContainer.filters
			filtersElements = $('[' + filter::name + ']')
			for filterElement in filtersElements
				@filters.push new filter(filterElement)

		@bind()
		super

	bind: (callback)->
		for filter in @filters
			filter.on 'change', =>
				@fire 'change'

	filter: (games, rejected)->
		accepted = games
		for filter in @filters
			accepted = filter.filter(accepted, rejected)
		accepted

	calculateConditions: (games)->
		filter.calculateConditions(games) for filter in @filters

class PTB.Filter extends PTB.TemplateElement
	constructor: (@e)->
		super
		@filterValueName = @e.attributes.filter.nodeValue
		@bind()

	bind: ->


class PTB.NumberFilter extends PTB.Filter
	name: 'number-filter'
	options: [['', '']]

	constructor: (@e)->
		@attributes = 
			reverse: @e.attributes['number-filter-reverse']?
			isDate: @e.attributes['number-filter-date']?
		super @e
		@readConditions()

	bind: ->
		# @ePre = @e.$$('.number-filter-pre')
		# @eValue = @e.$$('.number-filter-value')
		@eValueStart = @e.$$('.number-filter-value-start')
		@eValueEnd = @e.$$('.number-filter-value-end')

		# @ePre.addEventListener 'change', => @onChange()
		# @eValue.addEventListener 'change', => @onChange()
		@eValueStart.addEventListener 'change', => @onChange()
		@eValueEnd.addEventListener 'change', => @onChange()

	onChange: ->
		@readConditions()
		@fire('change')

	readConditions: ->
		# @pre = parseInt @ePre.value
		# @value = parseFloat @eValue.value
		@valueStart = parseFloat @eValueStart.value
		@valueEnd = parseFloat @eValueEnd.value
		@inclusiveStart = true
		if isNaN(@valueStart)
			@valueStart = null
		if isNaN(@valueEnd)
			@valueEnd = null

		selectedOption = @options[@eValueStart.selectedIndex]
		if selectedOption
			@inclusiveStart = not /\>/.test selectedOption[1]


	calculateConditions: (games)->
		@setOptions()
		return
		# centiles = 10
		# conditions = []
		# conditionsText = []
		# values = for game in games
		# 	game.attributes[@filterValueName]
		# values.sort((a,b)-> a-b)
		# for i in [0...centiles]
		# 	centilePosition = parseInt( (values.length/centiles) * i)
		# 	console.log centilePosition
		# 	conditions[i] = values[centilePosition]

		# # We add the last value
		# conditions.push values[values.length-1]

		# # We remove repeated and null elements
		# newConditions = []
		# for condition, i in conditions
		# 	if conditions.indexOf(condition, i+1) == -1 and condition != null
		# 		newConditions.push condition
		# conditions = newConditions

		# # If we have a condition 0, we add 0 non inclusive
		# if conditions[0] == 0
		# 	conditions.unshift(null)

	setOptions: ->
		@readOptions()
		for option in @options
			eOption = document.createElement('option')
			eOption.value = option[0]
			eOption.innerText = option[1]
			@eValueStart.appendChild eOption
			if not /\>/.test option[1]
				@eValueEnd.appendChild eOption.cloneNode(true)

	readOptions: ->
		@options = [@options[0]] # We create a new array
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
				if not isRejected and @valueStart? and not @inclusiveStart
					isRejected = attrVal == @valueStart
				isRejected = attrVal > @valueEnd if not isRejected and @valueEnd?
				
				if isRejected
					rejected.push game
				else
					accepted.push game
		accepted

	
PTB.FiltersContainer.filters.push PTB.NumberFilter