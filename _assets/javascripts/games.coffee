class PTB.GamesContainer extends PTB.DOMElement
	name: 'games-container'

	initialRender: 100
	currentRender: 100
	autoLoadPixelsAway: 2000

	constructor: (@games)-> 
		super
		@bind()

	bind: ->
		document.addEventListener 'scroll', @autoLoad.bind(@)

	setGames: (@games)->

	render: ->
		# We use a fragment to prevent triggering a reflow
		# each time we append an element
		gamesToRender = @games[0...@initialRender]

		@empty()
		fragment = document.createDocumentFragment()
		for game in gamesToRender
			game.render()
			fragment.appendChild game.e
		@e.appendChild fragment

		@currentRender = @initialRender

	renderMore: (amount = 50)->
		gamesToRender = @games[@currentRender...(@currentRender+amount)]
		fragment = document.createDocumentFragment()
		for game in gamesToRender
			game.render()
			fragment.appendChild game.e
		@e.appendChild fragment

		@currentRender += amount

	empty: ->
		@e.innerHTML = ''
		# @e.removeChild @e.firstChild while @e.firstChild

	autoLoad: ->
		if document.body.clientHeight-document.body.scrollTop <= @autoLoadPixelsAway
			@renderMore()