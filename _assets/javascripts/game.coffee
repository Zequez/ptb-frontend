class PTB.Game extends PTB.Eventable
  name: 'game'
  built: false
  display: true

  oldHighlightedTags: []
  highlightedTags: []

  dateNow: Date.now()

  constructor: (@attributes)->
    @oldHighlightedTags = []
    @highlightedTags = []

    @attributes.lowerName = @attributes.name.toLowerCase()

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

    @attributes.totalReviews = @attributes.positive_reviews_length + @attributes.negative_reviews_length

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
      @attributes.positiveReviewsPercentage = Math.floor(@attributes.positive_reviews_length/@attributes.totalReviews*10000)/100
    else
      @attributes.positiveReviewsPercentage = null

    @attributes.tagsRating = 0

  buildElement: ->
    if not @built
      template = JST['templates/game'](@attributes)

      wrapper = document.createElement('tbody')
      wrapper.innerHTML = template
      @e = wrapper.firstChild

      @eTags = @e.$('.tag')

      @built = true

  highlightTags: (index)->
    @highlightedTags.push index
    @calculateTagsRating()

  unhighlightTags: ->
    @oldHighlightedTags.push(highlightTag) for highlightTag in @highlightedTags
    @highlightedTags = []

  # The lower the rating, the more matching tags
  calculateTagsRating: ->
    # The more tags you have, the lower the rating, thus more precedence
    majorOrder = - @highlightedTags.length * 1000

    # Tags that are lower in the index (AKA the most relevants) get precedence
    minorOrder = @highlightedTags.reduce (sum, val)-> sum + val

    @attributes.tagsRating = majorOrder + minorOrder

  render: ->
    @buildElement()
    # console.log @attributes.categories, @oldHighlightedTags, @highlightedTags
    for oldHighlightedTagIndex in @oldHighlightedTags
      @eTags[oldHighlightedTagIndex].classList.remove('highlighted')

    for highlightedTagIndex in @highlightedTags
      @eTags[highlightedTagIndex].classList.add('highlighted')

  toggle: (show)->
    # return if @display == show
    # @display = show
    # @buildElement()
    # if show
    #   @e.style.display = 'table-row'
    # else
    #   @e.style.display = 'none'

