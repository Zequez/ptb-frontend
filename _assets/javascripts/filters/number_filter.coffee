class PTB.Filters.NumberFilter extends PTB.Filter
  name: 'number-filter'
  options: []

  constructor: ->
    super
    @bind()
    @readValues()
    @findPlaceholder()

  bind: ->
    @eValueStart = @e.getElementsByClassName('number-filter-value-start')[0]
    @eValueEnd = @e.getElementsByClassName('number-filter-value-end')[0]

    @eValueStart.addEventListener 'change', => @onChange()
    @eValueEnd.addEventListener 'change', => @onChange()

  onChange: ->
    @applyPlaceholder()
    @readValues()
    @fire('change')

  readValues: ->
    @valueStart = @parseValue @eValueStart.value
    @valueEnd = @parseValue @eValueEnd.value
    @active = @valueStart.selected || @valueEnd.selected

  writeValues: ->
    @eValueStart.value = @valueStart.raw
    @eValueEnd.value = @valueEnd.raw

  setUrlValue: (hashValue)->
    [start, end] = hashValue.replace(/\+/g, '>').split(/~/)

    if not end? or @parseOptionsValue(start) == false or @parseOptionsValue(end) == false
      return

    foundStart = false
    foundEnd = false
    for option in @options
      if option.raw == start
        @valueStart = @parseValue option.value
        foundStart = true

      if option.raw == end
        @valueEnd = @parseValue option.value
        foundEnd = true

    if not foundStart and start != ''
      option = @parseOption(start)
      @options.push option
      @insertOption option
      @valueStart = @parseValue option.value
    if not foundEnd and end != ''
      option = @parseOption(end)
      @options.push option
      @insertOption option
      @valueEnd = @parseValue option.value

    @active = @valueStart.selected || @valueEnd.selected
    @writeValues()

  getUrlValue: ->
    start = ''
    end = ''
    for option in @options
      if option.value == @valueStart.raw
        start = option.raw

      if option.value == @valueEnd.raw
        end = option.raw

    [start, end].join('~').replace(/>/g, '+')

  parseValue: (value)->
    parsedValue = {
      raw: value
      number: parseFloat(value.replace('>', '')),
      open: />/.test(value)
      selected: value != ''
    }
    parsedValue.number = null if isNaN(parsedValue.number)
    parsedValue

  createOptions: ->
    @parseOptions()
    @insertOptions()

  insertOptions: ->
    for option in @options
      @insertOption(option)

  insertOption: (option)->
    option.eStart = document.createElement('option')
    option.eStart.value = option.value
    textNode = document.createTextNode(option.label)
    option.eStart.appendChild textNode
    @eValueStart.appendChild option.eStart
    if not /\>/.test option.value
      option.eEnd = option.eStart.cloneNode(true)
      @eValueEnd.appendChild option.eEnd

  parseOptions: ->
    @options = [] # We create a new array
    @rawOptions = @e.attributes['filter-options']
    if @rawOptions
      @rawOptions = @rawOptions.value
      @rawOptions = @rawOptions.split(',')
      for rawOption in @rawOptions
        @options.push @parseOption(rawOption)

  parseOption: (rawOption)->
    valueAndText = rawOption.replace(' ', '///').split('///') # This is just lazy to allow spaces after the first space
    if valueAndText.length == 1
      valueAndText.push(valueAndText[0])
    option =
      raw: valueAndText[0]
      value: @parseOptionsValue(valueAndText[0], valueAndText[1])
      label: @parseOptionsText(valueAndText[1], valueAndText[0])
      eStart: null
      eEnd: null

  parseOptionsValue: (value)-> value
  parseOptionsText: (text)-> text

  filter: (games, rejected)->
    # We need 2 arrays so we can show/hide the appropiate games without having
    # hide/show all first, or iterate through all the games to check which are rejected
    # removing the accepted. It's around 8 times faster, I tested. ~5ms vs ~40ms, it's a lot!
    accepted = []
    for game in games
      attrVal = game.attributes[@filterValueName]
      # If the filter is deactivated
      if not @valueStart.selected and not @valueEnd.selected
        accepted.push game
      # If the value is null, we only accept it
      # if the start filter is deactivated
      # or if the start filter is null
      else if attrVal == null
        if not @valueStart.selected or @valueStart.number == null
          accepted.push game
        else 
          rejected.push game
      else if @valueEnd.selected and @valueEnd.number == null
        rejected.push game
      else
        numberStart = if (@valueStart.number == null) then 0 else @valueStart.number
        numberEnd = @valueEnd.number
        isRejected = false
        if @valueStart.selected
          isRejected = attrVal < numberStart
        if not isRejected and @valueStart.selected and @valueStart.open
          isRejected = attrVal == numberStart
        if not isRejected and @valueEnd.selected
          isRejected = attrVal > @valueEnd.number
        
        if isRejected
          rejected.push game
        else
          accepted.push game
    accepted

  findPlaceholder: ->
    @eStartPlaceholder = @eValueStart.children[@eValueStart.selectedIndex]
    @eEndPlaceholder = @eValueEnd.children[@eValueEnd.selectedIndex]

  applyPlaceholder: ->
    if @eValueStart.value == ''
      @eStartPlaceholder.selected = true
    @eValueStart.classList.toggle('placeholdered', @eValueStart.value == '')

    if @eValueEnd.value == ''
      @eEndPlaceholder.selected = true
    @eValueEnd.classList.toggle('placeholdered', @eValueEnd.value == '')