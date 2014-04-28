@adminController = ($scope)->
  $scope.players = [
    {idx: 1, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 2, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 3, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 4, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 5, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 6, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 7, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 8, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx: 9, name:'', fouls: 0, likes: 0, extraScores: 0.0}
    {idx:10, name:'', fouls: 0, likes: 0, extraScores: 0.0}
  ]

  $scope.roles = [
    {name: 'Мирный'}
    {name: 'Шериф'}
    {name: 'Мафия'}
    {name: 'Дон'}
  ]

$(->
  $('#datepicker').datepicker({
    format: "dd MM yyyy"
    language: 'ru'
  })
  $('#datepicker').datepicker('setDate', new Date())
)