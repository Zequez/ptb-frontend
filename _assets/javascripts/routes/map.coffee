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
    paramsMatch = 0
    paramsLength = 0

    hasParams = false
    for paramName, paramVal of @params
      paramsLength++
      hasParams = true
      for queryParamName, queryParamVal of queryParams
        if paramName == queryParamName and paramVal == queryParamVal
          paramsMatch++

    if paramsMatch == paramsLength
      paramsMatch
    else
      0

  generateRoute: (queryParams)->
    additionalParams = {}
    for queryParamName, queryParamValue of queryParams
      if @params[queryParamName] == undefined
        additionalParams[queryParamName] = queryParamValue
    new PTB.Routes.Route @path, @params, additionalParams, @title