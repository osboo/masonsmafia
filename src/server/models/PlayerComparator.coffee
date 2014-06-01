compare = (a, b)->
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon
  winsA = a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon
  winsB = b.winsCitizen + b.winsSheriff + b.winsMafia + b.winsDon
  if gamesA != gamesB
    if gamesA > 5 && gamesB > 5 || gamesA < 5 && gamesB < 5
      averageA = if gamesA > 0 then a.rating / gamesA else 0
      averageB = if gamesB > 0 then b.rating / gamesB else 0
      return if averageA > averageB then -1 else 1
    else
      return if gamesA > gamesB then -1 else 1
  else
    if a.rating > b.rating
      return -1
    if a.rating < b.rating
      return 1

    if winsA > winsB
      return -1
    if winsA < winsB
      return 1

    if a.bestPlayer > b.bestPlayer
      return -1
    if a.bestPlayer < b.bestPlayer
      return 1

    if a.winsMafia > b.winsMafia
      return -1
    if a.winsMafia < b.winsMafia
      return 1

    if a.winsDon > b.winsDon
      return -1
    if a.winsDon < b.winsDon
      return 1

    if a.winsSheriff > b.winsSheriff
      return -1
    if a.winsSheriff < b.winsSheriff
      return 1

    if a.firstKilledNight > b.firstKilledNight
      return -1
    if a.firstKilledNight < b.firstKilledNight
      return 1

if typeof(module) != 'undefined' && typeof(module) != 'undefined'
  module.exports = compare
else
  this["module"] = {exports: compare}
