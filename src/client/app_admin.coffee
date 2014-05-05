@adminController = ($scope)->

  $scope.roles = [
    {name: 'Мирный'}
    {name: 'Шериф'}
    {name: 'Мафия'}
    {name: 'Дон'}
  ]

  $scope.players = [
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name:'', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
  ]

  $scope.result = "Мирные"

@LogCtrl = ($scope, $log)->
  $scope.$log = $log

$(->
  $('#datepicker').datepicker({
    format: "dd MM yyyy"
    language: "ru-RU"
  })
  $('#datepicker').datepicker('setDate', new Date())
  $('.selectpicker').selectpicker()
)