class FiltersContainer extends DOMElement
	@filters: []
	filters: []

	constructor: ->
		# We search filters in the DOM by the name of the filter
		for filter in FiltersContainer.filters
			filtersElements = $('[' + filter::name + ']')
			for filterElement in filtersElements
				@filters.push new filter(filterElement)

class Filter extends TemplateElement
	constructor: (@e)->
		super
		@filterValueName = @e.attributes.filter
		@bind()

	bind: ->

class NumberFilter extends Filter
	name: 'number-filter'

	constructor: (@e)->
		@attributes.reverse = @e.attributes['number-filter-reverse']?
		@attributes.isDate = @e.attributes['number-filter-date']?
		super @e

	bind: ->
		@ePre = @e.$$('.number-filter-pre')
		@eValue = @e.$$('.number-filter-value')

		@ePre.addEventListener 'change', ->
			console.log this.value

		@eValue.addEventListener 'change', ->
			console.log this.value

	
FiltersContainer.filters.push NumberFilter

new FiltersContainer