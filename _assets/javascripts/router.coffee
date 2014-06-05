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

  hardAlias: {
    '/recently-launched': {launchDate: '+0d~', sortLaunchDate: null}
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
    console.log states
    @setHash(states)

  setHash: (parameters)->
    parameters = @parametersToAlias(parameters)
    arrayStringParameters = for parameterName, parameterValue of parameters
      encodedValue = encodeURIComponent(parameterValue).replace(/%20/g, "+")
      stringParameter = parameterName + (if parameterValue then "=#{encodedValue}" else '')
    
    @ignoreNextEvent = true
    window.location.hash = arrayStringParameters.join('&')

  readHash: (stringParameters = window.location.hash)->
    stringParameters = stringParameters[1..] if stringParameters[0] == '#'
    arrayStringParameters = stringParameters.split('&')

    parameters = {}
    for stringParameter in arrayStringParameters
      nameValue = stringParameter.split(/\=/)
      parameters[nameValue[0]] = (if nameValue[1] then decodeURIComponent(nameValue[1]) else null)

    @parametersFromAlias(parameters)

    @fire('change', parameters)

  parametersToAlias: (parameters)->
    for parameterName, parameterValue of parameters
      if @parametersAlias[parameterName]
        parameters[@parametersAlias[parameterName]] = parameterValue
    parameters

  parametersToHardAlias: (parameters)->
    '/'

  parametersFromAlias: (parameters)->
    for parameterName, parameterValue of parameters
      for name, alias of @parametersAlias
        if name == parameterName
          parameters[alias] = parameterValue
    parameters

  parametersFromHardAlias: (hardAlias)->
    {}