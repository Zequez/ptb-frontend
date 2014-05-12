class PTB.GamesContainer extends PTB.DOMElement
	name: 'games-container'

	initialRender: 250
	currentRender: 250
	autoLoadPixelsAway: 1000

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
			fragment.appendChild game.e
		@e.appendChild fragment

		@currentRender = @initialRender

	renderMore: (amount = 50)->
		gamesToRender = @games[@currentRender...(@currentRender+amount)]
		fragment = document.createDocumentFragment()
		for game in gamesToRender
			fragment.appendChild game.e
		@e.appendChild fragment

		@currentRender += amount

	empty: ->
		@e.innerHTML = ''
		# @e.removeChild @e.firstChild while @e.firstChild

	autoLoad: ->
		if document.body.clientHeight-document.body.scrollTop <= @autoLoadPixelsAway
			@renderMore()


class PTB.Game extends PTB.TemplateElement
	name: 'game'
	tmpWrapper: 'tbody'
	displayValue: 'table-row'

	constructor: (@attributes)->
		@attributes.launchDateSince = if @attributes.launch_date 
		then timeSince(new Date(@attributes.launch_date))
		else null

		@attributes.gameUpdatedAtSince = if @attributes.gameUpdatedAtSince
		then timeSince(new Date(@attributes.game_updated_at))
		else null

		@attributes.totalReviews = @attributes.positive_reviews + @attributes.negative_reviews

		@attributes.averageTimeOverPrice = Math.round((@attributes.average_time / @attributes.price) * 100) / 100
		
		super