evenings = {}
loadGames = (start, end, playerName) ->
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
    evenings[playerName] = playerGamesAtEvenings
    return evenings

getUserOnPage = () ->
    ["foo", "bar"]

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
        $('.js-daterange').html(start.format('D MMMM, YYYY') + ' - ' + end.format('D MMMM, YYYY'))
        $('#efficiency').hide()

        usersOnPage = getUserOnPage()
        temp = {}
        for user in usersOnPage
            loadGames(start, end, user)
            playerEvenings = evenings[user]

            for dateTimestamp, evening of playerEvenings
                eveningTotalRating = (game.rating for game in evening).reduce (x, y) -> x + y
                maxPossibleRatingPerGame = (game.maxPossibleRating for game in evening).reduce (x, y) -> x + y
                efficiency = eveningTotalRating * 100 / maxPossibleRatingPerGame
                if (temp[dateTimestamp])
                    temp[dateTimestamp][user] = efficiency.toFixed(1)
                else
                    record = {}
                    record[user] = efficiency.toFixed(1)
                    temp[dateTimestamp] = record

        yLabels = [];
        for user in usersOnPage
            yLabels.push("efficiency-#{user}")

        plotData = []
        for dateTimestamp, efficiencyRecords of temp
            points = {'date': parseInt(dateTimestamp, 10)}
            for user in usersOnPage
                points["efficiency-#{user}"] = if efficiencyRecords[user]? then efficiencyRecords[user] else null
            plotData.push(points)

        $('#efficiency').remove()
        $('<div id = "efficiency"><div/>').appendTo('.efficiency-chart')

        new Morris.Line({
            element: 'efficiency',
            data: plotData,
            xkey: 'date',
            ykeys: yLabels,
            labels: usersOnPage,
            postUnits: '%',
            dateFormat: (milliseconds) ->
                moment(new Date(milliseconds)).format('D MMMM, YYYY')
            hoverCallback: (index, options, content) ->
                atDate = options.data[index].date
                for user in getUserOnPage()
                    eveningOfUser = evenings[user]
                    evening = eveningOfUser[atDate]
                    results = ""
                    if evening?
                        efficiency = options.data[index]["efficiency-#{user}"]
                        results += "#{user}: #{efficiency}%<br>"
                        translatedRole = {'citizen': 'мирный', 'sheriff': 'шериф', 'mafia': 'мафия', 'don': 'дон'}
                        for game in evening
                            results += "<b>#{translatedRole[game.role]}:</b>#{game.rating}/#{game.maxPossibleRating}<br>"
                    results
        })

    )
)


