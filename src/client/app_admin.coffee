app = angular.module('adminModule', ['ui.bootstrap'])

app.factory('broadCastService', ($rootScope)->
  broadcast = {}
  broadcast.broadCastSubmitEvent = ()->
    $rootScope.$broadcast('SubmitEvent')
  return broadcast
)

app.controller('formCtrl', ['$scope', '$modal', '$http', ($scope, $modal, $http)->
  $scope.dt = {value: null}
  $scope.referee = {value: ''}
  $scope.winningParty = {value: 'Мирные'}
  $scope.players = []
  $scope.firstKilledAtNight = null
  $scope.firstKilledByDay = null
  $scope.bestMoveAccuracy = 'не брал лучший ход'
  $scope.errors = []
  $scope.successMsg = []
  $scope.previewMsg = []

  $scope.names = []
  $http.get('/json/players.json').success((data)->
    $scope.names = data
  )

  $scope.openErrorPopup = ()->
    modalInstance = null
    modalInstance = $modal.open({
      templateUrl: 'error_box.html',
      controller: 'popupInstanceCtrl',
      size: 'sm'
      resolve: {
        msgs: ()-> $scope.errors
      }
    })

  $scope.openPreviewPopup = ()->
    modalInstance = null
    modalInstance = $modal.open({
        templateUrl: 'preview.html',
        controller: 'popupInstanceCtrl',
        size: 'lg',
        resolve: {
          msgs: ()-> $scope.previewMsg
        }
      }
    )


  $scope.openSuccessPopup = ()->
    modalInstance = null
    modalInstance = $modal.open({
      templateUrl: 'success_box.html',
      controller: 'popupInstanceCtrl',
      size: 'sm'
      resolve: {
        msgs: ()-> $scope.successMsg
      }
    })

  $scope.getPlayerbyRole = (role)->
    result = []
    for player in $scope.players
      if role == player.role
        if role == 'Дон' or role == 'Шериф'
          return {name: player.name}
        if role == 'Мафия'
          result.push({name: player.name})
    return result

  $scope.getBestPlayers = ()->
    result = []
    for player in $scope.players
      if player.isBest
        result.push({name: player.name, extraScores: player.extraScores})
    return result

  $scope.getFirstKilledAtNight = ()->
    foundedAccuracy = ' не брал лучший ход'
    for player in $scope.players
      if player.name == $scope.firstKilledAtNight
        return {name: $scope.firstKilledAtNight, accuracy: $scope.bestMoveAccuracy}
    return {name: $scope.firstKilledAtNight, accuracy: foundedAccuracy}

  $scope.save = ()->
    roleDict = {'Мирный': 0, 'Шериф': 0, 'Мафия': 0, 'Дон': 0}
    $scope.errors = []
    namesDict = []
    if $scope.firstKilledAtNight == null then $scope.firstKilledAtNight = ''
    if $scope.firstKilledByDay == null then $scope.firstKilledByDay = ''
    if $scope.firstKilledAtNight == $scope.firstKilledByDay && $scope.firstKilledAtNight
      $scope.errors.push("Игрок #{$scope.firstKilledAtNight} убит и днём и ночью")
    for player in $scope.players
      namesDict[player.name] = 0
    for player in $scope.players
      ++roleDict[player.role]
      ++namesDict[player.name]
      if player.name == $scope.referee.value
        $scope.errors.push("Имя игрока #{player.name} совпадает с именем ведущего")

    for name, count of namesDict
      if count > 1
        $scope.errors.push("Игрок #{name} встречается больше 1 раза")

    if roleDict['Мирный'] != 6
      $scope.errors.push("Мирных должно быть 6")
    if roleDict['Шериф'] != 1
      $scope.errors.push('Должен быть 1 шериф')
    if roleDict['Мафия'] != 2
      $scope.errors.push('Должно быть 2 мафии')
    if roleDict['Дон'] != 1
      $scope.errors.push('Должен быть 1 дон')

    if $scope.errors.length != 0
      $scope.openErrorPopup()
    else
      $scope.previewMsg = []
      $scope.previewMsg.push('Судья: ' + $scope.referee.value)
      $scope.previewMsg.push('Дата: ' + moment($scope.dt.value).format("DD MMMM YYYY"))
      $scope.previewMsg.push('Победа: ' + $scope.winningParty.value)
      $scope.previewMsg.push('Дон: ' + $scope.getPlayerbyRole('Дон').name)
      $scope.previewMsg.push('Мафия: ' + $scope.getPlayerbyRole('Мафия')[0].name)
      $scope.previewMsg.push('Мафия: ' + $scope.getPlayerbyRole('Мафия')[1].name)
      $scope.previewMsg.push('Шериф: ' + $scope.getPlayerbyRole('Шериф').name)
      $scope.previewMsg.push('Лучшие игроки: ' + (' ' + [player.name, player.extraScores].join(' ') for player in $scope.getBestPlayers()))
      $scope.previewMsg.push('Убит в первую ночь: ' + $scope.getFirstKilledAtNight().name + ' угадал: ' + $scope.getFirstKilledAtNight().accuracy)
      $scope.previewMsg.push('Выведен первым: ' + $scope.firstKilledByDay)
      $scope.openPreviewPopup()

  $scope.submit = ()->
    paper = {
        referee: $scope.referee.value
        date: moment($scope.dt.value).format("YYYY-MM-DD")
        result: {"Мирные": "citizens_win", "Мафия": "mafia_win"}[$scope.winningParty.value]
        firstKilledAtNight: $scope.firstKilledAtNight
        firstKilledByDay: $scope.firstKilledByDay
        bestMoveAuthor: if $scope.bestMoveAccuracy in [0, 1, 2, 3] then $scope.firstKilledAtNight else ''
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

  $scope.$on('SubmitEvent', ()->
    $scope.submit()
  )
])

app.controller('popupInstanceCtrl', ['$scope', '$modalInstance', 'msgs', '$window', 'broadCastService', ($scope, $modalInstance, msgs, $window, broadCastService)->
  $scope.msgs = msgs
  $scope.submit = ()->
    broadCastService.broadCastSubmitEvent()
    $modalInstance.close()
  $scope.cancel = ()->
    $modalInstance.dismiss()
  $scope.refresh = ()->
    $modalInstance.close()
    $window.location.reload()
])

app.controller('datePickerCtrl', ['$scope', ($scope)->
  $scope.today = ()->
    $scope.$parent.dt = {value: new Date()};

  $scope.today();

  $scope.open = ($event)->
    $event.preventDefault();
    $event.stopPropagation();
    $scope.opened = true;
])

app.controller('refereeSelectCtrl', ['$scope', ($scope)->
  $scope.$parent.referee = {value: ''}
])

app.controller('winPartyCtrl', ['$scope', ($scope)->
  $scope.$parent.winningParty = {value: 'Мирные'}
])

app.controller('playersTableCtrl', ['$scope', ($scope)->
  $scope.roles = ['Мирный', 'Шериф', 'Мафия', 'Дон']
  $scope.$parent.players = [
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
  ]

  $scope.overrideCheckbox = (current)->
    $scope.$parent.players[current].isBest = ($scope.$parent.players[current].extraScores > 0.0)

  $scope.getRoleCSSClass = (role)->
    if role == 'Мирный'
      return 'citizen-dropbox-value'
    if role in ['Мафия', 'Дон']
      return 'mafia-dropbox-value'
    if role == 'Шериф'
      return 'sheriff-dropbox-value'
])

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

app.controller('LogCtrl', ['$scope', '$log', ($scope, $log)->
  $scope.$log = $log
])

#  document on load:
$(->
  $(document).keydown((e)->
    if e.keyCode == 8 and e.target.tagName.toUpperCase() != 'INPUT'
      e.preventDefault()
  )
)
