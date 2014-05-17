app = angular.module('adminModule', ['ui.bootstrap'])

@formCtrl = ($scope)->
  $scope.dt = null
  $scope.referee = null
  $scope.winningParty = "Мирные"
  $scope.players = []

  $scope.validate = (players)->
    dict = {'Мирный': 0, 'Шериф': 0, 'Мафия': 0, 'Дон': 0}
    benchmark = {'Мирный': 6, 'Шериф': 1, 'Мафия': 2, 'Дон': 1}
    for player in players
      console.log(player.role)
      ++dict[player.role]
    $scope.gameResultForm.$invalid = (dict != benchmark)

  $scope.submit = ()->
    $scope.validate($scope.players)

@datePickerCtrl = ($scope)->
  $scope.today = ()->
    $scope.$parent.dt = new Date();

  $scope.today();

  $scope.open = ($event)->
    $event.preventDefault();
    $event.stopPropagation();
    $scope.opened = true;

@refereeSelectCtrl = ($scope)->
  $scope.$parent.referee = null

@winPartyCtrl = ($scope)->
  $scope.$parent.winningParty = "Мирные"

@playersTableCtrl = ($scope)->
  $scope.roles = ['Мирный', 'Шериф', 'Мафия', 'Дон']

  $scope.$parent.players = [
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

FLOAT_REGEXP = /^\-?\d+((\.)\d+)?$/
app.directive('smartFloat', ()->
    return {
        require: 'ngModel'
        link: (scope, elm, attrs, ctrl)->
            ctrl.$parsers.unshift((viewValue)->
                if FLOAT_REGEXP.test(viewValue)
                    ctrl.$setValidity('float', true)
                    parseFloat(viewValue.replace(',', '.'))
                else
                    ctrl.$setValidity('float', false)
                    undefined
            )
    }
)

@LogCtrl = ($scope, $log)->
  $scope.$log = $log

$(->
  fetchedNames = new Bloodhound({
        datumTokenizer: (item) -> Bloodhound.tokenizers.whitespace(item.name)
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        limit: 10,
        prefetch: {
            url: '/players',
            filter: (list) ->
                $.map(list, (record) -> {name: record})
        }
  })

  fetchedNames.initialize()
    
  $(".player-name").typeahead(null, {
            displayKey: 'name',
            source: fetchedNames.ttAdapter()
        }
  )

#  fix for css issue with typeahead in bootstrap 3
  $(".twitter-typeahead").css("display", "block")
)