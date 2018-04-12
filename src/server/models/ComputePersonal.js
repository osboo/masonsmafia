// Generated by CoffeeScript 2.2.3
(function() {
  let GAME_RESULT, PLAYER_ROLES, computePersonalAsync, db, rating;

  db = require('./db');

  PLAYER_ROLES = require('./constants').PLAYER_ROLES;

  GAME_RESULT = require('./constants').GAME_RESULT;

  rating = require('./rating_formula_342');

  computePersonalAsync = async function(playerName, done) {
    let bestMoveAttempts, delta, err, foundedMafiaOnBestMove, games, i, j, k, pg, player, playerGame, playerGames, profile, ref, ref1, ref2, ref3, result;
    try {
      profile = {
        'name': '',
        'rating': 0,
        'winsCitizen': 0,
        'winsSheriff': 0,
        'winsMafia': 0,
        'winsDon': 0,
        'gamesCitizen': 0,
        'gamesSheriff': 0,
        'gamesMafia': 0,
        'gamesDon': 0,
        'likesCitizen': 0,
        'likesSheriff': 0,
        'likesMafia': 0,
        'likesDon': 0,
        'bestPlayerCitizen': 0,
        'bestPlayerSheriff': 0,
        'bestPlayerMafia': 0,
        'bestPlayerDon': 0,
        'bestMoveAccuracy': 0.0,
        'firstKilledNightCitizen': 0,
        'firstKilledNightSheriff': 0,
        'firstKilledNightMafia': 0,
        'firstKilledNightDon': 0,
        'firstKilledDayCitizen': 0,
        'firstKilledDaySheriff': 0,
        'firstKilledDayMafia': 0,
        'firstKilledDayDon': 0,
        'foulsCitizen': 0,
        'foulsSheriff': 0,
        'foulsMafia': 0,
        'foulsDon': 0,
        'efficiency': [],
      };
      player = (await db.Player.find({
        where: {
          name: playerName,
        },
      }));
      if (!player) {
        throw new Error(`Player ${playerName} not found`);
      }
      playerGames = (await db.PlayerGame.findAll({
        where: {
          PlayerId: player.id,
        },
      }));
      games = (await (async function() {
        let j, len, results;
        results = [];
        for (j = 0, len = playerGames.length; j < len; j++) {
          pg = playerGames[j];
          results.push((await pg.getGame()));
        }
        return results;
      })());
      profile.name = playerName;
      bestMoveAttempts = 0;
      foundedMafiaOnBestMove = 0;
      for (i = j = 0, ref = playerGames.length; (0 <= ref ? j < ref : j > ref); i = 0 <= ref ? ++j : --j) {
        result = games[i].result;
        playerGame = playerGames[i];
        delta = 0;
        if ((ref1 = playerGame.role) === PLAYER_ROLES.CITIZEN || ref1 === PLAYER_ROLES.SHERIFF) {
          delta = result === GAME_RESULT.CITIZENS_WIN ? 1 : -1;
        }
        if ((ref2 = playerGame.role) === PLAYER_ROLES.MAFIA || ref2 === PLAYER_ROLES.DON) {
          delta = result === GAME_RESULT.MAFIA_WIN ? 1 : -1;
        }
        profile.efficiency.push({
          gameID: games[i].id,
          date: games[i].date.getTime(),
          winsMinusLosses: delta,
          gameResult: delta,
        });
        profile.rating += rating(playerGame, result);
        if (result === GAME_RESULT.CITIZENS_WIN && playerGame.role === PLAYER_ROLES.CITIZEN) {
          profile.winsCitizen += 1;
        }
        if (result === GAME_RESULT.CITIZENS_WIN && playerGame.role === PLAYER_ROLES.SHERIFF) {
          profile.winsSheriff += 1;
        }
        if (result === GAME_RESULT.MAFIA_WIN && playerGame.role === PLAYER_ROLES.MAFIA) {
          profile.winsMafia += 1;
        }
        if (result === GAME_RESULT.MAFIA_WIN && playerGame.role === PLAYER_ROLES.DON) {
          profile.winsDon += 1;
        }
        if (playerGame.role === PLAYER_ROLES.CITIZEN) {
          profile.gamesCitizen += 1;
        }
        if (playerGame.role === PLAYER_ROLES.SHERIFF) {
          profile.gamesSheriff += 1;
        }
        if (playerGame.role === PLAYER_ROLES.MAFIA) {
          profile.gamesMafia += 1;
        }
        if (playerGame.role === PLAYER_ROLES.DON) {
          profile.gamesDon += 1;
        }
        if (playerGame.role === PLAYER_ROLES.CITIZEN) {
          profile.likesCitizen += playerGame.likes;
        }
        if (playerGame.role === PLAYER_ROLES.SHERIFF) {
          profile.likesSheriff += playerGame.likes;
        }
        if (playerGame.role === PLAYER_ROLES.MAFIA) {
          profile.likesMafia += playerGame.likes;
        }
        if (playerGame.role === PLAYER_ROLES.DON) {
          profile.likesDon += playerGame.likes;
        }
        if (playerGame.role === PLAYER_ROLES.CITIZEN && playerGame.is_best) {
          profile.bestPlayerCitizen += 1;
        }
        if (playerGame.role === PLAYER_ROLES.SHERIFF && playerGame.is_best) {
          profile.bestPlayerSheriff += 1;
        }
        if (playerGame.role === PLAYER_ROLES.MAFIA && playerGame.is_best) {
          profile.bestPlayerMafia += 1;
        }
        if (playerGame.role === PLAYER_ROLES.DON && playerGame.is_best) {
          profile.bestPlayerDon += 1;
        }
        if (playerGame.took_best_move) {
          bestMoveAttempts += 1;
        }
        if (playerGame.took_best_move) {
          foundedMafiaOnBestMove += playerGame.best_move_accuracy;
        }
        if (playerGame.role === PLAYER_ROLES.CITIZEN && playerGame.is_killed_first_at_night) {
          profile.firstKilledNightCitizen += 1;
        }
        if (playerGame.role === PLAYER_ROLES.SHERIFF && playerGame.is_killed_first_at_night) {
          profile.firstKilledNightSheriff += 1;
        }
        if (playerGame.role === PLAYER_ROLES.MAFIA && playerGame.is_killed_first_at_night) {
          profile.firstKilledNightMafia += 1;
        }
        if (playerGame.role === PLAYER_ROLES.DON && playerGame.is_killed_first_at_night) {
          profile.firstKilledNightDon += 1;
        }
        if (playerGame.role === PLAYER_ROLES.CITIZEN && playerGame.is_killed_first_by_day) {
          profile.firstKilledDayCitizen += 1;
        }
        if (playerGame.role === PLAYER_ROLES.SHERIFF && playerGame.is_killed_first_by_day) {
          profile.firstKilledDaySheriff += 1;
        }
        if (playerGame.role === PLAYER_ROLES.MAFIA && playerGame.is_killed_first_by_day) {
          profile.firstKilledDayMafia += 1;
        }
        if (playerGame.role === PLAYER_ROLES.DON && playerGame.is_killed_first_by_day) {
          profile.firstKilledDayDon += 1;
        }
        if (playerGame.role === PLAYER_ROLES.CITIZEN) {
          profile.foulsCitizen += playerGame.fouls;
        }
        if (playerGame.role === PLAYER_ROLES.SHERIFF) {
          profile.foulsSheriff += playerGame.fouls;
        }
        if (playerGame.role === PLAYER_ROLES.MAFIA) {
          profile.foulsMafia += playerGame.fouls;
        }
        if (playerGame.role === PLAYER_ROLES.DON) {
          profile.foulsDon += playerGame.fouls;
        }
        profile.bestMoveAccuracy = bestMoveAttempts ? foundedMafiaOnBestMove / bestMoveAttempts : 0.0;
        profile.efficiency.sort(function(a, b) {
          if (a.date > b.date) {
            return 1;
          } else {
            return -1;
          }
        });
      }
      for (i = k = 1, ref3 = playerGames.length; (1 <= ref3 ? k < ref3 : k > ref3); i = 1 <= ref3 ? ++k : --k) {
        profile.efficiency[i].winsMinusLosses += profile.efficiency[i - 1].winsMinusLosses;
      }
      done(null, profile);
    } catch (error) {
      err = error;
      done(err, null);
    }
    return true;
  };

  module.exports = function(playerName) {
    return new Promise(function(resolve, reject) {
      return computePersonalAsync(playerName, function(err, profile) {
        if (err) {
          reject(err);
        }
        if (!err) {
          return resolve(profile);
        }
      });
    });
  };
}).call(this); // eslint-disable-line no-invalid-this
