window.getCachedUserNames = () ->
    result = ['foo', 'bar']
    return result

window.evenings = {}
window.loadGames = (start, end, playerName) ->
    if playerName is 'foo' then games = [
        {
            'date': new Date('2011-10-10').getTime(),
            'role': 'citizen',
            'rating': 3,
            'maxPossibleRating': 4,
            'win': 1,
            'isBestPlayer': 0,
            'bestMove': -1,
            'likes': 2,
            'fauls': 3,
            'isKilledFirstNight': 0,
            'isKilledDay': 0
        }
        {
            'date': new Date('2011-10-11').getTime(),
            'role': 'citizen',
            'rating': 0,
            'maxPossibleRating': 4,
            'win': 0,
            'isBestPlayer': 1,
            'bestMove': -1,
            'likes': 3,
            'fauls': 1,
            'isKilledFirstNight': 0,
            'isKilledDay': 0
        }
        {
            'date': new Date('2011-10-12').getTime(),
            'role': 'mafia',
            'rating': 2,
            'maxPossibleRating': 4,
            'win': 0,
            'isBestPlayer': 1,
            'bestMove': -1,
            'likes': 3,
            'fauls': 1,
            'isKilledFirstNight': 0,
            'isKilledDay': 0
        }
    ]
    if playerName is 'bar' then games = [
        {
            'date': new Date('2011-10-10').getTime(),
            'role': 'citizen',
            'rating': 1,
            'maxPossibleRating': 4,
            'win': 1,
            'isBestPlayer': 1,
            'bestMove': -1,
            'likes': 2,
            'fauls': 3,
            'isKilledFirstNight': 0,
            'isKilledDay': 0
        }
        {
            'date': new Date('2011-10-14').getTime(),
            'role': 'citizen',
            'rating': 3,
            'maxPossibleRating': 4,
            'win': 1,
            'isBestPlayer': 0,
            'bestMove': -1,
            'likes': 2,
            'fauls': 3,
            'isKilledFirstNight': 0,
            'isKilledDay': 0
        }
    ]
    playerGamesAtEvenings = {}
    games.sort (a, b) ->
        return if a.date >= b.date then 1 else -1
    for game in games
        date = game.date
        delete game.date
        if (playerGamesAtEvenings[date])
            playerGamesAtEvenings[date].push(game)
        else
            playerGamesAtEvenings[date] = [game]
    window.evenings[playerName] = playerGamesAtEvenings
    return window.evenings



