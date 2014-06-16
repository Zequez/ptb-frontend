class PTB.Filters.FlagsFilter extends PTB.Filters.BaseFilter
  name: 'flags-filter'

  constructor: (@e)->
    @dataService = PTB.Services.inject('DataService')
    @i18n = PTB.Services.inject('I18n')
    @readOptions()
    @attributes = {}
    @attributes.flagsMessages = @i18n.t 'flags'
    @dataService[@flagsListDataName] (flagsList)=>
      @flagsList = @attributes.flagsList = flagsList
      super(@e)
      @bind()
      @bindRoute()

  readOptions: ->
    @flagsListDataName = @e.attributes['flags-list-data'].value

  bind: ->
    @eInputs = @e.$('.filter-flag-input')
    @e.addEventListener 'change', => @onChange()

  onChange: ->
    @readValues()
    @changeRoute()
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
