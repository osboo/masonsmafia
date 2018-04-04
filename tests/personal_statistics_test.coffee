should = require('should')
db = require('./../src/server/models/db')
buildModels = require('./../src/server/models/BuildModels')
ComputePersonal = require('./../src/server/models/ComputePersonal')

if process.env.MASONS_ENV == 'TEST'
  describe('ComputePersonal', ()->
    describe('Games at Masons Masters', ()->

      beforeEach(()->
        await db.sequelize.sync({force: true}).complete((err)->)
        paper1 = require('./TestGame').masonsMasters[0]
        paper2 = require('./TestGame').masonsMasters[1]
        paper3 = require('./TestGame').masonsMasters[2]
        await buildModels(paper1)
        await buildModels(paper2)
        await buildModels(paper3)
      )

      it('should show that Кошка 1 time was killed by day being the mafia', ()->
        p = await ComputePersonal("Кошка")
        p.firstKilledDayMafia.should.be.eql(1)
      )

      it('should show that Малика has loses 1 time being the mafia', ()->
        profile = await ComputePersonal("Малика")
        profile.gamesMafia.should.be.eql(1)
        profile.winsMafia.should.be.eql(0)
      )

      it('should show that kors has win-loss equal to 1', () ->
        profile = await ComputePersonal("kors")
        profile.efficiency[2].winsMinusLosses.should.be.eql(1)
        profile.efficiency[0].gameResult.should.be.eql(-1)
        profile.efficiency[1].gameResult.should.be.eql(1)
        profile.efficiency[2].gameResult.should.be.eql(1)
      )
    )
  )
