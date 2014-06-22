class PTB.Routes.Route
  constructor: (@path, @pathParams, @searchParams, @title)->
    @params = {}
    # Who needs merge?
    for k, v of @pathParams
      @params[k] = v
    for k, v of @searchParams
      @params[k] = v

    # Not the best fix, but the fix I deserve
    if @pathParams.sort and @searchParams.sortd
      delete @params.sort
    if @pathParams.sortd and @searchParams.sort
      delete @params.sortd

  hash: ->
    arrayStringParams = for paramName, paramVal of @searchParams
      encodedVal = encodeURIComponent(paramVal).replace(/%2B/g, '+').replace(/%2F/g, '/')
      paramName + (if paramVal then "=#{encodedVal}" else '')
    arrayStringParams.join('&')

  trailingSlashPath: ->
    @path.replace(/\/$/, '') + '/'

  hasAdditionalParams: ->
    for paramName of @searchParams
      return true
    return false