$(function() {
    const fetchedNames = new Bloodhound({
        datumTokenizer: function(item) {
            return Bloodhound.tokenizers.whitespace(item.name);
        },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        limit: 10,
        prefetch: {
            url: '/json/players.json',
            filter(list) {
                return $.map(list, (record) => ({name: record}));
            },
        },
    });

    fetchedNames.initialize();

    $('input[name=\'player-name\']').typeahead(null, {
        displayKey: 'name',
        source: fetchedNames.ttAdapter(),
    });

    $('.twitter-typeahead').css('display', 'block');

    const loadData = function(playerName) {
        const request = {
            url: `/personal_stat/?name=${encodeURIComponent(playerName)}`,
            dataType: 'json',
            beforeSend() {
                $('.statistics').hide();
                $('.loader').show();
            },

            success(data) {
                $('.player-name').removeClass('has-error');
                $('input[name=\'player-name\']').tooltip('destroy');
                $('span.player-name').html(playerName);
                window.renderFeatures(data);
                window.renderTable(data);
                $('.statistics').show();
                window.renderWinsPlot(data);
            },

            error(jqXHR, textStatus) {
                if (textStatus === 'error') {
                    $('.player-name').addClass('has-error');
                    $('input[name=\'player-name\']')
                    .tooltip({
                            placement: 'auto',
                            title: 'Игрок не найден',
                            trigger: 'focus',
                        }
                    )
                    .tooltip('show');
                }
            },
            complete() {
                $('.loader').hide();
            },

        };
        return $.ajax(request);
    };

    $('input[name=\'find-button\']').bind('click', function(event, ui) {
        event.preventDefault();
        const playerName = $('input[name=\'player-name\']').val();
        return loadData(playerName);
    });

    $('strong[data-toggle=\'tooltip\']').tooltip();

    if ($('span.player-name').html()) {
        return loadData($('span.player-name').html());
    }
});


