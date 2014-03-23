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

    $('.stat-tables table').tablesorter({
        headers: { 0: { sorter: false} }
        sortList : [[2, 1]],
        theme: "bootstrap",
        widgets: ['uitheme', 'indexFirstColumn'],
        headerTemplate : '{content} {icon}'
    })

    $('.top-10').click(->

    )
)