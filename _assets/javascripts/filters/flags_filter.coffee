class PTB.Filters.FlagsFilter extends PTB.Filters.BaseFilter
  name: 'flags-filter'

  # TODO: Move all the messages to a I18n service or something
  flagsMessages:  {
    win: 'Windows',
    mac: 'Mac OSX',
    linux: 'Linux',
    singlePlayer: 'Single Player',
    multiPlayer: 'Multiplayer',
    coOp: 'Co-op',
    achievements: 'Achievements',
    cloud: 'Steam cloud',
    cards: 'Steam cards',
    controller: 'Controller support',
    partialController: 'Partial controller support',
    stats: 'Stats',
    workshop: 'Steam Workshop',
    captions: 'Closed Captions',
    commentary: 'Commentaries',
    levelEditor: 'Level editor',
    vac: 'Valve Anti-Cheat',
    vr: 'Virtual Reality support',
    leaderboards: 'Steam leaderboards'
  }

  constructor: (@e)->
    @dataService = PTB.Services.inject('DataService')
    @readOptions()
    @attributes = {}
    @attributes.flagsMessages = @flagsMessages
    @dataService[@flagsListDataName] (flagsList)=>
      @flagsList = @attributes.flagsList = flagsList
      super(@e)
      @bind()

  readOptions: ->
    @flagsListDataName = @e.attributes['flags-list-data'].value

  bind: ->
    @eInputs = @e.$('.filter-flag-input')
    @e.addEventListener 'change', => @onChange()

  onChange: ->
    @readValues()
    @fire('change')

  readValues: ->
    @value = 0
    for input in @eInputs
      if input.checked
        @value += parseInt(input.value)

    @active = @value > 0

  writeValues: ->
    for input in @eInputs
      if parseInt(input.value) & @value
        input.checked = true
    null

  setUrlValue: (hashValue)->
    flagsNames = hashValue.split('.')
    @value = 0
    for flagName in flagsNames
      if @flagsList[flagName]
        @value += @flagsList[flagName]

    @writeValues()

  getUrlValue: ->
    flagsNames = []
    for flagName, flagValue of @flagsList
      if flagValue & @value
        flagsNames.push flagName

    flagsNames.join('.')
      

  filter: (games, rejected)->
    return games if not @value
    
    accepted = []
    for game in games
      attrVal = game.attributes[@filterValueName]
      if attrVal && (attrVal & @value) >= @value
        accepted.push game
      else
        rejected.push game

    accepted
