compare = (a, b)->
  aIsGreater = 1
  bIsGreater = -1
  minimalDistance = 5
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon
  winsA = a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon
  winsB = b.winsCitizen + b.winsSheriff + b.winsMafia + b.winsDon
  if gamesA != gamesB
    averageA = if gamesA > 0 then a.rating / gamesA else 0
    averageB = if gamesB > 0 then b.rating / gamesB else 0
    if gamesA <= minimalDistance && gamesB <= minimalDistance
      return if averageA > averageB then aIsGreater else bIsGreater
    if gamesA > minimalDistance && gamesB > minimalDistance
      distanceRatio = gamesA / gamesB
      distanceSupport = Math.log(distanceRatio) / Math.log(3)
      return if averageA - averageB + distanceSupport > 0 then aIsGreater else bIsGreater
    return if a.rating > b.rating then aIsGreater else bIsGreater
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
