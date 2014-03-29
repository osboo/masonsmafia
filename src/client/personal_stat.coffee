$(->
    getUsersOnPage = ()->
        return ['foo', 'bar']

    fetchedNames = new Bloodhound({
        datumTokenizer: (item) -> Bloodhound.tokenizers.whitespace(item.name)
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        limit: 10,
        prefetch: {
            url: '/players',
            filter: (list) ->
                $.map(list, (record) -> {name: record})
        }
    })

    fetchedNames.initialize()

    $("input[name='player-name']").typeahead(null, {
            displayKey: 'name',
            source: fetchedNames.ttAdapter()
        }
    )

    $(".twitter-typeahead").css('display', 'block')

    $("input[name='player-name']").keydown(
        (event) ->
            if event.keyCode is 13
                event.preventDefault()
                return false
    )

    $("input[name='find-button']").bind('click', (event, ui) ->
        event.preventDefault()
        $('#efficiency').remove()
        $(".loader").show()

        $('<div id = "efficiency"><div/>').appendTo('.efficiency-chart')

        efficiencies = {}
        user = $("input[name='player-name']").val()
        window.loadGames(null, null, user)
        playerEvenings = window.evenings[user]

        for dateTimestamp, evening of playerEvenings
            eveningTotalRating = (game.rating for game in evening).reduce (x, y) -> x + y
            maxPossibleRatingPerGame = (game.maxPossibleRating for game in evening).reduce (x, y) -> x + y
            efficiency = eveningTotalRating * 100 / maxPossibleRatingPerGame
            if (efficiencies[dateTimestamp])
                efficiencies[dateTimestamp][user] = efficiency.toFixed(1)
            else
                record = {}
                record[user] = efficiency.toFixed(1)
                efficiencies[dateTimestamp] = record

        yLabels = [];
        for user in usersOnPage
            yLabels.push("efficiency-#{user}")

        plotData = []
        for dateTimestamp, efficiencyRecords of efficiencies
            points = {'date': parseInt(dateTimestamp, 10)}
            points["efficiency-#{user}"] = if efficiencyRecords[user]? then efficiencyRecords[user] else null
            plotData.push(points)

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
                resultsForPlot = ""
                detailedInfo = moment(atDate).format("D MMMM, YYYY") + "<br>"
                for user in getUsersOnPage()
                    $("#evenings-#{user}").html("")
                    eveningOfUser = window.evenings[user]
                    evening = eveningOfUser[atDate]
                    if evening?
                        efficiency = options.data[index]["efficiency-#{user}"]
                        efficiencyStr = "<b>#{user}</b>: #{efficiency}%<br>"
                        resultsForPlot += efficiencyStr
                        translatedRole = {'citizen': 'мирный', 'sheriff': 'шериф', 'mafia': 'мафия', 'don': 'дон'}
                        for game in evening
                            winrateStr = "#{translatedRole[game.role]}:#{game.rating}/#{game.maxPossibleRating}<br>"
                            resultsForPlot += winrateStr
                resultsForPlot
        })
        $(".loader").hide()
        $(".statistics").css('visibility', 'visible')
        users = ({id:0, name:user} for user in window.getCachedUserNames())
        console.log(users)
        $('#users-on-page').tokenInput(users, {theme:'facebook'})
    )

)


