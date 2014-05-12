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
    games.sort (a, b)=>
      aa = a.attributes[@sortValueName]
      bb = b.attributes[@sortValueName]

      if aa > bb
        if @ascending then 1 else -1
      else if aa < bb
        if @ascending then -1 else 1
      else
        0
    null


  readStatusQuo: ->
    @ascending = @e.classList.contains 'ascending'
