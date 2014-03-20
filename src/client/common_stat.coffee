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
    $('.stat-tables table').tablesorter({
        sortList : [[1, 1]],
        theme: "bootstrap",
        widgets: ['uitheme'],
        headerTemplate : '{content} {icon}'
    })
    $('.top-10').click(->
        if $('.top-10').html() == "топ-10" then $('.top-10').html("все")
        else if $('.top-10').html() == "все" then $('.top-10').html("топ-10")
    )
)