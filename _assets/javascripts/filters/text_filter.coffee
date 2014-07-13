class PTB.Filters.TextFilter extends PTB.Filters.BaseFilter
  name: 'text-filter'

  value: ''
  oldValue: ''

  changeTimeout: null

  constructor: ->
    super
    @bind()
    @bindRoute()

  bind: ->
    @eValue = @e.$$('.text-filter-value')
    @eValue.addEventListener 'keyup', @onChange.bind(@)

  onChange: ->
    clearTimeout @changeTimeout if @changeTimeout
    @changeTimeout = setTimeout =>
      @readValues()
      @changeRoute()
      @fire 'change', @shrinking
    , 250

  readValues: ->
    @oldValue = @value
    @value = @eValue.value.toLowerCase();
    @shrinking = @value[0...@oldValue.length].replace(@oldValue, '') == '' and @value != ''
    @active = @value != ''

  writeValues: ->
    @eValue.value = @value

  filter: (games, rejected)->
    return games if @value == ''
    accepted = []
    words = @value.replace(/[^a-z0-9 ]/ig, ' ').replace(/^\s+|\s+$/, '').split(/\s+/ig)
    query = new RegExp('^.*' + words.join('.*') + '.*$')
    for game in games
      attrVal = game.attributes[@filterValueName]
      if query.test attrVal
        accepted.push game
      else
        rejected.push game
    accepted

  getUrlValue: ->
    @value

  setUrlValue: (hashValue)->
    @value = hashValue
    @shrinking = false
    @oldValue = ''
    @active = @value != ''
    @writeValues()