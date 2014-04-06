recommendCard = (data) ->
    v = []
    if data.gamesMafia
        v.push( {"average": data.winsMafia / data.gamesMafia, "role": "Мафия"})
    if data.gamesDon
        v.push( {"average": data.winsDon / data.gamesDon, "role": "Дон"})
    if data.gamesSheriff
        v.push( {"average": data.winsSheriff / data.gamesSheriff, "role": "Шериф"})
    if data.gamesCitizen
        v.push( {"average": data.winsCitizen / data.gamesCitizen, "role": "Мирный"})
    v.sort((a, b) ->
        if a.average < b.average then 1 else -1
    )
    return v[0].role

renderFeatures = (data) ->
    $(".rating").html(data.rating)
    data["games-total"] = data.gamesCitizen + data.gamesSheriff + data.gamesMafia + data.gamesDon
    data["average-rating"] = (data.rating / data["games-total"]).toFixed(2)
    data["recommended-card"] = recommendCard(data)
    $(".games-total").html(data["games-total"])
    $(".average-rating").html(data["average-rating"])
    $(".recommended-card").html(data["recommended-card"])
    $(".best-move-accuracy").html(data["bestMoveAccuracy"])