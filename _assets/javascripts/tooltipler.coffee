class PTB.Tooltipler
  mousePosX: 0
  mousePosY: 0
  visible: false

  constructor: ->
    @createElement()
    @bind()
    @insert()

  createElement: ->
    template = JST['templates/tooltipler']()
    wrapper = document.createElement('div')
    wrapper.innerHTML = template
    @e = wrapper.firstChild
    @eTip = @e.$$('.tooltip-tip')
    @eTitle = @e.$$('.tooltip-title')

  bind: ->
    document.body.addEventListener 'mouseover', (ev)=> @toggle(@title ev.target)
    document.body.addEventListener 'mousemove', (ev)=> @updateMousePos(ev)

  insert: ->
    document.body.appendChild @e

  updateMousePos: (ev)->
    @mousePosX = ev.pageX
    @mousePosY = ev.pageY
    @updateTooltipPos()

  updateTooltipPos: ->
    if @visible
      docWidth = document.documentElement.clientWidth
      scrollLeft = document.body.scrollLeft
      midway = @e.clientWidth / 2

      offScreenAdjust = (docWidth + scrollLeft) - (@mousePosX + midway)
      offScreenAdjust = 0 if offScreenAdjust > 0

      @transform @eTip, (-offScreenAdjust)
      @transform @e, (@mousePosX - midway + offScreenAdjust), (@mousePosY + 25)

  setThePositionToTheTopLeftSoTheFuckerDoesntGlitchTheBodyOverflowOnChrome: ->
    @transform @e, 0, 0

  title: (el)->
    el = el.parentElement while not el.title and not el.tooltipler and el.parentElement
    if el.title
      el.tooltipler = el.title
      el.title = ''
    el.tooltipler

  toggle: (title)->
    if title
      @setThePositionToTheTopLeftSoTheFuckerDoesntGlitchTheBodyOverflowOnChrome()
      title = title.replace(String.fromCharCode(13), '<br/>')
      console.log title, title.length
      @eTitle.innerHTML = title
      @visible = true
      @e.classList.add('visible')
      @updateTooltipPos()
    else
      @e.classList.remove('visible')

  transform: (el, left = 0, top = 0)->
    el.style.transform = "translate(#{left}px, #{top}px)"
    el.style.webkitTransform = "translate(#{left}px, #{top}px)"
    el.style.msTransform = "translate(#{left}px, #{top}px)"