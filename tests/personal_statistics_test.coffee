should = require('should')
db = require('./../src/server/models/db')
buildModels = require('./../src/server/models/BuildModels')
ComputePersonal = require('./../src/server/models/ComputePersonal')

if process.env.MASONS_ENV == 'TEST'
  describe('ComputePersonal', ()->
    describe('Games at Masons Masters', ()->

      beforeEach((done)->
        db.sequelize.sync({force: true}).complete((err)->
          if err
            console.log(err)
            done(err)
          paper1 = require('./TestGame').masonsMasters[0]
          paper2 = require('./TestGame').masonsMasters[1]
          paper3 = require('./TestGame').masonsMasters[2]
          buildModels(paper1, (err, result)->
            buildModels(paper2, (err, result)->
              buildModels(paper3, (err, result)->
                if err
                  done(err)
                done()
              )
            )
          )
        )
      )

      it('should show that Кошка 1 time was killed by day being the mafia', (done)->
        ComputePersonal("Кошка", (err, profile)->
          if err
            done(error)
          profile.firstKilledDayMafia.should.be.eql(1)
          done()
        )
      )

      it('should show that Малика has loses 1 time being the mafia', (done)->
        ComputePersonal("Малика", (err, profile)->
          if err
            done(error)
          profile.gamesMafia.should.be.eql(1)
          profile.winsMafia.should.be.eql(0)
          done()
        )
      )
    )
  )