compare = (a, b)->
  aIsGreater = 1
  bIsGreater = -1
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon
  winsA = a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon
  winsB = b.winsCitizen + b.winsSheriff + b.winsMafia + b.winsDon
  if gamesA != gamesB
    if gamesA > 5 && gamesB > 5 || gamesA < 5 && gamesB < 5
      averageA = if gamesA > 0 then a.rating / gamesA else 0
      averageB = if gamesB > 0 then b.rating / gamesB else 0
      return if averageA > averageB then aIsGreater else bIsGreater
    else
      return if gamesA > gamesB then aIsGreater else bIsGreater
  else
    if a.rating > b.rating
      return aIsGreater
    if a.rating < b.rating
      return bIsGreater

    if winsA > winsB
      return aIsGreater
    if winsA < winsB
      return bIsGreater

    if a.bestPlayer > b.bestPlayer
      return aIsGreater
    if a.bestPlayer < b.bestPlayer
      return bIsGreater

    if a.winsMafia > b.winsMafia
      return aIsGreater
    if a.winsMafia < b.winsMafia
      return bIsGreater

    if a.winsDon > b.winsDon
      return aIsGreater
    if a.winsDon < b.winsDon
      return bIsGreater

    if a.winsSheriff > b.winsSheriff
      return aIsGreater
    if a.winsSheriff < b.winsSheriff
      return bIsGreater

    if a.firstKilledNight > b.firstKilledNight
      return aIsGreater
    if a.firstKilledNight < b.firstKilledNight
      return bIsGreater

    return aIsGreater

if typeof(module) != 'undefined' && typeof(module.exports) != 'undefined'
  module.exports = compare
else
  this["playercomparator"] = compare
