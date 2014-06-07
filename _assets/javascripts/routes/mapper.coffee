class PTB.Routes.Mapper
  constructor: (@routesMappingData)->
    @mappings = []
    @mappingsHash = {}
    for routePath, routeData of @routesMappingData
      mapping = new PTB.Routes.Map routePath, routeData
      @mappings.push mapping
      @mappingsHash[routePath] = mapping
    @rootMapping = @mappingsHash['/']

    for mapping in @mappings
      if not mapping.title
        mapping.title = @rootMapping.title

  routeFromParams: (params)->
    i = 0
    maxMatches = 0
    maxMatchesMap = null
    for map in @mappings
      matches = map.matchParams(params)
      if matches > maxMatches
        maxMatches = matches
        maxMatchesMap = map
      else if matches == maxMatches and matches != 0
        console.warn 'Routes collision!', map.path, maxMatchesMap.path

    if maxMatchesMap
      maxMatchesMap.generateRoute(params)
    else
      @rootMapping.generateRoute(params)

  routeFromUrl: ->
    hash = window.location.hash.replace(/^#/, '')
    path = window.location.pathname.replace(/\/$/, '')
    arrayStringParams = hash.split('&')

    params = {}
    for stringParam in arrayStringParams
      nameVal = stringParam.split(/\=/)
      params[nameVal[0]] = (if nameVal[1] then decodeURIComponent(nameVal[1]) else null)

    mapping = @mappingsHash[path] || @rootMapping
    route = mapping.generateRoute(params)