class PTB.PageCtrl
  gamesUrl: '/games.json'
  games: []
  filteredGames: []

  constructor: ->
    @e = $$('.table')
    @ePageTitle = $$('title')
    @ePageSubtitle = $$('.subtitle')

    @dataService = PTB.Services.inject 'DataService' # Make-believe dependency injection

    @autorender = document.location.hash != ''

    @build()

    @dataService.all (data)=>
      @parseResults(data)

  build: ->
    @tooltipler = new PTB.Tooltipler

  parseResults: (data)->
    console.time 'Build time'

    for gameAttr in data.games
      gameAttr.flagsList = data.flags
      gameAttr.osFlagsList = data.osFlags
      gameAttr.featuresFlagsList = data.featuresFlags
      @games.push(new PTB.Game(gameAttr))
    @filteredGames = @games
    @buildContainers()
    
    @router.initializeState()

  buildContainers: ->
    @gamesContainer = new PTB.GamesContainer @games
    @filtersContainer = new PTB.FiltersContainer
    @sortersContainer = new PTB.SortersContainer
    @router = new PTB.Routes.Router
    @filtersContainer.createOptions @games
    @bind()

  bind: ->
    @filtersContainer.on 'change', (shrinker)=> 
      @filter(shrinker)
      @route()
    @sortersContainer.on 'change', => 
      @sort()
      @route()
    @router.on 'change', (states, title)=>
      @setPageTitle title
      @sortersContainer.setSortState(states)
      @filtersContainer.setFiltersState(states)
      @filter() if @autorender
      @autorender = true
    @e.addEventListener 'click', @onClick.bind(@)

  render: ->
    @gamesContainer.setGames @filteredGames
    console.time 'Render time'
    @gamesContainer.render()
    console.timeEnd 'Render time'

  # The shrinker parameter is to optimize
  # So if we know the change in the filtering
  # will shrink our current list, then we start processing
  # from the previous filtered list rather than the whole
  # list of games.
  filter: (shrinker)->
    console.time 'Filter time'
    accepted = if shrinker then @filteredGames else @games
    rejected = []
    accepted = @filtersContainer.filter(@games, rejected)
    #console.log 'Accepted: ', accepted.length
    #console.log 'Rejected: ', rejected.length
    console.timeEnd 'Filter time'
    #console.time 'Toggle time'
    # if not shrinker
      # game.toggle true for game in accepted
    # game.toggle false for game in rejected
    #console.timeEnd 'Toggle time'
    @filteredGames = accepted

    @sort()

  sort: ->
    @sortersContainer.sort @filteredGames
    @render()

  route: ->
    filterStates = @filtersContainer.getFiltersState()
    sorterStates = @sortersContainer.getSortState()
    for stateName, stateValue of sorterStates
      filterStates[stateName] = stateValue

    route = @router.setState(filterStates)
    @setPageTitle route.title

  onClick: (ev)->
    if ev.target.classList.contains('tag')
      @filtersContainer.broadcast('tag', ev.target.innerHTML)

  setPageTitle: (title)->
    previousTitle = @ePageTitle.innerHTML
    previousTitle = previousTitle.split(/\s+\-\s+/)[0]
    @ePageTitle.innerHTML = "#{previousTitle} - #{title}"
    @ePageSubtitle.innerHTML = title
