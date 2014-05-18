class PTB.Filters.DateFilter extends PTB.Filters.NumberFilter
  name: 'date-filter'

  timeMultipliers: {
    'd': 1000*60*60*24,
    'w': 1000*60*60*24*7,
    'm': 1000*60*60*24*30,
    'y': 1000*60*60*24*365
  }

  parseOptionsValue: (value)->
    open = />/.test value
    matchResult = value.match(/([0-9]+)([a-z]+)/i)
    numericValue = matchResult[1]
    timeConstant = matchResult[2]
    timeMultiplier = @timeMultipliers[timeConstant]
    timeAgoInMilliseconds = numericValue * timeMultiplier
    (if open then '>' else '') + timeAgoInMilliseconds.toString()

  parseOptionsText: (text, value)->
    plural = if /^1[a-z]/i.test(text) then '' else 's'
    replacements = {
      'd': " day#{plural} ago",
      'w': " week#{plural} ago",
      'm': " month#{plural} ago",
      'y': " year#{plural} ago",
    }
    text.replace /[a-z]+$/i, (val)->replacements[val]
