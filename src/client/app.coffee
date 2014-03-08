loadGames = (start, end, playerName) ->
    games = [
        {
            'date': new Date('2011-10-10').getTime(),
            'role': 'citizen',
            'rating': 3,
            'maxPossibleRating': 4,
            'win': 1,
            'isBestPlayer': 0,
            'hasBestMove': 0,
            'likes': 2,
            'fauls': 3,
            'isKilledNight': 0,
            'isKilledDay': 0
        }
    ]
    games

evenings = {}
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
                'За месяц': [moment().startOf('month'), moment().endOf('month')],
            },
            startDate: moment().subtract('days', 1),
            endDate: moment()
        },
    (start, end) ->
        $('.js-daterange').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
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
            d = new Date(milliseconds)
            d.getDate() + '-' + d.getMonth() + '-' + d.getFullYear()
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


