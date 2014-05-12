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

class PTB.Filter extends PTB.TemplateElement
	constructor: (@e)->
		super
		@filterValueName = @e.attributes.filter.nodeValue
		@bind()

	bind: ->


class PTB.NumberFilter extends PTB.Filter
	name: 'number-filter'

	constructor: (@e)->
		@attributes = 
			reverse: @e.attributes['number-filter-reverse']?
			isDate: @e.attributes['number-filter-date']?
		super @e
		@readConditions()

	bind: ->
		@ePre = @e.$$('.number-filter-pre')
		@eValue = @e.$$('.number-filter-value')

		@ePre.addEventListener 'change', => @onChange()
		@eValue.addEventListener 'change', => @onChange()

	onChange: ->
		@readConditions()
		@fire('change')

	readConditions: ->
		@pre = parseInt @ePre.value
		@value = parseFloat @eValue.value
		if isNaN(@value)
			@value = null

	filter: (input, rejected)->
		# We need 2 arrays so we can show/hide the appropiate games without having
		# hide/show all first, or iterate through all the games to check which are rejected
		# removing the accepted. It's around 8 times faster, I tested. ~5ms vs ~40ms, it's a lot!
		accepted = []
		for game in input
			if @value == null
				accepted.push game
			else if @attributes.isDate
				accepted.push game
			else
				if @pre < 0
					if game.attributes[@filterValueName] < @value
						accepted.push game
					else
						rejected.push game
				else if @pre > 0
					if game.attributes[@filterValueName] > @value
						accepted.push game
					else
						rejected.push game
				else
					if game.attributes[@filterValueName] == @value
						accepted.push game
					else
						rejected.push game
		accepted

	
PTB.FiltersContainer.filters.push PTB.NumberFilter