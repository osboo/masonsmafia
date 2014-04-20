should = require('should')
describe('db loading', ()->
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
