deepCompare = (a, b)->
  aIsGreater = 1
  bIsGreater = -1
  winsA = a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon
  winsB = b.winsCitizen + b.winsSheriff + b.winsMafia + b.winsDon
  if Math.abs(a.rating - b.rating) / Math.max(a.rating, b.rating) > 0.01
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

compare = (a, b)->
  minimalDistance = 5
  aIsGreater = 1
  bIsGreater = -1
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon
  averageA = if gamesA > 0 then a.rating / gamesA else 0
  averageB = if gamesB > 0 then b.rating / gamesB else 0
  forceA = averageA + if gamesA then Math.log(gamesA) / Math.log(3) else 0
  forceB = averageB + if gamesB then Math.log(gamesB) / Math.log(3) else 0
  if gamesA != gamesB
    if gamesA <= minimalDistance && gamesB <= minimalDistance || gamesA > minimalDistance && gamesB > minimalDistance
      if Math.abs(forceA - forceB) / Math.max(forceA, forceB) > 0.01
        return if forceA > forceB then aIsGreater else bIsGreater
      else
        return deepCompare(a, b)
    else
      if Math.abs(a.rating - b.rating) / Math.max(a.rating, b.rating) > 0.01
        return if a.rating > b.rating then aIsGreater else bIsGreater
      else
        return deepCompare(a, b)
  else
    return deepCompare(a, b)

if typeof(module) != 'undefined' && typeof(module.exports) != 'undefined'
  module.exports = compare
else
  this["playercomparator"] = compare
