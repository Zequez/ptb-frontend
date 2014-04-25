#= require 'timeSince'
#= require_tree './templates'
#= require elements
#= require filters

class GamesContainer extends DOMElement
	name: 'games-container'

	constructor: (@games)-> super

	render: ->
		# We use a fragment to prevent triggering a reflow
		# each time we append an element
		fragment = document.createDocumentFragment()
		for game in @games
			fragment.appendChild game.e
		@e.appendChild fragment

class TitlesContainer

class Title


class Game extends TemplateElement
	name: 'game'
	tmpWrapper: 'tbody'
	displayValue: 'table-cell'

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


# Get /games.json through AJAX
###############################

request = new XMLHttpRequest()

request.addEventListener 'load', (ev)->
	games = []
	for gameAttr in JSON.parse(request.responseText)
		games.push(new Game(gameAttr))
	gamesContainer = new GamesContainer games
	gamesContainer.render()

request.open 'GET', 'games.json', true
request.send()