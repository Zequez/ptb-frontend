class PTB.Services.I18n
  # We put the translations here because I haven't decided where to put them
  # ideally, somewhere that I can access them everywhere. But is not crucial for now.
  locales: 
    en:
      flags:
        win: 'Windows'
        mac: 'Mac OSX'
        linux: 'Linux'
        singlePlayer: 'Single Player'
        multiPlayer: 'Multiplayer'
        coOp: 'Co-op'
        achievements: 'Achievements'
        cloud: 'Steam cloud'
        cards: 'Steam cards'
        controller: 'Controller support'
        partialController: 'Partial controller support'
        stats: 'Stats'
        workshop: 'Steam Workshop'
        captions: 'Closed Captions'
        commentary: 'Commentaries'
        levelEditor: 'Level editor'
        vac: 'Valve Anti-Cheat'
        vr: 'Virtual Reality support'
        leaderboards: 'Steam leaderboards'

  locale: 'en'

  constructor: ->
    @data = @locales[@locale]

  t: (args...)->
    chain = []
    for arg in args
      for item in arg.split('.')
        chain.push item

    data = @data
    for item in chain
      data = data[item]

    data