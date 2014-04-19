should = require('should')
describe('db loading', ()->
  it('should retrieve at least one model', ()->
    db = require('./../src/server/models/db')
    should(Object.keys(db).length).be.greaterThan(1)
  )
)
