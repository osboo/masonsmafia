should = require('should')
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

    beforeEach((done)->
      db.sequelize.sync({force: true}).complete((err)->
        if err
          console.log(err)
          done(err)
        done()
      )
    )

    describe('Player model', ()->
      it('should not save player if name is empty', (done)->
        db.Player.create({})
        .success((player)->
          throw player
        )
        .error((err)->
          err.should.be.eql({
            "__raw": [
              null
            ],
            "name": [
              "Validation notNull failed"
            ]
          })
          done()
        )
      )

      it('should save user if only name is provided', (done)->
        db.Player.create({name: 'Borland'}).success(
          (savedPlayer)->
            savedPlayer.name.should.be.eql('Borland')
            db.Player.find({where: {name: 'Borland'}}).success(
              (foundPlayer)->
                foundPlayer.name.should.be.eql(savedPlayer.name)
                should(foundPlayer.vk_id).be.eql(savedPlayer.vk_id)
                foundPlayer.service_role.should.be.eql(savedPlayer.service_role)
                done()
            )
        )
      )
    )

    describe('Game model', ()->
      it('should not save game without date', (done)->
        db.Game.create({})
        .success(
          (game)->
            throw game
        )
        .error(
          (err)->
            err.should.be.eql({
              "__raw": [
                null,
                null,
                null
              ],
              "date": [
                "Validation notNull failed"
              ],
              "referee": [
                "Validation notNull failed"
              ],
              "result": [
                "Validation notEmpty failed"
              ]
            })
            done()
        )
      )

      it('should not save game with missing result', (done)->
        db.Game.create({date: moment().format('YYYY-MM-DD')})
        .success(
          (game)->
            throw game
        )
        .error(
          (err)->
            err.should.be.eql({
              "__raw": [
                null,
                null
              ],
              "referee": [
                "Validation notNull failed"
              ],
              "result": [
                "Validation notEmpty failed"
              ]
            })
            done()
        )
      )
    )

    describe('/models/BuildModels', ()->
      describe('game3-2014-03-10', ()->
        paper = require('./TestGame').game_10_03[0]
        models = {}
        it('should build all db models with no problems', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            done()
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

        it('should have Катафалк as sheriff', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Катафалк'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.role.should.be.eql(constants.PLAYER_ROLES.SHERIFF)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have Агрессор as a don', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Агрессор'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.role.should.be.eql(constants.PLAYER_ROLES.DON)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have FrankLin as a mafia', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'FrankLin'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.role.should.be.eql(constants.PLAYER_ROLES.MAFIA)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have Кошка as a mafia', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Кошка'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.role.should.be.eql(constants.PLAYER_ROLES.MAFIA)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have Малика without likes', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Малика'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.likes.should.be.eql(0)
                playerGame.fouls.should.be.eql(1)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have Дядя Том with 1 like 0 fouls', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Дядя Том'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.likes.should.be.eql(1)
                playerGame.fouls.should.be.eql(0)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have Рон`s best move with accuracy 2', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Рон'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.took_best_move.should.be.eql(true)
                playerGame.best_move_accuracy.should.be.eql(2)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have Рон killed at first night', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Рон'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.is_killed_first_at_night.should.be.eql(true)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have FrankLin, Хедин and Кошка as the best players', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            chainer = new Sequelize.Utils.QueryChainer
            ['FrankLin', 'Хедин', 'Кошка'].forEach((playerName)->
              chainer.add(db.Player.find({where: {name: playerName}}))
            )
            chainer.run().success((players)->
              chainer2 = new Sequelize.Utils.QueryChainer
              for player in players
                chainer2.add(db.PlayerGame.find({where: ["PlayerId=#{player.id} and GameId=#{gameID}"]}))
              chainer2.run().success((playerGames)->
                for playerGame in playerGames
                  playerGame.is_best.should.be.eql(true)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have FrankLin, Хедин and Кошка as players with 0.5 extra scores', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            chainer = new Sequelize.Utils.QueryChainer
            ['FrankLin', 'Хедин', 'Кошка'].forEach((playerName)->
              chainer.add(db.Player.find({where: {name: playerName}}))
            )
            chainer.run().success((players)->
              chainer2 = new Sequelize.Utils.QueryChainer
              for player in players
                chainer2.add(db.PlayerGame.find({where: ["PlayerId=#{player.id} and GameId=#{gameID}"]}))
              chainer2.run().success((playerGames)->
                for playerGame in playerGames
                  playerGame.extra_scores.should.be.eql(0.5)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )

        it('should have Марвел as a first killed by day player', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            gameID = models.Game.id
            db.Player.find({where: {name: 'Марвел'}}).success((player)->
              playerId = player.id
              db.PlayerGame.find({where: ["PlayerId=#{playerId} and GameId=#{gameID}"]}).success((playerGame)->
                playerGame.is_killed_first_by_day.should.be.eql(true)
                done()
              ).error((err)->done(err))
            ).error((err)->done(err))
          )
        )
      )
    )

    describe('/models/RebuildCache', ()->
      describe('game3-2014-03-10', ()->
        paper1 = require('./TestGame').game_10_03[0]
        it('should retrieve array with 10 players', (done)->
          buildModels(paper1, (err, dbmodels)->
            if err
              done(err)
            rebuildCache((err, top10)->
              if err
                done(err)
              top10.should.have.length(10)
              done()
            )
          )
        )
      )

      describe('game3-2014-04-10 and same synthetic: same players but another winning party', ()->
        paper1 = require('./TestGame').game_10_03[0]
        paper2 = require('./TestGame').game_10_03[1]
        it('should show that FrankLin has 2.5 average rating', (done)->
          buildModels(paper1, (err, dbmodels)->
            if err
              done(err)
            buildModels(paper2, (err, dbmodels)->
              if err
                done(err)
              rebuildCache((err, top10)->
                if err
                  done(err)
                for player in top10
                  if player.name == "FrankLin"
                    average = player.rating / (player.gamesCitizen + player.gamesSheriff + player.gamesMafia + player.gamesDon)
                    average.should.be.eql(5 / 2)
                    done()
                    return
                done("player FrankLin not found")
              )
            )

          )
        )
      )

      describe('game 1 and game 2 at Masons Masters 16.03', ->
        paper1 = require('./TestGame').masonsMasters[0]
        paper2 = require('./TestGame').masonsMasters[1]
        it('should show that Женька-Печенька has zero extra scores per wins', (done) ->
          buildModels(paper1, (err, dbmodels)->
            if err
              done(err)
            buildModels(paper2, (err, dbmodels)->
              if err
                done(err)
              rebuildCache((err, top10, commonStats)->
                if err
                  done(err)
                for player in commonStats
                  if player.name == 'Женька-Печенька'
                    player.extraScoresPerWin.should.be.eql(0.0)
                    done()
                    return
                done("Not ready")
              )
            )
          )
        )

        it('should show that Озб has 3 extra scores per wins', (done) ->
          buildModels(paper1, (err, dbmodels)->
            if err
              done(err)
            buildModels(paper2, (err, dbmodels)->
              if err
                done(err)
              rebuildCache((err, top10, commonStats)->
                if err
                  done(err)
                for player in commonStats
                  if player.name == 'Озб'
                    player.extraScoresPerWin.should.be.eql(6 / 2 )
                    done()
                    return
                done("Not ready")
              )
            )
          )
        )

        it('should show that kors has 2 extra scores per wins', (done) ->
          buildModels(paper1, (err, dbmodels)->
            if err
              done(err)
            buildModels(paper2, (err, dbmodels)->
              if err
                done(err)
              rebuildCache((err, top10, commonStats)->
                if err
                  done(err)
                for player in commonStats
                  if player.name == 'kors'
                    player.extraScoresPerWin.should.be.eql(2.0)
                    done()
                    return
                done("Not ready")
              )
            )
          )
        )
      )
    )
  )
