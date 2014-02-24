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
    )
)