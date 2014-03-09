evenings = {}
loadGames = (start, end, playerName) ->
    games = [
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
            'date': new Date('2011-10-10').getTime(),
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
            'date': new Date('2011-10-10').getTime(),
            'role': 'mafia',
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
    ]
    games

updateEvenings = (games) ->
    evenings = {};
    for game in games
        gameResults = {'rating': game.rating, 'role': game.role, 'maxPossibleRating': game.maxPossibleRating}
        if (evenings[game.date])
            evenings[game.date].push(gameResults)
        else
            evenings[game.date] = [gameResults]
    evenings

$(->
    $('.js-daterange').daterangepicker({
            ranges: {
                'За 7 дней': [moment().subtract('days', 6), moment()],
                'За 30 дней': [moment().subtract('days', 29), moment()],
                'С начала месяца': [moment().startOf('month'), moment()],
            },
            startDate: moment().subtract('days', 1),
            endDate: moment()
        },
    (start, end) ->
        $('.js-daterange').html(start.format('D MMMM, YYYY') + ' - ' + end.format('D MMMM, YYYY'));
        games = loadGames(start, end, 'some vk id')
        evenings = updateEvenings(games)

        efficiencyData = []
        for milliseconds, evening of evenings
            milliseconds = parseInt(milliseconds, 10)
            eveningTotalRating = (gameResults.rating for gameResults in evening).reduce (x, y) -> x + y
            maxPossibleRatingPerGame = (gameResults.maxPossibleRating for gameResults in evening).reduce (x, y) -> x + y
            efficiency = eveningTotalRating * 100 / maxPossibleRatingPerGame
            efficiencyData.push({'date': milliseconds, 'efficiency': efficiency.toFixed(1)})
        graph.setData(efficiencyData)
    )

    graph = Morris.Line({
        element: 'efficiency',
        data: [],
        xkey: 'date',
        ykeys: ['efficiency'],
        labels: ['Результативность'],
        postUnits: '%'
        dateFormat: (milliseconds) ->
            moment(new Date(milliseconds)).format('D MMMM, YYYY')
        hoverCallback: (index, options, content) ->
            milliseconds = options.data[index].date
            evening = evenings[milliseconds]
            translatedRole = {}
            translatedRole['citizen'] = 'Мирный'
            translatedRole['sheriff'] = 'Шериф'
            translatedRole['mafia'] = 'Мафия'
            translatedRole['don'] = 'Дон'
            stats = ""
            for gameResults in evening
                stats += "<b>" + translatedRole[gameResults.role] + "</b>: " + gameResults.rating + "/" + gameResults.maxPossibleRating  + "<br>"
            content += stats
    })
)


