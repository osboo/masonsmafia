chai = require("chai");
chaiAsPromised = require("chai-as-promised");
should = require('chai').should() 
chai.use(chaiAsPromised);

moment = require('moment')
Sequelize = require('sequelize')
constants = require('./../src/server/models/constants')
db = require('./../src/server/models/db')
buildModels = require('./../src/server/models/BuildModels')
rebuildCache = require('./../src/server/models/RebuildCache')

if process.env.MASONS_ENV == 'TEST'

  describe('models/db object', ()->
    it('should contain sequelize object', ()->
      db.should.have.property('sequelize')
    )
    it('should contain Player model', ()->
      db.should.have.property('Player')
    )
    it('should contain Game model', ()->
      db.should.have.property('Game')
    )
    it('should contain PlayerGame model', ()->
      db.should.have.property('PlayerGame')
    )
  )

  describe('Test games', ()->

    beforeEach(()->
      db.sequelize.sync({force: true}).complete((err)->
        should.not.exist(err)
      )
    )

    describe('Player model', ()->
      it('should not save player if name is empty', ()->
        db.Player.create({}).should.eventually.be.rejected
      )

      it('should save user if only name is provided', ()->
        savedPlayer = await db.Player.create({name: 'Borland'})
        savedPlayer.name.should.be.eql('Borland')
        foundPlayer = await db.Player.find({where: {name: 'Borland'}})
        foundPlayer.name.should.be.eql(savedPlayer.name)
        should.not.exist(foundPlayer.vk_id)
        should.not.exist(savedPlayer.vk_id)
        foundPlayer.service_role.should.be.eql(savedPlayer.service_role)
      )
    )

    describe('Game model', ()->
      it('should not save game without date', ()->
        db.Game.create({}).should.eventually.be.rejected
      )

      it('should not save game with missing result', ()->
        db.Game.create({date: moment().format('YYYY-MM-DD')}).should.eventually.be.rejected
      )
    )

    describe('/models/BuildModels', ()->
      describe('game3-2014-03-10', ()->
        paper = require('./TestGame').game_10_03[0]
        models = {}
        it('should build all db models with no problems', ()->
          buildModels(paper, (err, dbmodels)->
            should.not.exist(err)
            models = dbmodels
          )
        )

        it('should take a place at 2014-03-10', ()->
          gameObj = models.Game
          moment(gameObj.date).format('YYYY-MM-DD').should.be.eql('2014-03-10')
        )

        it('should have kazzantip be a referee', ()->
          gameObj = models.Game
          gameObj.referee.should.be.eql('kazzantip')
        )

        it('should have mafia as a winner', ()->
          gameObj = models.Game
          gameObj.result.should.be.eql(constants.GAME_RESULT.MAFIA_WIN)
        )

        it('should contain 10 players', ()->
          playerGames = models.PlayerGames
          playerGames.should.have.property('length', 10)

          players = models.Players
          players.should.have.property('length', 10)
        )

        it('should have Катафалк as sheriff', ()->
          buildModels(paper, (err, dbmodels)->
            should.not.exist(err)
            models = dbmodels
            gameID = models.Game.id
            player = await db.Player.find({where: {name: 'Катафалк'}})
            playerId = player.id
            playerGame = await db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]})
            playerGame.role.should.be.eql(constants.PLAYER_ROLES.SHERIFF)
          )
        )

        checkRole = (name, role, err, dbmodels)->
          should.not.exist(err)
          models = dbmodels
          gameID = models.Game.id
          player = await db.Player.find({where: {name: name}})
          playerId = player.id
          playerGame = await db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]})
          playerGame.role.should.be.eql(role)

        it('should have Агрессор as a don', ()->
          buildModels(paper, (err, dbmodels)->
            checkRole('Агрессор', constants.PLAYER_ROLES.DON, err, dbmodels)
          )
        )

        it('should have FrankLin as a mafia', ()->
          buildModels(paper, (err, dbmodels)->
            checkRole('FrankLin', constants.PLAYER_ROLES.MAFIA, err, dbmodels)
          )
        )

        it('should have Кошка as a mafia', ()->
          buildModels(paper, (err, dbmodels)->
            checkRole('Кошка', constants.PLAYER_ROLES.MAFIA, err, dbmodels)
          )
        )

        it('should have Малика without likes', ()->
          buildModels(paper, (err, dbmodels)->
            should.not.exist(err)
            models = dbmodels
            gameID = models.Game.id
            player = await db.Player.find({where: {name: 'Малика'}})
            playerId = player.id
            playerGame = await db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]})
            playerGame.likes.should.be.eql(0)
            playerGame.fouls.should.be.eql(1)
          )
        )

        it('should have Рон`s best move with accuracy 2', ()->
          buildModels(paper, (err, dbmodels)->
            should.not.exist(err)
            models = dbmodels
            gameID = models.Game.id
            player = await db.Player.find({where: {name: 'Рон'}})
            playerId = player.id
            playerGame = await db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]})
            playerGame.took_best_move.should.be.eql(true)
            playerGame.best_move_accuracy.should.be.eql(2)
          )
        )
        it('should have Рон killed at first night', ()->
          buildModels(paper, (err, dbmodels)->
            should.not.exist(err)
            models = dbmodels
            gameID = models.Game.id
            player = await db.Player.find({where: {name: 'Рон'}})
            playerId = player.id
            playerGame = await db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]})
            playerGame.is_killed_first_at_night.should.be.eql(true)
          )
        )

        it('should have FrankLin, Хедин and Кошка as the best players', ()->
          buildModels(paper, (err, dbmodels)->
            models = dbmodels
            gameID = models.Game.id
            players = []
            ['FrankLin', 'Хедин', 'Кошка'].forEach((playerName)->
              player = await db.Player.find({where: {name: playerName}}) 
              players.push(player)
            )
            playerGames = (await db.PlayerGame.find({where: ["PlayerId=#{player.id} and GameId=#{gameID}"]}) for player in players)
            for playerGame in playerGames
              playerGame.is_best.should.be.eql(true)
          )
        )

        it('should have FrankLin, Хедин and Кошка as players with 0.5 extra scores', ()->
          buildModels(paper, (err, dbmodels)->
            models = dbmodels
            gameID = models.Game.id
            players = []
            ['FrankLin', 'Хедин', 'Кошка'].forEach((playerName)->
              player = await db.Player.find({where: {name: playerName}}) 
              players.push(player)
            )
            playerGames = (await db.PlayerGame.find({where: ["PlayerId=#{player.id} and GameId=#{gameID}"]}) for player in players)
            for playerGame in playerGames
              playerGame.extra_scores.should.be.eql(0.5)
          )
        )

        it('should have Марвел as a first killed by day player', ()->
          buildModels(paper, (err, dbmodels)->
            models = dbmodels
            gameID = models.Game.id
            player = await db.Player.find({where: {name: 'Марвел'}})
            playerId = player.id
            playerGame = await db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]})
            playerGame.is_killed_first_by_day.should.be.eql(true)
          )
        )
      )
    )
    describe('/models/RebuildCache', ()->
      describe('game3-2014-03-10', ()->
        paper1 = require('./TestGame').game_10_03[0]
        it('should retrieve array with 10 players', ()->
          await buildModels(paper1, (err, dbmodels)->
            should.not.exist(err)
          )
          top10 = {}
          await rebuildCache((err, outTop10)-> top10 = outTop10)
          top10.should.have.length(10)
        )

        it('should have Марвел as a first killed by day player', ()->
          buildModels(paper1, (err, dbmodels)->
            should.not.exist(err)
            models = dbmodels
            gameID = models.Game.id
            player = await db.Player.find({where: {name: 'Марвел'}})
            playerId = player.id
            playerGame = await db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]})
            playerGame.is_killed_first_by_day.should.be.eql(true)
          )
        )
      )
    )
    describe('game3-2014-04-10 and same synthetic: same players but another winning party', ()->
      paper1 = require('./TestGame').game_10_03[0]
      paper2 = require('./TestGame').game_10_03[1]
      it('should show that FrankLin has 2.5 average rating', ()->
        await buildModels(paper1, (err, dbmodels)->
          should.not.exist(err)
          await buildModels(paper2, (err, dbmodels)->
            should.not.exist(err)
            average = 0.0
            await rebuildCache((err, top10)->
              should.not.exist(err)
              for player in top10
                if player.name == "FrankLin"
                  average = player.rating / (player.gamesCitizen + player.gamesSheriff + player.gamesMafia + player.gamesDon)
                  return
            )
            average.should.be.eql(5 / 2)
          )
        )
      )
    )
    describe('game 1 and game 2 at Masons Masters 16.03', ->
      paper1 = require('./TestGame').masonsMasters[0]
      paper2 = require('./TestGame').masonsMasters[1]
      it('should show that Женька-Печенька has zero extra scores per wins', () ->
        await buildModels(paper1, (err, dbmodels)->
          should.not.exist(err)
          await buildModels(paper2, (err, dbmodels)->
            should.not.exist(err)
            p = {}
            await rebuildCache((err, top10, commonStats)->
              should.not.exist(err)
              for player in commonStats
                if player.name == 'Женька-Печенька'
                  p = player
                  return
            )
            p.extraScoresPerWin.should.be.eql(0.0)
          )
        )
      )

      it('should show that Озб has 3 extra scores per wins', () ->
        await buildModels(paper1, (err, dbmodels)->
          should.not.exist(err)
          await buildModels(paper2, (err, dbmodels)->
            should.not.exist(err)
            p = {}
            await rebuildCache((err, top10, commonStats)->
              should.not.exist(err)
              for player in commonStats
                if player.name == 'Озб'
                  p = player
                  return
            )
            p.extraScoresPerWin.should.be.eql(6 / 2 )
          )
        )
      )

      it('should show that kors has 2 extra scores per wins', () ->
        await buildModels(paper1, (err, dbmodels)->
          should.not.exist(err)
          await buildModels(paper2, (err, dbmodels)->
            should.not.exist(err)
            p = {}
            await rebuildCache((err, top10, commonStats)->
              should.not.exist(err)
              for player in commonStats
                if player.name == 'kors'
                  p = player
                  return
            )
            p.extraScoresPerWin.should.be.eql(2.0)
          )
        )
      )
    )
  )
