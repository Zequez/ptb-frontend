class PTB.Routes.Router extends PTB.Eventable
  ignoreNextEvent: false

  routesMappingsData: PTB.Routes.mappingData
  routesAliasData: PTB.Routes.aliasData

  rawParams: {}
  params: {}
  previousParams: {}
  route: null
  initialized: false
  setStateTimeout: null

  constructor: ->
    @routesMappings = new PTB.Routes.Mapper @routesMappingsData
    @paramsAlias = new PTB.Routes.ParamsAlias @routesAliasData
    @_bind()
    @_initializeState()

  _bind: ->
    window.addEventListener 'hashchange', =>
      @_parseLocation() unless @ignoreNextEvent
      @ignoreNextEvent = false

  setState: (params)->
    clearTimeout @setStateTimeout if @setStateTimeout
    @setStateTimeout = setTimeout =>
      @previousParams = @rawParams
      @rawParams = params
      @params = @paramsAlias.toAlias(params)
      @route = @routesMappings.routeFromParams(@params)

      @_changeLocation()
    , 250
    
    null

  getState: ->
    @rawParams

  getRoute: ->
    @route

  setParam: (param, value)->
    @rawParams[param] = value
    @setState(@rawParams)

  removeParam: (param)->
    if typeof @rawParams[param] != 'undefined'
      delete @rawParams[param]
      @setState(@rawParams)

  getParam: (param)->
    @rawParams[param]

  onParamChange: (param, cb)->
    @on "_param_#{param}", cb
    if typeof @rawParams[param] != 'undefined'
      cb(@rawParams[param])
    null

  toAlias: (param)->
    @paramsAlias.toAlias(param)

  fromAlias: (param)->
    @paramsAlias.fromAlias(param)

  isEmpty: ->
    @rawParams.keys.length == 0

  _initializeState: ->
    if not @initialized
      @_parseLocation()
      @initialized = true
    null

  _parseLocation: ->
    @route = @routesMappings.routeFromUrl()
    @previousParams = @rawParams
    @params = @route.params
    @rawParams = @paramsAlias.fromAlias(@route.params)

    @fire('change', @rawParams, @route.title)

    for paramValue, key of @rawParams
      if @rawParams[key] != @previousParams[key]
        @fire "_param_#{key}", paramValue
    null

  _changeLocation: ->
    @ignoreNextEvent = true
    window.history.replaceState {}, @route.title, @route.trailingSlashPath()
    window.location.hash = @route.hash()
