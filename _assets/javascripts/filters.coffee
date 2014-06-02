PTB.Filters = {}

class PTB.Filter extends PTB.TemplateElement
  constructor: (@e)->
    # Sadly I had to recur to JS since I didn't find a way
    # for the select elements to aquire 50% width of the
    # table cell without setting the width of the table cell
    @e.style.width = @e.offsetWidth + 'px'
    super
    @filterValueName = @e.attributes.filter.value
    

  createOptions: ->

  broadcast: (name, value)->
    @fire name, value

class PTB.FiltersContainer extends PTB.DOMElement
  name: 'filters-container'

  @filters: []
  filters: []

  constructor: ->
    # We search filters in the DOM by the name of the filter
    for i, filter of PTB.Filters
      filtersElements = $('[' + filter::name + ']')
      for filterElement in filtersElements
        @filters.push new filter(filterElement)

    @bind()
    super

  bind: (callback)->
    for filter in @filters
      filter.on 'change', (shrinker = false)=>
        @fire 'change', shrinker

  filter: (games, rejected)->
    accepted = games
    for filter in @filters
      accepted = filter.filter(accepted, rejected)
    accepted

  createOptions: (games)->
    filter.createOptions(games) for filter in @filters

  broadcast: (name, value)->
    for filter in @filters
      filter.broadcast(name, value)

  getFiltersState: ->

  setFiltersState: ->