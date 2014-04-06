computeTotalValues = (data)->
    data["games-total"] = data.gamesCitizen + data.gamesSheriff + data.gamesMafia + data.gamesDon
    data["average-rating"] = (data.rating / data["games-total"]).toFixed(2)
    suffixes = ["Citizen", "Sheriff", "Mafia", "Don"]
    data["wins-total"] = 0
    data["best-total"] = 0
    data["likes-total"] = 0
    data["penalties-total"] = 0
    data["first-Killed-at-night-total"] = 0
    data["first-Killed-at-day-total"] = 0
    for suffix in suffixes
        data["wins-total"] += data["wins#{suffix}"]
        data["best-total"] += data["bestPlayer#{suffix}"]
        data["likes-total"] += data["likes#{suffix}"]
        data["penalties-total"] += data["fouls#{suffix}"]
        data["first-Killed-at-night-total"] += data["firstKilledNight#{suffix}"]
        data["first-Killed-at-day-total"] += data["firstKilledDay#{suffix}"]

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
    $(".recommended-card").html(data["recommended-card"])
    $(".best-move-accuracy").html(data["bestMoveAccuracy"])

window.renderTable = (data) ->
    $(".wins-citizen").html(data.winsCitizen)
    $(".wins-sheriff").html(data.winsSheriff)
    $(".wins-mafia").html(data.winsMafia)
    $(".wins-don").html(data.winsDon)
    $(".wins-total").html(data["wins-total"])

    $(".games-citizen").html(data.gamesCitizen)
    $(".games-sheriff").html(data.gamesSheriff)
    $(".games-mafia").html(data.gamesMafia)
    $(".games-don").html(data.gamesDon)
    $(".games-total").html(data["games-total"])

    $(".best-citizen").html(data.bestPlayerCitizen)
    $(".best-sheriff").html(data.bestPlayerSheriff)
    $(".best-mafia").html(data.bestPlayerMafia)
    $(".best-don").html(data.bestPlayerDon)
    $(".best-total").html(data["best-total"])

    $(".likes-citizen").html(data.likesCitizen)
    $(".likes-sheriff").html(data.likesSheriff)
    $(".likes-mafia").html(data.likesMafia)
    $(".likes-don").html(data.likesDon)
    $(".likes-total").html(data["likes-total"])

    $(".penalties-citizen").html(data.foulsCitizen)
    $(".penalties-sheriff").html(data.foulsSheriff)
    $(".penalties-mafia").html(data.foulsMafia)
    $(".penalties-don").html(data.foulsDon)
    $(".penalties-total").html(data["penalties-total"])

    $(".first-killed-at-night-cititzen").html(data.firstKilledNightCitizen)
    $(".first-Killed-at-night-sheriff").html(data.firstKilledNightSheriff)
    $(".first-killed-at-night-mafia").html(data.firstKilledNightMafia)
    $(".first-Killed-at-night-don").html(data.firstKilledNightDon)
    $(".first-Killed-at-night-total").html(data["first-Killed-at-night-total"])

    $(".first-killed-at-day-cititzen").html(data.firstKilledDayCitizen)
    $(".first-Killed-at-day-sheriff").html(data.firstKilledDaySheriff)
    $(".first-killed-at-day-mafia").html(data.firstKilledDayMafia)
    $(".first-Killed-at-day-don").html(data.firstKilledDayDon)
    $(".first-Killed-at-day-total").html(data["first-Killed-at-day-total"])