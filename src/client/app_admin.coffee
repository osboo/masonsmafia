app = angular.module('adminModule', ['ui.bootstrap'])

@formCtrl = ($scope, $modal, $http)->
  $scope.dt = null
  $scope.referee = {value: ""}
  $scope.winningParty = {value: "Мирные"}
  $scope.players = []
  $scope.firstKilledAtNight = ""
  $scope.firstKilledByDay = ""
  $scope.bestMoveAuthor = ""
  $scope.bestMoveAccuracy = 0
  $scope.errors = []
  $scope.successMsg = []

  $scope.openErrorPopup = ()->
    modalInstance = null
    modalInstance = $modal.open({
      templateUrl: 'error_box.html',
      controller: popupInstanceCtrl,
      size: 'sm'
      resolve: {
        msgs: ()-> $scope.errors
      }
    })

  $scope.openSuccessPopup = ()->
    modalInstance = $modal.open({
      templateUrl: 'success_box.html',
      controller: popupInstanceCtrl,
      size: 'sm'
      resolve: {
        msgs: ()-> $scope.successMsg
      }
    })

  $scope.submit = ()->
    dict = {'Мирный': 0, 'Шериф': 0, 'Мафия': 0, 'Дон': 0}
    noBestPlayers = true
    $scope.errors = []
    for player in $scope.players
      ++dict[player.role]
      if player.isBest
        noBestPlayers = false
    if dict['Мирный'] != 6
      $scope.errors.push("мирных должно быть 6")
    if dict['Шериф'] != 1
      $scope.errors.push('должен быть 1 шериф')
    if dict['Мафия'] != 2
      $scope.errors.push('должно быть 2 мафии')
    if dict['Дон'] != 1
      $scope.errors.push('должен быть 1 дон')
    if noBestPlayers
      $scope.errors.push('в игре отсутствуют лучшие игроки')

    if $scope.errors.length != 0
      $scope.openErrorPopup()
    else
      paper = {
        referee: $scope.referee.value
        date: moment($scope.dt).format("YYYY-MM-DD")
        result: {"Мирные": "citizens_win", "Мафия": "mafia_win"}[$scope.winningParty.value]
        firstKilledAtNight: $scope.firstKilledAtNight
        firstKilledByDay: $scope.firstKilledByDay
        bestMoveAuthor: $scope.bestMoveAuthor
        bestMoveAccuracy: $scope.bestMoveAccuracy
        players: []
      }
      for player in $scope.players
        paper.players.push({
          name: player.name
          role: {"Мирный": "citizen", "Шериф": "sheriff", "Мафия":"mafia", "Дон":"don"}[player.role]
          fouls: player.fouls
          likes: player.likes
          isBest: player.isBest
          extraScores: player.extraScores
        })
      $http({
        method: "POST"
        url: "/game"
        data: paper
      }).success((data, status, headers, config)->
        $scope.successMsg = data
        $scope.openSuccessPopup()
      ).error((data, status, headers, config)->
        $scope.errors = data
        $scope.openErrorPopup()
      )


popupInstanceCtrl = ($scope, $modalInstance, msgs, $window)->
  $scope.msgs = msgs
  $scope.ok = ()->
    $modalInstance.close()
  $scope.refresh = ()->
    $modalInstance.close()
    $window.location.reload()


@datePickerCtrl = ($scope)->
  $scope.today = ()->
    $scope.$parent.dt = new Date();

  $scope.today();

  $scope.open = ($event)->
    $event.preventDefault();
    $event.stopPropagation();
    $scope.opened = true;

@refereeSelectCtrl = ($scope)->
  $scope.$parent.referee = {value: ""}

@winPartyCtrl = ($scope)->
  $scope.$parent.winningParty = {value: "Мирные"}

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
