deepCompare = (a, b)->
  aIsGreater = 1
  bIsGreater = -1
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon
  winsA = (a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon) / gamesA
  winsB = (b.winsCitizen + b.winsSheriff + b.winsMafia + b.winsDon) / gamesB

  if Math.abs(a.rating / gamesA - b.rating / gamesB) / Math.max(a.rating / gamesA, b.rating / gamesB) > 0.01
    if a.rating / gamesA > b.rating / gamesB
      return aIsGreater
    if a.rating / gamesA < b.rating / gamesB
      return bIsGreater

  if winsA > winsB
    return aIsGreater
  if winsA < winsB
    return bIsGreater

  if a.bestPlayer / gamesA > b.bestPlayer / gamesB
    return aIsGreater
  if a.bestPlayer / gamesA < b.bestPlayer / gamesB
    return bIsGreater

  if a.winsMafia / gamesA > b.winsMafia / gamesB
    return aIsGreater
  if a.winsMafia / gamesA < b.winsMafia / gamesB
    return bIsGreater

  if a.winsDon / gamesA > b.winsDon / gamesB
    return aIsGreater
  if a.winsDon / gamesA < b.winsDon / gamesB
    return bIsGreater

  if a.winsSheriff / gamesA > b.winsSheriff / gamesB
    return aIsGreater
  if a.winsSheriff / gamesA < b.winsSheriff / gamesB
    return bIsGreater

  if a.firstKilledNight / gamesA > b.firstKilledNight / gamesB
    return aIsGreater
  if a.firstKilledNight / gamesA < b.firstKilledNight / gamesB
    return bIsGreater

  return aIsGreater

experience = (a)->
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  winsA = a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon
  winRateA = if gamesA > 0 then winsA / gamesA else 0.0
  return if winRateA > 0.3 then Math.min(Math.log(gamesA) / Math.log(2), 8) else 0.0

average = (a)->
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  return if gamesA > 0 then a.rating / gamesA else 0.0

compare = (a, b)->
  aIsGreater = 1
  bIsGreater = -1
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon
  forceA = average(a) + experience(a)
  forceB = average(b) + experience(b)
  if gamesA != gamesB
      if Math.abs(forceA - forceB) / Math.max(forceA, forceB) > 1e-3
        return if forceA > forceB then aIsGreater else bIsGreater
      else
        return deepCompare(a, b)
  else
    return deepCompare(a, b)

comparator = {
  'compare': compare
  'average': average
  'experience': experience
}

if typeof(module) != 'undefined' && typeof(module.exports) != 'undefined'
  module.exports = comparator
else
  this["playercomparator"] = comparator
