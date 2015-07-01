computeTotalValues = (data)->
  data["games-total"] = data.gamesCitizen + data.gamesSheriff + data.gamesMafia + data.gamesDon
  data["average-rating"] = (data.rating / data["games-total"]).toFixed(2)
  suffixes = ["Citizen", "Sheriff", "Mafia", "Don"]
  data["wins-total"] = 0
  data["best-total"] = 0
  data["likes-total"] = 0
  data["penalties-total"] = 0
  data["first-killed-at-night-total"] = 0
  data["first-killed-at-day-total"] = 0
  for suffix in suffixes
    data["wins-total"] += data["wins#{suffix}"]
    data["best-total"] += data["bestPlayer#{suffix}"]
    data["likes-total"] += data["likes#{suffix}"]
    data["penalties-total"] += data["fouls#{suffix}"]
    data["first-killed-at-night-total"] += data["firstKilledNight#{suffix}"]
    data["first-killed-at-day-total"] += data["firstKilledDay#{suffix}"]
  data["survival-rate"] = ((1.0 - data["first-killed-at-day-total"] / data["games-total"]) * 100.0).toFixed(2)

window.recommendCard = (data) ->
  computeTotalValues(data)
  v = []
  rolesSuffixes = [{suffix: "Citizen", role: "Мирный"}, {suffix: "Sheriff", role: "Шериф"}, {suffix: "Mafia", role: "Мафия"}, {suffix: "Don", role: "Дон"}]
  for s in rolesSuffixes
    roleSuffix = s.suffix
    role = s.role
    winrate = if data["games#{roleSuffix}"] then data["wins#{roleSuffix}"] / data["games#{roleSuffix}"] else 0
    bestPlayerRate = if data["best-total"] then data["bestPlayer#{roleSuffix}"] / data["best-total"] else 0
    likesRate = if data["likes-total"] then data["likes#{roleSuffix}"] / data["likes-total"] else 0
    v.push({"average": winrate + 2 * bestPlayerRate + likesRate, "role": role})

  v.sort((a, b) ->
    if a.average < b.average then 1 else -1
  )
  return v[0].role

window.renderFeatures = (data) ->
  $(".rating").html(data.rating)
  data["recommended-card"] = recommendCard(data)
  $(".games-total").html(data["games-total"])
  $(".average-rating").html(data["average-rating"])
  $(".experience-scores").html(playercomparator.experience(data).toFixed(2))
  $(".recommended-card").html(data["recommended-card"])
  $(".best-move-accuracy").html(data["bestMoveAccuracy"].toFixed(2))
  $(".survival").html("#{data["survival-rate"]}%")

window.renderTable = (data) ->
  suffixes = [
    {classSuffix: "citizen", dataSuffix: "Citizen"},
    {classSuffix: "sheriff", dataSuffix: "Sheriff"},
    {classSuffix: "mafia", dataSuffix: "Mafia"},
    {classSuffix: "don", dataSuffix: "Don"}
  ]

  for s in suffixes
    $(".wins-#{s.classSuffix}").html(data["wins#{s.dataSuffix}"])
    $(".games-#{s.classSuffix}").html(data["games#{s.dataSuffix}"])
    $(".best-#{s.classSuffix}").html(data["bestPlayer#{s.dataSuffix}"])
    $(".likes-#{s.classSuffix}").html(data["likes#{s.dataSuffix}"])
    $(".penalties-#{s.classSuffix}").html(data["fouls#{s.dataSuffix}"])
    $(".first-killed-at-night-#{s.classSuffix}").html(data["firstKilledNight#{s.dataSuffix}"])
    $(".first-killed-at-day-#{s.classSuffix}").html(data["firstKilledDay#{s.dataSuffix}"])

  $(".wins-total").html(data["wins-total"])
  $(".games-total").html(data["games-total"])
  $(".best-total").html(data["best-total"])
  $(".likes-total").html(data["likes-total"])
  $(".penalties-total").html(data["penalties-total"])
  $(".first-killed-at-night-total").html(data["first-killed-at-night-total"])
  $(".first-killed-at-day-total").html(data["first-killed-at-day-total"])

window.renderWinsPlot = (data) ->
  evenings = []
  prev = {gameID: "0", winsMinusLosses: "0", date: "0", gameResult: ""}
  wins = 0
  losses = 0
  for game in data.efficiency
    if game.date != prev.date
      prev.wins = wins
      prev.losses = losses
      evenings.push(prev)
      wins = 0
      losses = 0
    if parseInt(game.gameResult) > 0
      wins += 1
    else
      losses += 1
    prev = game
  prev.wins = wins
  prev.losses = losses
  evenings.push(prev)
  evenings.shift()
  for evening in evenings
    evening.date = parseInt(evening.date, 10)
    evening.winsMinusLosses = parseInt(evening.winsMinusLosses, 10)

  $('#winloss').remove()
  $('#rolesWinrate').remove()
  $('#commandWinrate').remove()
  $('#winrate').remove()
  $('.efficiency-chart .graph-container').append("<div id='winloss'></div>")
  $('.roles-wins-distribution-chart .graph-container').append("<div id='rolesWinrate'></div>")
  $('.commands-wins-distribution-chart .graph-container').append("<div id='commandWinrate'></div>")
  $('.winrate-chart .graph-container').append("<div id='winrate'></div>")

  new Morris.Line({
    element: 'winloss',
    data: evenings,
    xkey: 'date',
    ykeys: ['winsMinusLosses'],
    labels: ['win-loss'],
    hideHover: true
    hoverCallback: (index, options, content, row)->
      message = """
      <div class="morris-hover-row-label">#{moment(new Date(evenings[index].date)).format('D MMMM, YYYY')}</div>
      <div class="morris-hover-point">win-loss: #{evenings[index].winsMinusLosses}</div>
      <div class="morris-hover-point-green">Побед: #{evenings[index].wins}</div>
      <div class="morris-hover-point-red">Поражений: #{evenings[index].losses}</div>
      """
      return message
  })

  rolesWinrateData = [
    {role: 'Мирный', winrate: if data.gamesCitizen then Math.floor(data.winsCitizen / data.gamesCitizen * 100) else 0}
    {role: 'Шериф', winrate: if data.gamesSheriff then Math.floor(data.winsSheriff / data.gamesSheriff * 100) else 0}
    {role: 'Мафия', winrate: if data.gamesMafia then Math.floor(data.winsMafia / data.gamesMafia * 100) else 0}
    {role: 'Дон', winrate: if data.gamesDon then Math.floor(data.winsDon / data.gamesDon * 100) else 0}
  ]

  new Morris.Bar({
    element: 'rolesWinrate',
    data: rolesWinrateData,
    xkey: 'role',
    ykeys: ['winrate'],
    labels: ['процент побед'],
    hideHover:'auto'
  })

  redWinrate = if data["wins-total"] then Math.floor((data.winsCitizen + data.winsSheriff) * 100 / data["wins-total"]) else 0
  blackWinrate = 100 - redWinrate

  new Morris.Donut({
    element: 'commandWinrate',
    data: [
      {label: "Доля красных побед", value: redWinrate},
      {label: "Доля чёрных побед", value: blackWinrate}
    ]
  })

  winrate = if data["games-total"] then Math.floor(data["wins-total"] / data["games-total"] * 100) else 0
  lossrate = 100 - winrate
  new Morris.Donut({
    element: 'winrate',
    data: evenings,
    data: [
      {label: "Победы", value: winrate},
      {label: "Поражения", value: lossrate}
    ]
  }).select(0)
