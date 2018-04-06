/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const computeTotalValues = function(data){
  data["games-total"] = data.gamesCitizen + data.gamesSheriff + data.gamesMafia + data.gamesDon;
  data["average-rating"] = (data.rating / data["games-total"]).toFixed(2);
  const suffixes = ["Citizen", "Sheriff", "Mafia", "Don"];
  data["wins-total"] = 0;
  data["best-total"] = 0;
  data["likes-total"] = 0;
  data["penalties-total"] = 0;
  data["first-killed-at-night-total"] = 0;
  data["first-killed-at-day-total"] = 0;
  for (let suffix of Array.from(suffixes)) {
    data["wins-total"] += data[`wins${suffix}`];
    data["best-total"] += data[`bestPlayer${suffix}`];
    data["likes-total"] += data[`likes${suffix}`];
    data["penalties-total"] += data[`fouls${suffix}`];
    data["first-killed-at-night-total"] += data[`firstKilledNight${suffix}`];
    data["first-killed-at-day-total"] += data[`firstKilledDay${suffix}`];
  }
  return data["survival-rate"] = ((1.0 - (data["first-killed-at-day-total"] / data["games-total"])) * 100.0).toFixed(2);
};

window.recommendCard = function(data) {
  let role;
  computeTotalValues(data);
  const v = [];
  const rolesSuffixes = [{suffix: "Citizen", role: "Мирный"}, {suffix: "Sheriff", role: "Шериф"}, {suffix: "Mafia", role: "Мафия"}, {suffix: "Don", role: "Дон"}];
  for (let s of Array.from(rolesSuffixes)) {
    const roleSuffix = s.suffix;
    ({ role } = s);
    const winrate = data[`games${roleSuffix}`] ? data[`wins${roleSuffix}`] / data[`games${roleSuffix}`] : 0;
    const bestPlayerRate = data["best-total"] ? data[`bestPlayer${roleSuffix}`] / data["best-total"] : 0;
    const likesRate = data["likes-total"] ? data[`likes${roleSuffix}`] / data["likes-total"] : 0;
    v.push({"average": winrate + (2 * bestPlayerRate) + likesRate, "role": role});
  }

  v.sort(function(a, b) {
    if (a.average < b.average) { return 1; } else { return -1; }
  });
  return v[0].role;
};

window.renderFeatures = function(data) {
  $(".rating").html(data.rating);
  data["recommended-card"] = recommendCard(data);
  $(".games-total").html(data["games-total"]);
  $(".average-rating").html(data["average-rating"]);
  $(".experience-scores").html(playercomparator.experience(data).toFixed(2));
  $(".recommended-card").html(data["recommended-card"]);
  $(".best-move-accuracy").html(data["bestMoveAccuracy"].toFixed(2));
  return $(".survival").html(`${data["survival-rate"]}%`);
};

window.renderTable = function(data) {
  const suffixes = [
    {classSuffix: "citizen", dataSuffix: "Citizen"},
    {classSuffix: "sheriff", dataSuffix: "Sheriff"},
    {classSuffix: "mafia", dataSuffix: "Mafia"},
    {classSuffix: "don", dataSuffix: "Don"}
  ];

  for (let s of Array.from(suffixes)) {
    $(`.wins-${s.classSuffix}`).html(data[`wins${s.dataSuffix}`]);
    $(`.games-${s.classSuffix}`).html(data[`games${s.dataSuffix}`]);
    $(`.best-${s.classSuffix}`).html(data[`bestPlayer${s.dataSuffix}`]);
    $(`.likes-${s.classSuffix}`).html(data[`likes${s.dataSuffix}`]);
    $(`.penalties-${s.classSuffix}`).html(data[`fouls${s.dataSuffix}`]);
    $(`.first-killed-at-night-${s.classSuffix}`).html(data[`firstKilledNight${s.dataSuffix}`]);
    $(`.first-killed-at-day-${s.classSuffix}`).html(data[`firstKilledDay${s.dataSuffix}`]);
  }

  $(".wins-total").html(data["wins-total"]);
  $(".games-total").html(data["games-total"]);
  $(".best-total").html(data["best-total"]);
  $(".likes-total").html(data["likes-total"]);
  $(".penalties-total").html(data["penalties-total"]);
  $(".first-killed-at-night-total").html(data["first-killed-at-night-total"]);
  return $(".first-killed-at-day-total").html(data["first-killed-at-day-total"]);
};

window.renderWinsPlot = function(data) {
  const evenings = [];
  let prev = {gameID: "0", winsMinusLosses: "0", date: "0", gameResult: ""};
  let wins = 0;
  let losses = 0;
  for (let game of Array.from(data.efficiency)) {
    if (game.date !== prev.date) {
      prev.wins = wins;
      prev.losses = losses;
      evenings.push(prev);
      wins = 0;
      losses = 0;
    }
    if (parseInt(game.gameResult) > 0) {
      wins += 1;
    } else {
      losses += 1;
    }
    prev = game;
  }
  prev.wins = wins;
  prev.losses = losses;
  evenings.push(prev);
  evenings.shift();
  for (let evening of Array.from(evenings)) {
    evening.date = parseInt(evening.date, 10);
    evening.winsMinusLosses = parseInt(evening.winsMinusLosses, 10);
  }

  $('#winloss').remove();
  $('#rolesWinrate').remove();
  $('#commandWinrate').remove();
  $('#winrate').remove();
  $('.efficiency-chart .graph-container').append("<div id='winloss'></div>");
  $('.roles-wins-distribution-chart .graph-container').append("<div id='rolesWinrate'></div>");
  $('.commands-wins-distribution-chart .graph-container').append("<div id='commandWinrate'></div>");
  $('.winrate-chart .graph-container').append("<div id='winrate'></div>");

  new Morris.Line({
    element: 'winloss',
    data: evenings,
    xkey: 'date',
    ykeys: ['winsMinusLosses'],
    labels: ['win-loss'],
    hideHover: true,
    hoverCallback(index, options, content, row){
      const message = `\
<div class="morris-hover-row-label">${moment(new Date(evenings[index].date)).format('D MMMM, YYYY')}</div>
<div class="morris-hover-point">win-loss: ${evenings[index].winsMinusLosses}</div>
<div class="morris-hover-point-green">Побед: ${evenings[index].wins}</div>
<div class="morris-hover-point-red">Поражений: ${evenings[index].losses}</div>\
`;
      return message;
    }
  });

  const rolesWinrateData = [
    {role: 'Мирный', winrate: data.gamesCitizen ? Math.floor((data.winsCitizen / data.gamesCitizen) * 100) : 0},
    {role: 'Шериф', winrate: data.gamesSheriff ? Math.floor((data.winsSheriff / data.gamesSheriff) * 100) : 0},
    {role: 'Мафия', winrate: data.gamesMafia ? Math.floor((data.winsMafia / data.gamesMafia) * 100) : 0},
    {role: 'Дон', winrate: data.gamesDon ? Math.floor((data.winsDon / data.gamesDon) * 100) : 0}
  ];

  new Morris.Bar({
    element: 'rolesWinrate',
    data: rolesWinrateData,
    xkey: 'role',
    ykeys: ['winrate'],
    labels: ['процент побед'],
    hideHover:'auto'
  });

  let redWinrate = (data.gamesCitizen + data.gamesSheriff) ? (data.winsCitizen + data.winsSheriff) / (data.gamesCitizen + data.gamesSheriff) : 0;
  let blackWinrate = (data.gamesMafia + data.gamesDon) ? (data.winsMafia + data.winsDon) / (data.gamesMafia + data.gamesDon) : 0;
  redWinrate = (redWinrate + blackWinrate) ? Math.floor((100 * redWinrate) / (redWinrate + blackWinrate)) : 0;
  blackWinrate = 100 - redWinrate;

  new Morris.Donut({
    element: 'commandWinrate',
    data: [
      {label: "Преобладание красной линии", value: redWinrate},
      {label: "Преобладание чёрной линии", value: blackWinrate}
    ],
    colors: ["#AE0814", "#080808"]
  });

  const winrate = data["games-total"] ? Math.floor((data["wins-total"] / data["games-total"]) * 100) : 0;
  const lossrate = 100 - winrate;
  return new Morris.Donut({
    element: 'winrate',
    data: evenings,
    data: [
      {label: "Победы", value: winrate},
      {label: "Поражения", value: lossrate}
    ]
  }).select(0);
};
