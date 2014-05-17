app = angular.module('adminModule', ['ui.bootstrap'])

@datePickerCtrl = ($scope)->
  $scope.today = ()->
    $scope.dt = new Date();

  $scope.today();

  $scope.open = ($event)->
    $event.preventDefault();
    $event.stopPropagation();
    $scope.opened = true;

@refereeSelectCtrl = ($scope)->
  $scope.referee = null

@winPartyCtrl = ($scope)->
  $scope.winningParty = "Мирные"

@playersTableCtrl = ($scope)->
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