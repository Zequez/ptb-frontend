class PTB.Router extends PTB.Eventable
  ignoreNextEvent: false

  parametersAlias: {
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
  }

  constructor: ->
    @bind()

  bind: ->
    window.addEventListener 'hashchange', =>
      @readHash() unless @ignoreNextEvent
      @ignoreNextEvent = false

  initializeState: ->
    @readHash()

  setState: (states)->
    @setHash(states)

  setHash: (parameters)->
    parameters = @parametersToAlias(parameters)
    arrayStringParameters = for parameter in parameters
      encodedValue = encodeURIComponent(parameter.value).replace(/%20/g, "+")
      stringParameter = parameter.name + (if parameter.value then "=#{encodedValue}" else '')
    
    @ignoreNextEvent = true
    window.location.hash = arrayStringParameters.join('&')

  readHash: (stringParameters = window.location.hash)->
    stringParameters = stringParameters[1..] if stringParameters[0] == '#'
    arrayStringParameters = stringParameters.split('&')

    parameters = for stringParameter in arrayStringParameters
      nameValue = stringParameter.split(/\=/)
      name: nameValue[0]
      value: if nameValue[1] then decodeURIComponent(nameValue[1]) else null

    @parametersFromAlias(parameters)

    @fire('change', parameters)

  parametersToAlias: (parameters)->
    for parameter in parameters
      if @parametersAlias[parameter.name]
        parameter.name = @parametersAlias[parameter.name]
    parameters

  parametersFromAlias: (parameters)->
    for parameter in parameters
      for name, alias of @parametersAlias
        if parameter.name == alias
          parameter.name = name
    parameters