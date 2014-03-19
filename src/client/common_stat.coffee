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
    $('.common-rating').tablesorter({
        sortList : [[1, 1]],
        theme: "bootstrap",
        widgets: ['uitheme'],
        headerTemplate : '{content} {icon}'
    })
    $('.wins-table').tablesorter({
        sortList : [[1, 1]],
        theme: "bootstrap",
        widgets: ['uitheme'],
        headerTemplate : '{content} {icon}'
    })
)