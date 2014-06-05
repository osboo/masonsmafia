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

compare = (a, b)->
  aIsGreater = 1
  bIsGreater = -1
  gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon
  gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon
  winsA = a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon
  winsB = b.winsCitizen + b.winsSheriff + b.winsMafia + b.winsDon
  winRateA = if gamesA > 0 then winsA / gamesA else 0.0
  winRateB = if gamesB > 0 then winsB / gamesB else 0.0
  averageA = if gamesA > 0 then a.rating / gamesA else 0.0
  averageB = if gamesB > 0 then b.rating / gamesB else 0.0
  distanceSupportA = if winRateA > 0.3 then Math.log(gamesA) / Math.log(2) else 0.0
  distanceSupportB = if winRateB > 0.3 then Math.log(gamesB) / Math.log(2) else 0.0
  forceA = averageA + Math.min(distanceSupportA, 8)
  forceB = averageB + Math.min(distanceSupportB, 8)
#  console.log("A: #{averageA} + #{distanceSupportA} B: #{averageB} + #{distanceSupportB}")
#  console.log(forceA, forceB)
  if gamesA != gamesB
      if Math.abs(forceA - forceB) / Math.max(forceA, forceB) > 0.01
        return if forceA > forceB then aIsGreater else bIsGreater
      else
        return deepCompare(a, b)
  else
    return deepCompare(a, b)

if typeof(module) != 'undefined' && typeof(module.exports) != 'undefined'
  module.exports = compare
else
  this["playercomparator"] = compare
