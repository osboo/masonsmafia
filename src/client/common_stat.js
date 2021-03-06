$(function() {
  $('[data-toggle=\'tooltip\']').tooltip();
  $.extend($.tablesorter.themes.bootstrap, {
    table: 'table table-bordered table-striped table-responsive',
    header: 'bootstrap-header',
    footerRow: '',
    footerCells: '',
    icons: 'icon-white',
    sortNone: '',
    sortAsc: '',
    sortDesc: '',
    active: '',
    hover: '',
    filterRow: '',
    even: '',
    odd: '',
  });

  $.tablesorter.addWidget({
    id: 'indexFirstColumn',
    format(table) {
      return __range__(0, table.tBodies[0].rows.length, false).map((i) =>
        $(`tbody tr:eq(\"${i}\") td:first`, table).html(i + 1));
    },
  });

  $.tablesorter.addParser({
    id: 'ratingToString',
    format(s, table, cell, cellIndex) {
      return {
      gamesCitizen: parseInt($(cell).attr('games-citizen')),
      gamesSheriff: parseInt($(cell).attr('games-sheriff')),
      gamesMafia: parseInt($(cell).attr('games-mafia')),
      gamesDon: parseInt($(cell).attr('games-don')),
      winsCitizen: parseInt($(cell).attr('wins-citizen')),
      winsSheriff: parseInt($(cell).attr('wins-sheriff')),
      winsMafia: parseInt($(cell).attr('wins-mafia')),
      winsDon: parseInt($(cell).attr('wins-don')),
      bestPlayer: parseInt($(cell).attr('best-player')),
      firstKilledNight: parseInt($(cell).attr('first-killed-at-night')),
      rating: parseFloat($(cell).attr('rating')),
      };
    },
    type: 'text',
  });

  const extended = function(players) {
    const result = [];
    for (let player of Array.from(players)) {
      player['gamesTotal'] = parseInt(player.gamesCitizen) +
                            parseInt(player.gamesSheriff) +
                            parseInt(player.gamesMafia) +
                            parseInt(player.gamesDon);

      player['rating'] = parseFloat(player.rating).toFixed(2);

      player['averageRating'] = (parseFloat(player.rating) /
                                parseFloat(player.gamesTotal)).toFixed(2);

      player['winsTotal'] = parseInt(player.winsCitizen) +
                            parseInt(player.winsSheriff) +
                            parseInt(player.winsMafia) +
                            parseInt(player.winsDon);

      player['bestMoveAccuracy'] = player.bestMoveAccuracy.toFixed(2);
      player['extraScoresPerWin'] = player.extraScoresPerWin.toFixed(2);
      result.push(player);
    }
    return result;
  };

  const renderTables = function(players) {
    $('.common-rating tbody').remove();
    $('.wins tbody').remove();
    $('.roles tbody').remove();
    $('.impact tbody').remove();
    $('<tbody></tbody>').appendTo('.common-rating');
    $('<tbody></tbody>').appendTo('.wins');
    $('<tbody></tbody>').appendTo('.roles');
    $('<tbody></tbody>').appendTo('.impact');
    $('.stat-tables').show();
    players = extended(players);
    return (() => {
      const result = [];
      for (let player of Array.from(players)) {
        const gamesAttrs = `games-citizen=${player.gamesCitizen} games-sheriff=${player.gamesSheriff} games-mafia=${player.gamesMafia} games-don=${player.gamesDon}`;
        const winsAttrs = `wins-citizen=${player.winsCitizen} wins-sheriff=${player.winsSheriff} wins-mafia=${player.winsMafia} wins-don=${player.winsDon}`;
        const impactAttrs = `best-player=${player.bestPlayer} first-killed-at-night=${player.firstKilledNight}`;
        const ratingsAttrs = `rating=${player.rating}`;
        $(`<tr><td></td><td><a class='player-name' href='/personal/${player.name}' target='_blank'>${player.name}</a></td><td ${gamesAttrs} ${winsAttrs} ${impactAttrs} ${ratingsAttrs}>${(playercomparator.average(player) + playercomparator.experience(player)).toFixed(2)}</td><td>${player.gamesTotal}</td><td>${player.winsTotal}</td><td>${player.extraScoresPerWin}</td><td>${player.rating}</td></tr>`).appendTo('.common-rating tbody');
        $(`<tr><td></td><td><a class='player-name' href='/personal/${player.name}' target='_blank'>${player.name}</a></td><td>${player.winsTotal}</td><td>${player.winsCitizen}</td><td>${player.winsSheriff}</td><td>${player.winsMafia}</td><td>${player.winsDon}</td></tr>`).appendTo('.wins tbody');
        $(`<tr><td></td><td><a class='player-name' href='/personal/${player.name}' target='_blank'>${player.name}</a></td><td>${player.gamesTotal}</td><td>${player.gamesCitizen}</td><td>${player.gamesSheriff}</td><td>${player.gamesMafia}</td><td>${player.gamesDon}</td></tr>`).appendTo('.roles tbody');
        result.push($(`<tr><td></td><td><a class='player-name' href='/personal/${player.name}' target='_blank'>${player.name}</a></td><td>${player.likes}</td><td>${player.bestPlayer}</td><td>${player.bestMoveAccuracy}</td><td>${player.firstKilledNight}</td><td>${player.firstKilledDay}</td><td>${player.fouls}</td></tr>`).appendTo('.impact tbody'));
      }
      return result;
    })();
  };

  const updateTables = function(urlString) {
    const request = {
      url: urlString,
      dataType: 'json',
      beforeSend() {
        $('.stat-tables').hide();
        return $('.loader').show();
      },

      complete() {
        $('.loader').hide();
        return $('.stat-tables').show();
      },

      success(data, textStatus) {
        renderTables(data);
        $('.common-rating').tablesorter({
          headers: {
            0: {sorter: false},
            2: {sorter: 'ratingToString'},
          },
          sortList: [
            [2, 1],
          ],
          textSorter: {
            2(a, b, direction, column, table) {
              return playercomparator.compare(a, b);
            },
          },
          theme: 'bootstrap',
          widgets: ['uitheme', 'indexFirstColumn'],
          headerTemplate: '{content} {icon}',
        });
        ['wins', 'roles', 'impact'].forEach((className)=>
          $(`.${className}`).tablesorter({
            headers: {
              0: {sorter: false},
            },
            sortList: [
              [2, 1],
            ],
            theme: 'bootstrap',
            widgets: ['uitheme', 'indexFirstColumn'],
            headerTemplate: '{content} {icon}',
          })
        );
        $('.stat-tables table').trigger('update');
        return $('.stat-tables table').trigger('sorton');
      },
    };
    return $.ajax(request);
  };


  $('.top-10').click(function() {
    const values = {'все игроки': 'топ-10', 'топ-10': 'все игроки'};
    const links = {'все игроки': '/json/common_stat_responce.json', 'топ-10': '/json/top10.json'};
    updateTables(links[$(this).html()]); // eslint-disable-line no-invalid-this
    return $(this).html(values[$(this).html()]); // eslint-disable-line no-invalid-this
  });

  return updateTables('/json/top10.json');
});

function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}
