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

  hardAlias: PTB.hardAlias

  constructor: ->
    @findElements()
    @bind()

  findElements: ->
    @eTitle = document.getElementsByTagName('title')[0]
    @eSubtitle = document.getElementsByClassName('subtitle')[0]

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
    [hardAlias, pageTitle] = @parametersToHardAlias(parameters)

    arrayStringParameters = for parameterName, parameterValue of parameters
      encodedValue = encodeURIComponent(parameterValue).replace(/%2B/g, "+")
      stringParameter = parameterName + (if parameterValue then "=#{encodedValue}" else '')
    
    @ignoreNextEvent = true
    window.history.replaceState {}, pageTitle, hardAlias
    window.location.hash = arrayStringParameters.join('&')
    @setPageTitle(pageTitle)

  setPageTitle: (title)->
    previousTitle = @eTitle.innerHTML
    previousTitle = previousTitle.split(/\s+\-\s+/)[0]
    @eTitle.innerHTML = "#{previousTitle} - #{title}"
    @eSubtitle.innerHTML = title

  readHash: (stringParameters = window.location.hash)->
    stringParameters = stringParameters[1..] if stringParameters[0] == '#'
    arrayStringParameters = stringParameters.split('&')

    parameters = {}
    for stringParameter in arrayStringParameters
      nameValue = stringParameter.split(/\=/)
      parameters[nameValue[0]] = (if nameValue[1] then decodeURIComponent(nameValue[1]) else null)

    [hardAliasParameters, pageTitle] = @parametersFromHardAlias(window.location.pathname)
    for hardAliasParameterName, hardAliasParameterValue of hardAliasParameters
      parameters[hardAliasParameterName] = hardAliasParameterValue
    @parametersFromAlias(parameters)
    @setPageTitle pageTitle

    @fire('change', parameters)

  parametersToAlias: (parameters)->
    for parameterName, parameterValue of parameters
      if @parametersAlias[parameterName]
        parameters[@parametersAlias[parameterName]] = parameterValue
        delete parameters[parameterName]
    parameters

  parametersToHardAlias: (parameters)->
    matchedHardAlias = {}

    for hardAliasRoute, hardAliasData of @hardAlias
      hardAliasParametersCount = 0
      for hardAliasParameterName, hardAliasParameterValue of hardAliasData.params
        hardAliasParametersCount++
        for parameterName, parameterValue of parameters
          if hardAliasParameterName == parameterName and hardAliasParameterValue == parameterValue
            hardAliasParametersCount--
      if hardAliasParametersCount == 0
        for hardAliasParameterName of hardAliasData.params
          delete parameters[hardAliasParameterName]
        return [hardAliasRoute, hardAliasData.title]

    ['/', @hardAlias['/'].title]

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