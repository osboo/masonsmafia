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
#        retrive games data for all controls
        games = [
            { 'date': new Date('2011-10-10').getTime(), 'rating': 3, 'role': 'citizen', 'maxPossibleRating': 4 },
            { 'date': new Date('2011-10-10').getTime(), 'rating': 0, 'role': 'sheriff', 'maxPossibleRating': 5 },
            { 'date': new Date('2011-10-10').getTime(), 'rating': 4, 'role': 'citizen', 'maxPossibleRating': 4 },
            { 'date': new Date('2011-10-15').getTime(), 'rating': 0.5, 'role': 'mafia', 'maxPossibleRating': 4 },
            { 'date': new Date('2011-10-15').getTime(), 'rating': 3, 'role': 'citizen', 'maxPossibleRating': 4 },
            { 'date': new Date('2011-10-22').getTime(), 'rating': 4, 'role': 'don', 'maxPossibleRating': 5 },
            { 'date': new Date('2011-10-22').getTime(), 'rating': 3, 'role': 'citizen', 'maxPossibleRating': 4 },
        ]

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
        labels: ['Винрейт'],
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


