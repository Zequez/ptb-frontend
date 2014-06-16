class PTB.Routes.ParamsAlias
  constructor: (@parametersAlias)->

  toAlias: (params)->
    return @paramToAlias(params) if typeof params == 'string'

    newParams = {}
    for parameterName, parameterValue of params
      if @parametersAlias[parameterName]
        newParams[@parametersAlias[parameterName]] = parameterValue
      else
        newParams[parameterName] = parameterValue
    newParams

  fromAlias: (params)->
    return @paramFromAlias(params) if typeof params == 'string'

    newParams = {}
    for parameterName, parameterValue of params
      newParams[parameterName] = parameterValue
      for name, alias of @parametersAlias
        if alias == parameterName
          newParams[name] = parameterValue
          delete newParams[alias]
    newParams

  paramToAlias: (param)->
    @parametersAlias[param] || param

  paramFromAlias: (aliasedParam)->
    for originalParam, dataAliasedParam of @parametersAlias
      if aliasedParam == dataAliasedParam
        return originalParam
    aliasedParam
