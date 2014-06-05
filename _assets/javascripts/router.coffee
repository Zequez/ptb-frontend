class PTB.Router extends PTB.Eventable
  ignoreNextEvent: false

  constructor: ->
    @bind()

  bind: ->
    window.addEventListener 'hashchange', =>
      @readHash() unless @ignoreNextEvent
      @ignoreNextEvent = false

  initializeState: ->
    @readHash()

  setState: (sortState, filtersState)->
    hashState = filtersState || []
    sortHashState = @generateSortParameter(sortState)
    hashState.push sortHashState
    @setHash(hashState)

  generateSortParameter: (sortState)->
    name: 'sort' + @capitalize(sortState.name)
    value: if sortState.value then null else 'descending'

  separateParameters: (parameters)->
    sortParameter = {}

    for parameter, i in parameters
      if parameter.name[0..3] == 'sort'
        sortParameter.name = @uncapitalize(parameter.name[4..])
        sortParameter.value = (parameter.value != 'descending')
        parameters.splice(i, 1)
        return [sortParameter, parameters]

    [sortParameter, parameters]

  setHash: (parameters)->
    console.log parameters
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

    [sortParameter, filterParameter] = @separateParameters(parameters)

    @fire('change', sortParameter, filterParameter)

  capitalize: (string)->
    string.charAt(0).toUpperCase() + string[1..]

  uncapitalize: (string)->
    string.charAt(0).toLowerCase() + string[1..]