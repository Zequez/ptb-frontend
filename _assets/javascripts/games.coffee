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
			game.render()
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

	oldHighlightedTags: []
	highlightedTags: []

	dateNow: Date.now()

	constructor: (@attributes)->
		# All of this could be calculated on the scrapper when saving the data for the client
		# that way we would have to process less when loading the page
		if @attributes.launch_date
			@attributes.launchDateSince = @dateNow - @attributes.launch_date
			@attributes.launchDateSinceText = timeSince(new Date(@attributes.launch_date))
		else 
			@attributes.launchDateSince = null
			@attributes.launchDateSinceText = null

		# @attributes.gameUpdatedAtSince = if @attributes.gameUpdatedAtSince
		# then timeSince(new Date(@attributes.game_updated_at))
		# else null

		@attributes.totalReviews = @attributes.positive_reviews + @attributes.negative_reviews

		@attributes.price = 0 if not @attributes.price? # TODO: Fix this on the Ruby scrapper

		@attributes.finalPrice = if @attributes.sale_price? then @attributes.sale_price else @attributes.price
		if @attributes.finalPrice == 0 or @attributes.finalPrice == null or @attributes.average_time == null
			@attributes.averageTimeOverPrice = null
		else
			@attributes.averageTimeOverPrice = Math.round((@attributes.average_time / @attributes.finalPrice) * 100) / 100

		if @attributes.playtime_deviation?
			@attributes.playtimeDeviationPercentage = Math.floor((@attributes.playtime_deviation / @attributes.average_time - 1) * 100) / 100
		else
			@attributes.playtimeDeviationPercentage = null

		if @attributes.totalReviews > 0
			@attributes.positiveReviewsPercentage = Math.floor(@attributes.positive_reviews/@attributes.totalReviews*100)
		else
			@attributes.positiveReviewsPercentage = null

		super

		@eTags = @e.$('.tag')

	highlightTags: (index)->
		@highlightedTags.push index

	unhighlightTags: ->
		@oldHighlightedTags = @highlightedTags
		@highlightedTags = []

	render: ->
		for highlightedTagIndex in @highlightedTags
			console.log @eTags, highlightedTagIndex, @attributes.categories[highlightedTagIndex]
			@eTags[highlightedTagIndex].classList.add('highlighted')

		for oldHighlightedTagIndex in @oldHighlightedTags
			@eTags[highlightedTagIndex].classList.remove('highlighted')