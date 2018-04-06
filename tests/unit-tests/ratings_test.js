// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const should = require('should');
const { PLAYER_ROLES } = require('./../../src/server/models/constants');
const { GAME_RESULT } = require('./../../src/server/models/constants');

describe('rating 3-4-2 calculation', function(){
  describe('citizen wins with best move accuracy of 2', ()=>
    it('should return 3.5', function(){
      const playerGame = {role: PLAYER_ROLES.CITIZEN, extra_scores: 0, best_move_accuracy: 2};
      const r = require('./../../src/server/models/rating_formula_342');
      return should(r(playerGame, GAME_RESULT.CITIZENS_WIN)).be.eql(3.5);
    })
  );

  describe('Don that fails the game but has a 1.5 extra score', ()=>
    it('should return 1.5', function(){
      const playerGame = {role: PLAYER_ROLES.DON, extra_scores: 1.5, best_move_accuracy: 0};
      const r = require('./../../src/server/models/rating_formula_342');
      return should(r(playerGame, GAME_RESULT.CITIZENS_WIN)).be.eql(1.5);
    })
  );

  return describe('Mafia that wins the game was disqualified by 4 fouls', ()=>
    it('should return 3.0', function(){
      const playerGame = {role: PLAYER_ROLES.MAFIA, extra_scores: -1.0, is_best: false, best_move_accuracy: 0};
      const r = require('./../../src/server/models/rating_formula_342');
      return should(r(playerGame, GAME_RESULT.MAFIA_WIN)).be.eql(3.0);
    })
  );
});

describe('Player comparator', function() {
  describe('Player A: n=3 r=3, Player B: n=1 r=3', () =>
    it('should show that A < B', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const A = {
        gamesCitizen: 1, gamesSheriff: 0, gamesMafia: 2, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      };
      const B= {
        gamesCitizen: 1, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      };
      return should(compare(A, B)).be.eql(-1);
    })
  );

  describe('Player A: n=10 r=3, Player B: n=1 r=3', () =>
    it('should show that A < B', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const A = {
        gamesCitizen: 10, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      };
      const B= {
        gamesCitizen: 1, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      };
      return should(compare(A, B)).be.eql(-1);
    })
  );

  describe('Player A: n=10 r=3, Player B: n=6 r=3', () =>
    it('should show that A < B: both players are uneducable', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const A = {
        gamesCitizen: 10, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      };

      const B= {
        gamesCitizen: 6, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 1, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 3
      };
      return should(compare(A, B)).be.eql(-1);
    })
  );

  describe('Player A: n=7 r=26, Player B: n=21 r=63', () =>
    it('should show that A < B because B he has more games', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const A = {
        gamesCitizen: 7, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 7, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 26
      };
      const B= {
        gamesCitizen: 21, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 21, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 63
      };
      return should(compare(A, B)).be.eql(-1);
    })
  );

  describe('Player A: n=20 r=60, Player B: n=45 r=50', () =>
    it('should show that A > B because average rating of A is higher', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const A = {
        gamesCitizen: 20, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 0, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 60
      };
      const B= {
        gamesCitizen: 60, gamesSheriff: 0, gamesMafia: 0, gamesDon: 0,
        winsCitizen: 0, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        rating: 80
      };
      return should(compare(A, B)).be.eql(1);
    })
  );

  describe('A - B: n:10-10 wins:4-4 best:3-3 winsMafia:3-3 winsDon:0-0 winsSheriff:1-1 killedAtFirstNight:0-1', () =>
    it('should show that B > A because B has more firstKilledAtNight', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const A = {
        gamesCitizen: 6, gamesSheriff: 1, gamesMafia: 3, gamesDon: 0,
        winsCitizen: 0, winsSheriff: 1, winsMafia: 3, winsDon: 0,
        bestPlayer: 3,
        rating: 18,
        firstKilledNight: 0
      };
      const B= {
        gamesCitizen: 6, gamesSheriff: 1, gamesMafia: 3, gamesDon: 0,
        winsCitizen: 0, winsSheriff: 1, winsMafia: 3, winsDon: 0,
        bestPlayer: 3,
        rating: 18,
        firstKilledNight: 1
      };
      return should(compare(A, B)).be.eql(-1);
    })
  );

  describe('Озб vs Олифер', () =>
    it('should show that Озб can be better', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const Osb = {
        gamesCitizen: 8, gamesSheriff: 0, gamesMafia: 5, gamesDon: 3,
        winsCitizen: 3, winsSheriff: 0, winsMafia: 5, winsDon: 1,
        bestPlayer: 7,
        rating: 44.0,
        firstKilledNight: 1
      };
      const Olifer = {
        gamesCitizen: 15, gamesSheriff: 4, gamesMafia: 7, gamesDon: 4,
        winsCitizen: 6, winsSheriff: 1, winsMafia: 6, winsDon: 3,
        bestPlayer: 7,
        rating: 64.5,
        firstKilledNight: 4
      };
      return should(compare(Osb, Olifer)).be.eql(-1);
    })
  );

  return describe('13 vs Витамин', () =>
    it('should show that 13 is better', function() {
      const compare = require('./../../src/server/models/PlayerComparatorLoader');
      const thirdteen = {
        gamesCitizen: 1, gamesSheriff: 0, gamesMafia: 3, gamesDon: 1,
        winsCitizen: 0, winsSheriff: 0, winsMafia: 2, winsDon: 1,
        bestPlayer: 4,
        rating: 16,
        firstKilledNight: 0
      };
      const vitamin = {
        gamesCitizen: 3, gamesSheriff: 1, gamesMafia: 0, gamesDon: 2,
        winsCitizen: 2, winsSheriff: 0, winsMafia: 0, winsDon: 0,
        bestPlayer: 1,
        rating: 6.5,
        firstKilledNight: 0
      };
      return should(compare(thirdteen, vitamin)).be.eql(1);
    })
  );

});