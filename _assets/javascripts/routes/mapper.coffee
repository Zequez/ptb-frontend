class PTB.Routes.Mapper
  constructor: (@routesMappingData)->
    @mappings = []
    @mappingsHash = {}
    for routePath, routeData of @routesMappingData
      mapping = new PTB.Routes.Map routePath, routeData
      @mappings.push mapping
      @mappingsHash[routePath] = mapping
    @rootMapping = @mappingsHash['/']

  routeFromParams: (params)->
    i = 0
    while i < @mappings.length and not matchRoute
      matchRoute = @mappings[i].matchParams(params)
      i++
    i--

    if matchRoute
      @mappings[i].generateRoute()
    else
      @rootMapping.generateRoute(params)

  routeFromUrl: ->
    hash = window.location.hash.replace(/^#/, '')
    path = window.location.pathname
    arrayStringParams = hash.split('&')

    params = {}
    for stringParam in arrayStringParams
      nameVal = stringParam.split(/\=/)
      params[nameVal[0]] = (if nameVal[1] then decodeURIComponent(nameVal[1]) else null)

    mapping = @mappingsHash[path] || @rootMapping
    route = mapping.generateRoute(params)