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

    describe('Input game', ()->
      it('should save input data in database with no errors', (done)->
        done()
      )
    )
  )

