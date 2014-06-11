class PTB.FiltersContainer extends PTB.DOMElement
  name: 'filters-container'

  @filters: []
  filters: []

  constructor: ->
    # We search filters in the DOM by the name of the filter
    for i, filter of PTB.Filters
      if filter::name
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
    states = {}
    for filter in @filters
      if filter.active
        states[filter.filterValueName] = filter.getUrlValue()
    states

  setFiltersState: (states)->
    for stateName, stateValue of states
      for filter in @filters
        if filter.filterValueName is stateName
          filter.setUrlValue stateValue