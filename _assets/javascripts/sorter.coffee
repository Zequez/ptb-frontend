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
        if @activeSorter? and @activeSorter != sorter
          @activeSorter.reset()
        @activeSorter = sorter
        @fire 'change'

  sort: (games)->
    if @activeSorter
      @activeSorter.sort games
    null

  readStatusQuo: ->
    for sorter in @sorters
      if sorter.ascending?
        @activeSorter = sorter
        return

class PTB.Sorter extends PTB.DOMElement
  ascending: null

  constructor: (@e)->
    @sortValueName = @e.attributes.sort.nodeValue
    @bind()
    @readStatusQuo()

  bind: ->
    @e.addEventListener 'click', => @changeDirection() 

  changeDirection: ->
    @ascending = !@ascending
    @drawDirection()
    @fire 'change', @

  drawDirection: ->
    ascending = @ascending == true
    descending = @ascending == false
    @e.classList.toggle 'ascending', ascending
    @e.classList.toggle 'descending', descending


  reset: ->
    @ascending = null
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
        0
    null


  readStatusQuo: ->
    @ascending = @e.classList.contains 'ascending'
