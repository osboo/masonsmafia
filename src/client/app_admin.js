// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const app = angular.module('adminModule', ['ui.bootstrap']);

app.factory('broadCastService', function($rootScope){
  const broadcast = {};
  broadcast.broadCastSubmitEvent = ()=> $rootScope.$broadcast('SubmitEvent');
  return broadcast;
});

app.controller('formCtrl', ['$scope', '$modal', '$http', function($scope, $modal, $http){
  $scope.dt = {value: null};
  $scope.referee = {value: ''};
  $scope.winningParty = {value: 'Мирные'};
  $scope.players = [];
  $scope.firstKilledAtNight = null;
  $scope.firstKilledByDay = null;
  $scope.bestMoveAccuracy = 'не брал лучший ход';
  $scope.errors = [];
  $scope.successMsg = [];
  $scope.previewMsg = [];

  $scope.names = [];
  $http.get('/json/players.json').success(data=> $scope.names = data);

  $scope.openErrorPopup = function(){
    let modalInstance = null;
    return modalInstance = $modal.open({
      templateUrl: 'error_box.html',
      controller: 'popupInstanceCtrl',
      size: 'sm',
      resolve: {
        msgs(){ return $scope.errors; }
      }
    });
  };

  $scope.openPreviewPopup = function(){
    let modalInstance = null;
    return modalInstance = $modal.open({
        templateUrl: 'preview.html',
        controller: 'popupInstanceCtrl',
        size: 'lg',
        resolve: {
          msgs(){ return $scope.previewMsg; }
        }
      }
    );
  };


  $scope.openSuccessPopup = function(){
    let modalInstance = null;
    return modalInstance = $modal.open({
      templateUrl: 'success_box.html',
      controller: 'popupInstanceCtrl',
      size: 'sm',
      resolve: {
        msgs(){ return $scope.successMsg; }
      }
    });
  };

  $scope.getPlayerbyRole = function(role){
    const result = [];
    for (let player of Array.from($scope.players)) {
      if (role === player.role) {
        if ((role === 'Дон') || (role === 'Шериф')) {
          return {name: player.name};
        }
        if (role === 'Мафия') {
          result.push({name: player.name});
        }
      }
    }
    return result;
  };

  $scope.getBestPlayers = function(){
    const result = [];
    for (let player of Array.from($scope.players)) {
      if (player.isBest) {
        result.push({name: player.name, extraScores: player.extraScores});
      }
    }
    return result;
  };

  $scope.getFirstKilledAtNight = function(){
    const foundedAccuracy = ' не брал лучший ход';
    for (let player of Array.from($scope.players)) {
      if (player.name === $scope.firstKilledAtNight) {
        return {name: $scope.firstKilledAtNight, accuracy: $scope.bestMoveAccuracy};
      }
    }
    return {name: $scope.firstKilledAtNight, accuracy: foundedAccuracy};
  };

  $scope.save = function(){
    let player;
    const roleDict = {'Мирный': 0, 'Шериф': 0, 'Мафия': 0, 'Дон': 0};
    $scope.errors = [];
    const namesDict = [];
    if ($scope.firstKilledAtNight === null) { $scope.firstKilledAtNight = ''; }
    if ($scope.firstKilledByDay === null) { $scope.firstKilledByDay = ''; }
    if (($scope.firstKilledAtNight === $scope.firstKilledByDay) && $scope.firstKilledAtNight) {
      $scope.errors.push(`Игрок ${$scope.firstKilledAtNight} убит и днём и ночью`);
    }
    for (player of Array.from($scope.players)) {
      namesDict[player.name] = 0;
    }
    for (player of Array.from($scope.players)) {
      ++roleDict[player.role];
      ++namesDict[player.name];
      if (player.name === $scope.referee.value) {
        $scope.errors.push(`Имя игрока ${player.name} совпадает с именем ведущего`);
      }
    }

    for (let name in namesDict) {
      const count = namesDict[name];
      if (count > 1) {
        $scope.errors.push(`Игрок ${name} встречается больше 1 раза`);
      }
    }

    if (roleDict['Мирный'] !== 6) {
      $scope.errors.push("Мирных должно быть 6");
    }
    if (roleDict['Шериф'] !== 1) {
      $scope.errors.push('Должен быть 1 шериф');
    }
    if (roleDict['Мафия'] !== 2) {
      $scope.errors.push('Должно быть 2 мафии');
    }
    if (roleDict['Дон'] !== 1) {
      $scope.errors.push('Должен быть 1 дон');
    }

    if ($scope.errors.length !== 0) {
      return $scope.openErrorPopup();
    } else {
      $scope.previewMsg = [];
      $scope.previewMsg.push(`Судья: ${$scope.referee.value}`);
      $scope.previewMsg.push(`Дата: ${moment($scope.dt.value).format("DD MMMM YYYY")}`);
      $scope.previewMsg.push(`Победа: ${$scope.winningParty.value}`);
      $scope.previewMsg.push(`Дон: ${$scope.getPlayerbyRole('Дон').name}`);
      $scope.previewMsg.push(`Мафия: ${$scope.getPlayerbyRole('Мафия')[0].name}`);
      $scope.previewMsg.push(`Мафия: ${$scope.getPlayerbyRole('Мафия')[1].name}`);
      $scope.previewMsg.push(`Шериф: ${$scope.getPlayerbyRole('Шериф').name}`);
      $scope.previewMsg.push('Лучшие игроки: ' + ((() => {
        const result = [];
        for (player of Array.from($scope.getBestPlayers())) {           result.push(` ${[player.name, player.extraScores].join(' ')}`);
        }
        return result;
      })()));
      $scope.previewMsg.push(`Убит в первую ночь: ${$scope.getFirstKilledAtNight().name} угадал: ${$scope.getFirstKilledAtNight().accuracy}`);
      $scope.previewMsg.push(`Выведен первым: ${$scope.firstKilledByDay}`);
      return $scope.openPreviewPopup();
    }
  };

  $scope.submit = function(){
    const paper = {
        referee: $scope.referee.value,
        date: moment($scope.dt.value).format("YYYY-MM-DD"),
        result: {"Мирные": "citizens_win", "Мафия": "mafia_win"}[$scope.winningParty.value],
        firstKilledAtNight: $scope.firstKilledAtNight,
        firstKilledByDay: $scope.firstKilledByDay,
        bestMoveAuthor: [0, 1, 2, 3].includes($scope.bestMoveAccuracy) ? $scope.firstKilledAtNight : '',
        bestMoveAccuracy: $scope.bestMoveAccuracy,
        players: []
      };
    for (let player of Array.from($scope.players)) {
      paper.players.push({
        name: player.name,
        role: {"Мирный": "citizen", "Шериф": "sheriff", "Мафия":"mafia", "Дон":"don"}[player.role],
        fouls: player.fouls,
        likes: player.likes,
        isBest: player.isBest,
        extraScores: player.extraScores
      });
    }
    return $http({
      method: "POST",
      url: "/game",
      data: paper
    }).success(function(data, status, headers, config){
      $scope.successMsg = data;
      return $scope.openSuccessPopup();
    }).error(function(data, status, headers, config){
      $scope.errors = data;
      return $scope.openErrorPopup();
    });
  };

  return $scope.$on('SubmitEvent', ()=> $scope.submit());
}
]);

app.controller('popupInstanceCtrl', ['$scope', '$modalInstance', 'msgs', '$window', 'broadCastService', function($scope, $modalInstance, msgs, $window, broadCastService){
  $scope.msgs = msgs;
  $scope.submit = function(){
    broadCastService.broadCastSubmitEvent();
    return $modalInstance.close();
  };
  $scope.cancel = ()=> $modalInstance.dismiss();
  return $scope.refresh = function(){
    $modalInstance.close();
    return $window.location.reload();
  };
}
]);

app.controller('datePickerCtrl', ['$scope', function($scope){
  $scope.today = ()=> $scope.$parent.dt = {value: new Date()};

  $scope.today();

  return $scope.open = function($event){
    $event.preventDefault();
    $event.stopPropagation();
    return $scope.opened = true;
  };
}
]);

app.controller('refereeSelectCtrl', ['$scope', $scope=> $scope.$parent.referee = {value: ''}
]);

app.controller('winPartyCtrl', ['$scope', $scope=> $scope.$parent.winningParty = {value: 'Мирные'}
]);

app.controller('playersTableCtrl', ['$scope', function($scope){
  $scope.roles = ['Мирный', 'Шериф', 'Мафия', 'Дон'];
  $scope.$parent.players = [
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0},
    {role:$scope.roles[0], name: '', fouls: 0, likes: 0, isBest: false, extraScores: 0.0}
  ];

  $scope.overrideCheckbox = current=> $scope.$parent.players[current].isBest = ($scope.$parent.players[current].extraScores > 0.0);

  return $scope.getRoleCSSClass = function(role){
    if (role === 'Мирный') {
      return 'citizen-dropbox-value';
    }
    if (['Мафия', 'Дон'].includes(role)) {
      return 'mafia-dropbox-value';
    }
    if (role === 'Шериф') {
      return 'sheriff-dropbox-value';
    }
  };
}
]);

const FLOAT_REGEXP = /^\-?\d+((\.)\d+)?$/;
app.directive('smartFloat', ()=>
    ({
        require: 'ngModel',
        link(scope, elm, attrs, ctrl){
            return ctrl.$parsers.unshift(function(viewValue){
                if (FLOAT_REGEXP.test(viewValue)) {
                    ctrl.$setValidity('float', true);
                    return parseFloat(viewValue.replace(',', '.'));
                } else {
                    ctrl.$setValidity('float', false);
                    return undefined;
                  }
            });
          }
    })
);

app.controller('LogCtrl', ['$scope', '$log', ($scope, $log)=> $scope.$log = $log
]);

//  document on load:
$(() =>
  $(document).keydown(function(e){
    if ((e.keyCode === 8) && (e.target.tagName.toUpperCase() !== 'INPUT')) {
      return e.preventDefault();
    }
  })
);
