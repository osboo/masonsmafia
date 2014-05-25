PLAYER_ROLES = require('./constants').PLAYER_ROLES
GAME_RESULT = require('./constants').GAME_RESULT

module.exports = (playerGame, gameResult)->
  winScores = {}
  bestMoveScores = {}
  result = 0.0
  winScores[PLAYER_ROLES.CITIZEN] = 3.0
  winScores[PLAYER_ROLES.SHERIFF] = 3.0
  winScores[PLAYER_ROLES.MAFIA] = 4.0
  winScores[PLAYER_ROLES.DON] = 4.0
  bestMoveScores[0] = 0.0
  bestMoveScores[1] = 0.0
  bestMoveScores[2] = 0.5
  bestMoveScores[3] = 1.0

  if gameResult == GAME_RESULT.CITIZENS_WIN
    winScores[PLAYER_ROLES.MAFIA] = 0.0
    winScores[PLAYER_ROLES.DON] = 0.0

  if gameResult == GAME_RESULT.MAFIA_WIN
    winScores[PLAYER_ROLES.CITIZEN] = 0.0
    winScores[PLAYER_ROLES.SHERIFF] = 0.0

  result = winScores[playerGame.role] + playerGame.extra_scores + bestMoveScores[playerGame.best_move_accuracy]
