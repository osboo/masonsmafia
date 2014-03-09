(function() {
  var AdminController, BaseController, app, userTypeahead,
    __slice = Array.prototype.slice,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  app = angular.module('adminApp', []);

  BaseController = (function() {

    function BaseController() {
      var name, value,
        _this = this;
      for (name in this) {
        value = this[name];
        if (typeof value === 'function' && name !== 'constructor') {
          (function(name, value) {
            return _this.$scope[name] = function() {
              var args;
              args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
              return value.apply(_this, args);
            };
          })(name, value);
        }
      }
    }

    return BaseController;

  })();

  AdminController = (function(_super) {

    __extends(AdminController, _super);

    function AdminController($scope, $http) {
      this.$scope = $scope;
      this.$http = $http;
      AdminController.__super__.constructor.call(this);
      this.$scope.MAX_PLAYER_COUNT = 2;
      this.$scope.players = [];
      this.$scope.currentPlayer = {};
      this.$scope.wonParty = null;
      this.$scope.roles = [
        {
          name: 'Дон'
        }, {
          name: 'Шериф'
        }, {
          name: 'Мафия'
        }, {
          name: 'Горожанин'
        }
      ];
      this.$scope.firstKilledItems = [
        {
          name: 'Днем'
        }, {
          name: 'Ночью'
        }
      ];
      this.$scope.parties = [
        {
          name: 'Горожане'
        }, {
          name: 'Мафия'
        }
      ];
    }

    AdminController.prototype.addPlayer = function() {
      if (!this.$scope.currentPlayer.id || (this.$scope.currentPlayer.id.length = 0)) {
        return;
      }
      return this.$scope.players.push({
        id: this.$scope.currentPlayer.id
      });
    };

    AdminController.prototype.removePlayer = function(playerToRemove) {
      var index, player, _len, _ref;
      _ref = this.$scope.players;
      for (index = 0, _len = _ref.length; index < _len; index++) {
        player = _ref[index];
        if (player !== playerToRemove) continue;
        return this.$scope.players.splice(index, 1);
      }
    };

    AdminController.prototype.createGame = function() {
      var payload, player, _i, _len, _ref;
      payload = {
        result: this.$scope.wonParty.id,
        players: []
      };
      _ref = this.$scope.players;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        player = _ref[_i];
        payload.players.push({
          id: player.id,
          role: player.role.id,
          fallCount: player.fallCount,
          likeCount: player.likeCount,
          firstKilled: player.firstKilled.id,
          bestPlayerScores: player.bestPlayerScores
        });
      }
      return this.$http.post('/game', payload);
    };

    return AdminController;

  })(BaseController);

  userTypeahead = function() {
    return {
      restrict: 'A',
      scope: {
        currentPlayer: '='
      },
      link: function(scope, element, attrs) {
        var users;
        users = new Bloodhound({
          datumTokenizer: function(item) {
            return Bloodhound.tokenizers.whitespace(item.name);
          },
          queryTokenizer: Bloodhound.tokenizers.whitespace,
          local: [
            {
              name: 'foo',
              id: 1
            }, {
              name: 'bar',
              id: 2
            }
          ]
        });
        users.initialize();
        return element.typeahead(null, {
          displayKey: 'name',
          source: users.ttAdapter()
        }).on('typeahead:selected', function(element, user) {
          return scope.$apply(function() {
            console.log('111111111', scope, user);
            return scope.currentPlayer.id = user.id;
          });
        });
      }
    };
  };

  app.controller('admnController', AdminController);

  app.directive('userTypeahead', userTypeahead);

}).call(this);
