class PTB.SortersContainer extends PTB.DOMElement
  name: 'sorters-container'

  sorters: []
  activeSorter: null


  constructor: ->
    super
    @buildSorters()
    @router = PTB.Services.inject('RouterService')

    @bind()

  buildSorters: ->
    @sorters = [] 
    for eSorter in @e.$('[sort]')
      @sorters.push new PTB.Sorter eSorter

  bind: ->
    for sorter in @sorters
      sorter.on 'change', (sorter)=>
        @changeSorter(sorter)
        @changeRoute()
        @fire 'change'

    @router.onParamChange 'sort', (sortName)=> @setSortState sortName, true
    @router.onParamChange 'sortd', (sortName)=> @setSortState sortName, false

  sort: (games)->
    if @activeSorter
      @activeSorter.sort games
    null

  # readStatusQuo: ->
  #   for sorter in @sorters
  #     if sorter.enabled?
  #       @activeSorter = sorter
  #       return

  setSortState: (sortName, ascending)->
    sortName = @router.fromAlias sortName
    for sorter in @sorters
      if sorter.sortValueName == sortName
        sorter.setAscending(ascending)
        @changeSorter(sorter)

  changeSorter: (sorter)->
    if @activeSorter? and @activeSorter != sorter
      @activeSorter.reset()
    @activeSorter = sorter

  changeRoute: ->
    param = if @activeSorter.ascending then 'sort' else 'sortd'
    oldParam = if @activeSorter.ascending then 'sortd' else 'sort'
    value = @router.toAlias @activeSorter.sortValueName
    @router.setParam param, value
    @router.removeParam oldParam

class PTB.Sorter extends PTB.DOMElement
  ascending: false
  enabled: false

  constructor: (@e)->
    @sortValueName = @e.attributes.sort.value
    @bind()

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
    # "Hey! Why not just use classList.toggle(token, FORCE)"
    # Some fucking browsers, like PhantomJS don't support the force option
    method = if @ascending and @enabled then 'add' else 'remove'
    @e.classList[method]('ascending')
    method = if !@ascending and @enabled then 'add' else 'remove'
    @e.classList[method]('descending')

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
        a.attributes.steamAppId - b.attributes.steamAppId
    null


  # readStatusQuo: ->
  #   startAscending = @e.classList.contains 'ascending'
  #   startDescending = @e.classList.contains 'descending'
  #   if startAscending
  #     @ascending = true
  #     @enabled = true
  #   else if startDescending
  #     @ascending = false
  #     @enabled = true
  #   else
  #     @enabled = false