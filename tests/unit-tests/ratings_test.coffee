should = require('should')
PLAYER_ROLES = require('./../../src/server/models/constants').PLAYER_ROLES
GAME_RESULT = require('./../../src/server/models/constants').GAME_RESULT

describe('rating 3-4-2 calculation', ()->
  describe('citizen wins with best move accuracy of 2', ()->
    it('should return 3.5', ()->
      playerGame = {role: PLAYER_ROLES.CITIZEN, extra_scores: 0, best_move_accuracy: 2}
      r = require('./../../src/server/models/rating_formula_342')
      should(r(playerGame, GAME_RESULT.CITIZENS_WIN)).be.eql(3.5)
    )
  )

  describe('Don that fails the game but has a 1.5 extra score', ()->
    it('should return 1.5', ()->
      playerGame = {role: PLAYER_ROLES.DON, extra_scores: 1.5, best_move_accuracy: 0}
      r = require('./../../src/server/models/rating_formula_342')
      should(r(playerGame, GAME_RESULT.CITIZENS_WIN)).be.eql(1.5)
    )
  )

  describe('Mafia that wins the game was disqualified by 4 fouls', ()->
    it('should return 4.0', ()->
      playerGame = {role: PLAYER_ROLES.MAFIA, extra_scores: 0.0, best_move_accuracy: 0}
      r = require('./../../src/server/models/rating_formula_342')
      should(r(playerGame, GAME_RESULT.MAFIA_WIN)).be.eql(4.0)
    )
  )
)

describe('Player comparator', ->
  describe('Player A: n=3 r=3, Player B: n=1 r=3', ->
    it('should show that A < B', ->
      compare = require('./../../src/server/models/PlayerComparatorLoader')
      A = {
        gamesCitizen: 1, gamesSheriff: 0, gamesMafia: 2, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      }
      B= {
        gamesCitizen: 1, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      }
      should(compare(A, B)).be.eql(1)
    )
  )

  describe('Player A: n=10 r=3, Player B: n=1 r=3', ->
    it('should show that A > B', ->
      compare = require('./../../src/server/models/PlayerComparatorLoader')
      A = {
        gamesCitizen: 10, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      }
      B= {
        gamesCitizen: 1, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      }
      should(compare(A, B)).be.eql(-1)
    )
  )

  describe('Player A: n=10 r=3, Player B: n=6 r=3', ->
    it('should show that A < B', ->
      compare = require('./../../src/server/models/PlayerComparatorLoader')
      A = {
        gamesCitizen: 10, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      }
      B= {
        gamesCitizen: 6, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      }
      should(compare(A, B)).be.eql(1)
    )
  )
)