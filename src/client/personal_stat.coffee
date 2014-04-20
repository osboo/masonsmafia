$(->
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

    $("input[name='find-button']").bind('click', (event, ui) ->
        event.preventDefault()
        playerName = $("input[name='player-name']").val()
        request = {
            url: "/personal/#{playerName}"
            dataType: 'json'
            beforeSend: ()->
                $('.statistics').hide()
                $('.loader').show()

            success: (data) ->
                $(".player-name").removeClass("has-error")
                $("input[name='player-name']").tooltip('destroy')
                window.renderFeatures(data)
                window.renderTable(data)
                $('.statistics').show()
                window.renderWinsPlot(data)

            error: (jqXHR, textStatus) ->
                if textStatus == "error"
                    $(".player-name").addClass("has-error")
                    $("input[name='player-name']")
                    .tooltip({
                            placement: "auto",
                            title: "Игрок не найден",
                            trigger: "focus"
                        }
                    )
                    .tooltip('show')
            complete: ()->
                $('.loader').hide()

        }
        $.ajax(request)
    )

)

