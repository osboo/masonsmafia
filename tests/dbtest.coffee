should = require('should')
moment = require('moment')
Sequelize = require('sequelize')
constants = require('./../src/server/models/constants')
db = require('./../src/server/models/db')
lodash = require('lodash')
buildModels = require('./../src/server/models/BuildModels')

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

if process.env.MASONS_ENV == 'TEST'
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
          err.should.be.eql({ name: [ 'String is empty' ] })
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
            err.should.be.eql({"date": ["String is empty"],"result": ["String is empty"], "referee": ["String is empty"],})
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
            err.should.be.eql({result:['String is empty'], "referee": ["String is empty"]})
            done()
        )
      )
    )

    describe('/models/BuildModels', ()->
      describe('game3-2014-04-10', ()->
        paper = require('./TestGame')[0]
        models = {}
        it('should build all db models with no problems', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            done()
          )
        )

        it('should take a place at 2014-04-10', ()->
          gameObj = models.Game
          should(moment(gameObj.getDataValue('date')).format('YYYY-MM-DD')).be.eql('2014-04-10')
        )

        it('should have kazzantip be a referee', ()->
          gameObj = models.Game
          should(gameObj.getDataValue('referee')).be.eql('kazzantip')
        )

        it('should have mafia as a winner', ()->
          gameObj = models.Game
          should(gameObj.getDataValue('result')).be.eql(constants.GAME_RESULT.MAFIA_WIN)
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
            playerGames = models.PlayerGames
            for playerGame in playerGames
              if playerGame.role == constants.PLAYER_ROLES.SHERIFF
                playerGame.getPlayer().success((player)->
                  player.getDataValue('name').should.be.eql('Катафалк')
                  done()
                ).error((err)->done(err))
          )
        )

        it('should have Рон`s best move with accuracy 2', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            playerGames = models.PlayerGames
            chainer = new Sequelize.Utils.QueryChainer
            for playerGame in playerGames
              chainer.add(playerGame.getPlayer())
            chainer.run().success((players)->
              for player in players
                if player.getDataValue('name') == 'Рон'
                  playerGames[players.indexOf(player)].getDataValue('took_best_move').should.be.equal(true)
                  playerGames[players.indexOf(player)].getDataValue('best_move_accuracy').should.be.equal(2)
                else
                  playerGames[players.indexOf(player)].getDataValue('took_best_move').should.be.equal(false)
                  playerGames[players.indexOf(player)].getDataValue('best_move_accuracy').should.be.equal(0)
              done()
            ).error((err)->done(err))
          )
        )

        it('should have Рон killed at first night', (done)->
          buildModels(paper, (err, dbmodels)->
            if err
              done(err)
            models = dbmodels
            playerGames = models.PlayerGames
            chainer = new Sequelize.Utils.QueryChainer
            for playerGame in playerGames
              chainer.add(playerGame.getPlayer())
            chainer.run().success((players)->
              for player in players
                if player.getDataValue('name') == 'Рон'
                  playerGames[players.indexOf(player)].getDataValue('is_killed_first_at_night').should.be.equal(true)
                else
                  playerGames[players.indexOf(player)].getDataValue('is_killed_first_at_night').should.be.equal(false)
              done()
            ).error((err)->done(err))
          )
        )
      )
    )
  )
