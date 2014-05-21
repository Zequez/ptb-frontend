class PTB.Filters.ArrayFilter extends PTB.Filters.TextFilter
  name: 'array-filter'

  # It filters AND orders
  filter: (games, rejected)->
    accepted = []
    accepted_array = []

    tags = @value.replace(/[^a-z0-9, -]|^\s+|\s+$/ig, '').split(/\s*,\s*/ig)
    for tag, i in tags
      if tag == ''
        tags.splice(i, 1)
        --_i

    if tags.length == 0
      return games

    tags_regex = tags.map((tag)-> new RegExp("^" + tag, 'i'))

    for game in games
      matches = 0

      if game.attributes.categories
        for tag in game.attributes.categories
          for tag_regex in tags_regex
            if tag_regex.test(tag)
              matches++

      if matches > 0
        accepted_array[matches-1] ||= []
        accepted_array[matches-1].push game
      else
        rejected.push game

    accepted_array.reverse()

    console.log accepted_array

    for accepted_group in accepted_array
      for accepted_game in accepted_group
        accepted.push accepted_game

    accepted
