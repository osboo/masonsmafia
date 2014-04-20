should = require('should')
describe('models/db object', ()->
  describe('Models loading', ()->
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

)

if process.env.MASONS_ENV == 'TEST'
  describe('Load testing games', ()->
    db = require('./../src/server/models/db')
    describe('Purge testing database', ()->
      it('should connect and purge test base', (done)->
        db.sequelize.sync({force: true}).complete((err)->
          if err
            throw err
          done()
        )
      )
    )

    describe('Input player', ()->
      it('should throw an error if name is empty', (done)->
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
  )

