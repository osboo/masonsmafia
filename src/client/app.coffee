$(->
    $('.js-daterange').daterangepicker({
            ranges: {
                'За 7 дней': [moment().subtract('days', 6), moment()],
                'За 30 дней': [moment().subtract('days', 29), moment()],
                'За месяц': [moment().startOf('month'), moment().endOf('month')],
            },
            startDate: moment().subtract('days', 29),
            endDate: moment()
        },
    (start, end) ->
        $('.js-daterange').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
#        retrive games data for all controls
        maximumPossibleRating = 5
        games = [
            { 'date': '2012-01-03', 'rating': 3 },
            { 'date': '2012-01-03', 'rating': 0 },
            { 'date': '2012-01-07', 'rating': 0 },
            { 'date': '2012-01-07', 'rating': 5 },
            { 'date': '2012-01-07', 'rating': 3 }
        ]
        gamesByDate = {}
        numberOfGamesInOneDate = {}
        for game in games
            if numberOfGamesInOneDate[game.date]
                ++numberOfGamesInOneDate[game.date]
                gamesByDate[game.date] += game.rating
            else
                numberOfGamesInOneDate[game.date] = 1
                gamesByDate[game.date] = game.rating
        efficiencyData = []
        efficiencyData2 = [
            { 'date': '2012-01-03', 'efficiency': 3 },
            { 'date': '2012-01-03', 'efficiency': 0 },
            { 'date': '2012-01-07', 'efficiency': 0 },
            { 'date': '2012-01-07', 'efficiency': 5 },
            { 'date': '2012-01-07', 'efficiency': 3 }
        ]
        for inDate, totalRating of gamesByDate
            efficiencyData.push({'date': inDate, 'efficiency': totalRating * 100 / numberOfGamesInOneDate[inDate] / maximumPossibleRating})
        graph.setData(efficiencyData)
        console.log(efficiencyData)
    )

    graph = Morris.Line({
        element: 'efficiency',
        data: [],
        xkey: 'date',
        ykeys: ['efficiency'],
        labels: ['От максимального за вечер']
    });
)


