// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const deepCompare = function(a, b) {
  const aIsGreater = 1;
  const bIsGreater = -1;
  const gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon;
  const gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon;
  const winsA = (a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon) / gamesA;
  const winsB = (b.winsCitizen + b.winsSheriff + b.winsMafia + b.winsDon) / gamesB;

  if ((Math.abs((a.rating / gamesA) - (b.rating / gamesB)) / Math.max(a.rating / gamesA, b.rating / gamesB)) > 0.01) {
    if ((a.rating / gamesA) > (b.rating / gamesB)) {
      return aIsGreater;
    }
    if ((a.rating / gamesA) < (b.rating / gamesB)) {
      return bIsGreater;
    }
  }

  if (winsA > winsB) {
    return aIsGreater;
  }
  if (winsA < winsB) {
    return bIsGreater;
  }

  if ((a.bestPlayer / gamesA) > (b.bestPlayer / gamesB)) {
    return aIsGreater;
  }
  if ((a.bestPlayer / gamesA) < (b.bestPlayer / gamesB)) {
    return bIsGreater;
  }

  if ((a.winsMafia / gamesA) > (b.winsMafia / gamesB)) {
    return aIsGreater;
  }
  if ((a.winsMafia / gamesA) < (b.winsMafia / gamesB)) {
    return bIsGreater;
  }

  if ((a.winsDon / gamesA) > (b.winsDon / gamesB)) {
    return aIsGreater;
  }
  if ((a.winsDon / gamesA) < (b.winsDon / gamesB)) {
    return bIsGreater;
  }

  if ((a.winsSheriff / gamesA) > (b.winsSheriff / gamesB)) {
    return aIsGreater;
  }
  if ((a.winsSheriff / gamesA) < (b.winsSheriff / gamesB)) {
    return bIsGreater;
  }

  if ((a.firstKilledNight / gamesA) > (b.firstKilledNight / gamesB)) {
    return aIsGreater;
  }
  if ((a.firstKilledNight / gamesA) < (b.firstKilledNight / gamesB)) {
    return bIsGreater;
  }

  return aIsGreater;
};

const experience = function(a) {
  const gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon;
  const winsA = a.winsCitizen + a.winsSheriff + a.winsMafia + a.winsDon;
  const winRateA = gamesA > 0 ? winsA / gamesA : 0.0;
  if (winRateA > 0.3) {
 return Math.min(Math.log(gamesA) / Math.log(2), 8);
} else {
 return 0.0;
}
};

const average = function(a) {
  const gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon;
  if (gamesA > 0) {
 return a.rating / gamesA;
} else {
 return 0.0;
}
};

const compare = function(a, b) {
  const aIsGreater = 1;
  const bIsGreater = -1;
  const gamesA = a.gamesCitizen + a.gamesSheriff + a.gamesMafia + a.gamesDon;
  const gamesB = b.gamesCitizen + b.gamesSheriff + b.gamesMafia + b.gamesDon;
  const forceA = average(a) + experience(a);
  const forceB = average(b) + experience(b);
  if (gamesA !== gamesB) {
      if ((Math.abs(forceA - forceB) / Math.max(forceA, forceB)) > 1e-3) {
        if (forceA > forceB) {
 return aIsGreater;
} else {
 return bIsGreater;
}
      } else {
        return deepCompare(a, b);
      }
  } else {
    return deepCompare(a, b);
  }
};

const comparator = {
  'compare': compare,
  'average': average,
  'experience': experience,
};

if ((typeof(module) !== 'undefined') && (typeof(module.exports) !== 'undefined')) {
  module.exports = comparator;
} else {
  this['playercomparator'] = comparator; // eslint-disable-line no-invalid-this
}
