class PTB.SortersContainer extends PTB.DOMElement
  name: 'sorters-container'

  sorters: []
  activeSorter: null

  constructor: ->
    super
    @buildSorters()
    @bind()
    @readStatusQuo()
    

  buildSorters: ->
    @sorters = [] 
    for eSorter in @e.$('[sort]')
      @sorters.push new PTB.Sorter eSorter

  bind: ->
    for sorter in @sorters
      sorter.on 'change', (sorter)=>
        @changeSorter(sorter)
        @fire 'change'

  sort: (games)->
    if @activeSorter
      @activeSorter.sort games
    null

  readStatusQuo: ->
    for sorter in @sorters
      if sorter.enabled?
        @activeSorter = sorter
        return

  getSortState: ->
    states = {}
    states[@addSortPrefix @activeSorter.sortValueName] = (if @activeSorter.ascending then null else 'descending')
    states

  setSortState: (states)->
    for stateName, stateValue of states
      if stateName[0..3] == 'sort'
        unprefixedName = @removeSortPrefix(stateName)
        for sorter in @sorters
          if sorter.sortValueName == unprefixedName
            sorter.setAscending(stateValue != 'descending')
            @changeSorter(sorter)

  changeSorter: (sorter)->
    if @activeSorter? and @activeSorter != sorter
      @activeSorter.reset()
    @activeSorter = sorter

  addSortPrefix: (name)->
    'sort' + @capitalize(name)

  removeSortPrefix: (name)->
    @uncapitalize(name[4..])

  capitalize: (string)->
    string.charAt(0).toUpperCase() + string[1..]

  uncapitalize: (string)->
    string.charAt(0).toLowerCase() + string[1..]


class PTB.Sorter extends PTB.DOMElement
  ascending: false
  enabled: false

  constructor: (@e)->
    @sortValueName = @e.attributes.sort.value
    @bind()
    @readStatusQuo()

  bind: ->
    @e.addEventListener 'click', => @changeDirection() 

  setAscending: (ascending)->
    @enabled = ascending?
    @ascending = ascending == true
    @drawDirection()

  changeDirection: ->
    @enabled = true
    @ascending = !@ascending
    @drawDirection()
    @fire 'change', @

  drawDirection: ->
    @e.classList.toggle 'ascending', @ascending and @enabled
    @e.classList.toggle 'descending', !@ascending and @enabled

  reset: ->
    @enabled = false
    @drawDirection()

  sort: (games)->
    answer = if @ascending then 1 else -1

    games.sort (a, b)=>
      aa = a.attributes[@sortValueName]
      bb = b.attributes[@sortValueName]

      # I could do it the "right way" but why bother? 
      # It's not like I'm going to use negative values anyway
      aa = -999 if aa == null
      bb = -999 if bb == null

      if aa > bb
        answer
      else if aa < bb
        answer*-1
      else
        # This is the "right way" to make null lower than any number
        # But it's obviously slower than asigning an arbitrary negative number to null values
        # Null is always lower
        # if aa != null and bb == null # aa > bb
        #   answer
        # else if aa == null and bb != null # aa < bb
        #   answer*-1
        # else
        #   0
        a.attributes.steam_app_id - b.attributes.steam_app_id
    null


  readStatusQuo: ->
    startAscending = @e.classList.contains 'ascending'
    startDescending = @e.classList.contains 'descending'
    if startAscending
      @ascending = true
      @enabled = true
    else if startDescending
      @ascending = false
      @enabled = true
    else
      @enabled = false