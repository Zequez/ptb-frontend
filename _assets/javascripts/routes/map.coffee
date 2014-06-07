class PTB.Routes.Map
  title: ''
  params: {}
  additionalParams: {}

  constructor: (path, routeData)->
    @path = path
    @title = routeData.title
    delete routeData.title
    @params = routeData

  matchParams: (queryParams)->
    @additionalParams = {}
 
    count = 0
    hasParams = false
    for paramName, paramVal of @params
      count++
      hasParams = true
      for queryParamName, queryParamVal of queryParams
        if paramName == queryParamName and paramVal == queryParamVal
          count--

    count == 0 and hasParams

  generateRoute: (queryParams)->
    additionalParams = {}
    for queryParamName, queryParamValue of queryParams
      if not @params[queryParamName]
        additionalParams[queryParamName] = queryParamValue
    new PTB.Routes.Route @path, @params, additionalParams, @title