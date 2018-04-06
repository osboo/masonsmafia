const constants = require('./../../src/server/models/constants');

const game_10_03_3 = {
  referee: "kazzantip",
  date: "2014-03-10",
  result: constants.GAME_RESULT.MAFIA_WIN,
  firstKilledAtNight: "Рон",
  firstKilledByDay: "Марвел",
  bestMoveAuthor: "Рон",
  bestMoveAccuracy: 2,
  players:[{
    name: "Дядя Том",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 0,
    likes: 1,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Малика",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 1,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Катафалк",
    role: constants.PLAYER_ROLES.SHERIFF,
    fouls: 0,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Рон",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 0,
    likes: 1,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Соколов",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 1,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  },{
    name: "FrankLin",
    role: constants.PLAYER_ROLES.MAFIA,
    fouls: 3,
    likes: 2,
    isBest: true,
    extraScores: 0.5
  },{
    name: "Агрессор",
    role: constants.PLAYER_ROLES.DON,
    fouls: 1,
    likes: 3,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Хедин",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 1,
    likes: 1,
    isBest: true,
    extraScores: 0.5
  },{
    name: "Кошка",
    role: constants.PLAYER_ROLES.MAFIA,
    fouls: 0,
    likes: 2,
    isBest: true,
    extraScores: 0.5
  },{
    name: "Марвел",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 0,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  }
  ]
};

const game_10_03_3_1 = {
  referee: "kazzantip",
  date: "2014-03-10",
  result: constants.GAME_RESULT.CITIZENS_WIN,
  firstKilledAtNight: "Хедин",
  firstKilledByDay: "Марвел",
  players:[{
    name: "Дядя Том",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 0,
    likes: 1,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Малика",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 1,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Катафалк",
    role: constants.PLAYER_ROLES.SHERIFF,
    fouls: 0,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Рон",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 0,
    likes: 1,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Соколов",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 1,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  },{
    name: "FrankLin",
    role: constants.PLAYER_ROLES.MAFIA,
    fouls: 3,
    likes: 2,
    isBest: true,
    extraScores: 0.5
  },{
    name: "Агрессор",
    role: constants.PLAYER_ROLES.DON,
    fouls: 1,
    likes: 3,
    isBest: false,
    extraScores: 0.0
  },{
    name: "Хедин",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 1,
    likes: 1,
    isBest: true,
    extraScores: 0.5
  },{
    name: "Кошка",
    role: constants.PLAYER_ROLES.MAFIA,
    fouls: 0,
    likes: 2,
    isBest: true,
    extraScores: 0.5
  },{
    name: "Марвел",
    role: constants.PLAYER_ROLES.CITIZEN,
    fouls: 0,
    likes: 0,
    isBest: false,
    extraScores: 0.0
  }
  ]
};

module.exports = [game_10_03_3, game_10_03_3_1];