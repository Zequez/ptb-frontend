class PTB.Services.DataService
  callbacks: {}
  data: null
  dataUrl: null
  loading: false

  constructor: ->
    # TODO: Change the name of games-db to data-url
    @dataUrl = '/' + document.body.attributes['games-db'].value

  games: (cb)-> @_getData(cb, 'games')
  osFlags: (cb)-> @_getData(cb, 'os_flags')
  flags: (cb)-> @_getData(cb, 'flags')
  tags: (cb)-> @_getData(cb, 'tags')
  all: (cb)-> @_getData(cb, '')

  _getData: (cb, key)->
    if not @data
      @callbacks[key] ||= []
      @callbacks[key].push cb
      @_fetchData()
    else
      if key
        cb @data[key]
      else
        cb @data

  _fetchData: ->
    if not @loading
      @loading = true
      request = new XMLHttpRequest()

      request.addEventListener 'load', (ev)=>
        console.timeEnd 'Fetch time'
        @_parseResults(request.responseText)

      console.time 'Fetch time'
      request.open 'GET', @dataUrl, true
      request.send()

  _parseResults: (responseText)->
    console.time 'JSON parse time'
    @data = JSON.parse(responseText)#[2300..2350]
    console.timeEnd 'JSON parse time'
    @_triggerCallbacks()

  _triggerCallbacks: ->
    for key, callbacks of @callbacks
      for cb in callbacks
        if key
          cb @data[key]
        else
          cb @data

    @callbacks = {}

