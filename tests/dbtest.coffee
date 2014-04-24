should = require('should')
moment = require('moment')
constants = require('./../src/server/models/constants')
db = require('./../src/server/models/db')
lodash = require('lodash')
buildModels = require('./../src/server/models/BuildModels')

describe('models/db object', ()->
  db = require('./../src/server/models/db')
  it('should contain sequelize object', ()->
    should(db).have.property('sequelize')
  )
  it('should contain Player model', ()->
    should(db).have.property('Player')
  )
  it('should contain Game model', ()->
    should(db).have.property('Game')
  )
  it('should contain PlayerGame model', ()->
    should(db).have.property('PlayerGame')
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
          should(err).be.eql({ name: [ 'String is empty' ] })
          done()
        )
      )

      it('should save user if only name is provided', (done)->
        db.Player.create({name: 'Borland'}).success(
          (savedPlayer)->
            should(savedPlayer.name).be.eql('Borland')
            db.Player.find({where: {name: 'Borland'}}).success(
              (foundPlayer)->
                should(foundPlayer.name).be.eql(savedPlayer.name)
                should(foundPlayer.vk_id).be.eql(savedPlayer.vk_id)
                should(foundPlayer.service_role).be.eql(savedPlayer.service_role)
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
            should(err).be.eql({"date": ["String is empty"],"result": ["String is empty"], "referee": ["String is empty"],})
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
            should(err).be.eql({result:['String is empty'], "referee": ["String is empty"]})
            done()
        )
      )
    )
    describe('/models/BuildModels', ()->
      describe('game3-2014-04-10', ()->
        paper = require('./TestGame')[0]
        models = {}
        gameObj = {}
        it('should build all db models with no problems', (done)->
          buildModels(paper, (dbmodels)->
            models = dbmodels
            done()
          )
        )

        it('should take a place at 2014-04-10', ()->
          gameObj = models.Game
          should(moment(gameObj.getDataValue('date')).format('YYYY-MM-DD')).be.eql('2014-04-10')
        )

        it('should have kazzantip as a referee', ()->
          gameObj = models.Game
          should(gameObj.getDataValue('referee')).be.eql('kazzantip')
        )

        it('should have a mafia winner', ()->
          gameObj = models.Game
          should(gameObj.getDataValue('result')).be.eql(constants.GAME_RESULT.MAFIA_WIN)
        )
#        it('should contain 10 players', ()->
#        )
#        it('should have sheriff as Катафалк', ()->
#        )
      )
    )
  )

