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
    )

    window.getCachedUserNames()

    $("input[name='player-name']").autocomplete(
        lookup: window.getCachedUserNames()
        minChars: 2,
        onSelect: (value, data) ->
            console.log(value)
    )

    $("input[name='player-name']").keydown(
        (event) ->
            if event.keyCode is 13
                event.preventDefault()
                return false
    )
)


