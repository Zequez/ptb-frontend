class PTB.Filters.BaseFilter extends PTB.TemplateElement
  active: false
  router: null

  constructor: (@e)->
    # Sadly I had to recur to JS since I didn't find a way
    # for the select elements to aquire 50% width of the
    # table cell without setting the width of the table cell
    @e.style.width = @e.offsetWidth + 'px'

    super

    @filterValueName = @e.attributes.filter.value
    @router = PTB.Services.inject('RouterService')
    

  createOptions: ->

  broadcast: (name, value)->
    @fire name, value

  filter: (games, rejected)->
    games

  changeRoute: ->
    if @active
      @router.setParam @filterValueName, @getUrlValue()
    else
      @router.removeParam @filterValueName

  bindRoute: ->
    @router.onParamChange(@filterValueName, @setUrlValue.bind(@))