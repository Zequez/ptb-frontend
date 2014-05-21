class PTB.Filters.TextFilter extends PTB.Filter
  name: 'text-filter'

  value: ''
  oldValue: ''

  constructor: ->
    super
    @bind()

  bind: ->
    @eValue = @e.$$('.text-filter-value')
    @eValue.addEventListener 'keyup', @onChange.bind(@)

  onChange: ->
    @oldValue = @value
    @value = @eValue.value
    @shrinking = @value[0...@oldValue.length].replace(@oldValue, '') == '' and @value != ''

    @fire 'change', @shrinking

  filter: (games, rejected)->
    return games if @value == ''
    accepted = []
    words = @value.replace(/[^a-z0-9 ]|^\s+|\s+$/ig, '').split(/\s+/ig)
    query = new RegExp('^.*' + words.join('.*') + '.*$', 'i')
    for game in games
      attrVal = game.attributes[@filterValueName]
      if query.test attrVal
        accepted.push game
      else
        rejected.push game
    accepted
