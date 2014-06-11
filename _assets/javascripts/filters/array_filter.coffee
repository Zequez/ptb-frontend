class PTB.Filters.ArrayFilter extends PTB.Filters.TextFilter
  name: 'array-filter'

  getUrlValue: ->
    value = @cleanValue().join('/')
    console.log value
    value

  setUrlValue: (hashValue)->
    @value = hashValue.replace(/\//g, ', ')
    @shrinking = false
    @oldValue = ''
    @active = @value != ''
    @writeValues()

  cleanValue: ->
    @value.replace(/[^a-z0-9 \-&,]/ig, ' ').replace(/^\s+|\s+$/, '').split(/\s*,\s*/ig)

  # It filters AND orders
  filter: (games, rejected)->
    accepted = []
    accepted_array = []

    tags = @cleanValue()
    for tag, i in tags
      if tag == ''
        tags.splice(i, 1)
        --_i

    if tags.length == 0
      game.unhighlightTags() for game in games
      return games

    tags_regex = tags.map((tag)-> new RegExp("^" + tag.replace(/-/g, '\\-'), 'i'))

    for game in games
      matches = 0
      game.unhighlightTags()
      attribute = game.attributes[@filterValueName]
      if attribute
        for tag, i in attribute
          for tag_regex in tags_regex
            if tag_regex.test(tag)
              matches++
              game.highlightTags(i)

      if matches > 0
        accepted_array[matches-1] ||= []
        accepted_array[matches-1].push game
      else
        rejected.push game

    accepted_array.reverse()

    for accepted_group in accepted_array
      for accepted_game in accepted_group
        accepted.push accepted_game

    accepted

  bind: ->
    super
    @on 'tag', (value)=>
      if @eValue.value == ''
        @eValue.value += value
      else
        @eValue.value += ', ' + value
      @onChange()
