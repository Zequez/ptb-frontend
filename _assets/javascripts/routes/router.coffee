class PTB.Routes.Router extends PTB.Eventable
  ignoreNextEvent: false

  parametersAlias:
    'categories': 'tags'
    'lowerName': 'name'
    'sortLowerName': 'sortName'
    'sortTagsRating': 'sortTags'
    'launchDateSince': 'launchDate'
    'sortLaunchDateSince': 'sortLaunchDate'
    'sortFinalPrice': 'sortPrice'
    'finalPrice': 'price'
    'sortAverage_time': 'sortPlaytime'
    'average_time': 'playtime'
    'sortAverageTimeOverPrice': 'sortPlaytimeOverBuck'
    'averageTimeOverPrice': 'playtimeOverBuck'
    'sortTotalReviews': 'sortReviews'
    'totalReviews': 'reviews'
    'sortMeta_score': 'sortMetascore'
    'meta_score': 'metascore'
    'sortPositiveReviewsPercentage': 'sortReviewsDistribution'
    'positiveReviewsPercentage': 'reviewsDistribution'
    'sortPlaytimeDeviationPercentage': 'sortPlaytimeDisparity'
    'playtimeDeviationPercentage': 'playtimeDisparity'

  routesMappingsData: PTB.Routes.mappingData

  constructor: ->
    @routesMappings = new PTB.Routes.Mapper @routesMappingsData
    @bind()

  bind: ->
    window.addEventListener 'hashchange', =>
      @readHash() unless @ignoreNextEvent
      @ignoreNextEvent = false

  initializeState: ->
    @readHash()

  setState: (states)-> @setHash(states)
  setHash: (params)->
    params = @parametersToAlias(params)
    route = @routesMappings.routeFromParams(params)
    
    @ignoreNextEvent = true
    window.history.replaceState {}, route.title, route.trailingSlashPath()
    window.location.hash = route.hash()
    route

  readHash: ->
    route = @routesMappings.routeFromUrl()
    params = @parametersFromAlias(route.params)

    @fire('change', params, route.title)

  parametersToAlias: (parameters)->
    for parameterName, parameterValue of parameters
      if @parametersAlias[parameterName]
        parameters[@parametersAlias[parameterName]] = parameterValue
        delete parameters[parameterName]
    parameters

  parametersFromAlias: (parameters)->
    for parameterName, parameterValue of parameters
      for name, alias of @parametersAlias
        if alias == parameterName
          parameters[name] = parameterValue
          delete parameters[alias]
    parameters

  parametersFromHardAlias: (hardAlias)->
    if @hardAlias[hardAlias]?
      [@hardAlias[hardAlias].params, @hardAlias[hardAlias].title] 
    else
      [{}, @hardAlias['/'].title]