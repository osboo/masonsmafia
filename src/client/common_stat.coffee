$(->
    $.extend($.tablesorter.themes.bootstrap, {
        table: 'table table-bordered table-striped table-responsive',
        header: 'bootstrap-header',
        footerRow: '',
        footerCells: '',
        icons: 'icon-white',
        sortNone   : '',
        sortAsc    : 'glyphicon glyphicon-chevron-up',
        sortDesc   : 'glyphicon glyphicon-chevron-down',
        active: '',
        hover: '',
        filterRow: '',
        even: '',
        odd: ''
    });

    $.tablesorter.addWidget({
            id: 'indexFirstColumn'
            format: (table) ->
                for i in [0...table.tBodies[0].rows.length]
                    $("tbody tr:eq(\"#{i}\") td:first", table).html(i + 1);
        }
    )

    extended = (players)->
        result = []
        for player in players
            player['gamesTotal'] = parseInt(player.gamesCitizen) + parseInt(player.gamesSheriff) + parseInt(player.gamesMafia) + parseInt(player.gamesDon)
            player['rating'] = parseFloat(player.rating).toFixed(2)
            player['averageRating'] = (parseFloat(player.rating) / parseFloat(player.gamesTotal)).toFixed(2)
            player['winsTotal'] = parseInt(player.winsCitizen) + parseInt(player.winsSheriff) + parseInt(player.winsMafia) + parseInt(player.winsDon)
            player['bestMoveAccuracy'] = player.bestMoveAccuracy.toFixed(2)
            result.push(player)
        result

    renderTables = (players)->
        $('.common-rating tbody').remove()
        $('.wins tbody').remove()
        $('.roles tbody').remove()
        $('.impact tbody').remove()
        $('<tbody></tbody>').appendTo('.common-rating')
        $('<tbody></tbody>').appendTo('.wins')
        $('<tbody></tbody>').appendTo('.roles')
        $('<tbody></tbody>').appendTo('.impact')
        $('.stat-tables').show()
        players = extended(players)
        for player in players
            $("<tr><td></td><td>#{player.name}</td><td>#{player.averageRating}</td><td>#{player.gamesTotal}</td><td>#{player.winsTotal}</td><td>#{player.rating}</td></tr>").appendTo('.common-rating tbody')
            $("<tr><td></td><td>#{player.name}</td><td>#{player.winsTotal}</td><td>#{player.winsCitizen}</td><td>#{player.winsSheriff}</td><td>#{player.winsMafia}</td><td>#{player.winsDon}</td></tr>").appendTo('.wins tbody')
            $("<tr><td></td><td>#{player.name}</td><td>#{player.gamesTotal}</td><td>#{player.gamesCitizen}</td><td>#{player.gamesSheriff}</td><td>#{player.gamesMafia}</td><td>#{player.gamesDon}</td></tr>").appendTo('.roles tbody')
            $("<tr><td></td><td>#{player.name}</td><td>#{player.likes}</td><td>#{player.bestPlayer}</td><td>#{player.bestMoveAccuracy}</td><td>#{player.firstKilledNight}</td><td>#{player.firstKilledDay}</td><td>#{player.fouls}</td></tr>").appendTo('.impact tbody')

    $.ajax({
            url:'/common-statistics'
            dataType:'json'
            success: (data, textStatus)->
                renderTables(data)
                $('.stat-tables table').tablesorter({
                    headers: { 0: { sorter: false} }
                    sortList : [[2, 1]],
                    theme: "bootstrap",
                    widgets: ['uitheme', 'indexFirstColumn'],
                    headerTemplate : '{content} {icon}'
                })
        }
    )



    $('.top-10').click(->

    )
)