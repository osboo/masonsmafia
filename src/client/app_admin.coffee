app = angular.module('adminApp', [])

class BaseController
    constructor: () ->
        for name, value of @ when typeof(value) == 'function' and name != 'constructor'
            do(name, value) =>
                @$scope[name] = (args...) => value.apply(@, args)

class AdminController extends BaseController
    constructor: (@$scope, @$http) ->
        super()
        @$scope.MAX_PLAYER_COUNT = 2
        @$scope.players = []
        @$scope.currentPlayerId = null
        @$scope.wonParty = null
        @$scope.roles = [
            {name: 'Дон'}
            {name: 'Шериф'}
            {name: 'Мафия'}
            {name: 'Горожанин'}
        ]
        @$scope.firstKilledItems = [
            {name: 'Днем'}
            {name: 'Ночью'}
        ]
        @$scope.parties = [
            {name: 'Горожане'}
            {name: 'Мафия'}
        ]

    addPlayer: () ->
        return if not @$scope.currentPlayerId or @$scope.currentPlayerId.length = 0
        @$scope.players.push({id: @$scope.currentPlayerId})

    removePlayer: (playerToRemove) ->
        for player, index in @$scope.players
            continue if player != playerToRemove
            return @$scope.players.splice(index, 1)

    createGame: () ->
        payload =
            result: @$scope.wonParty.id
            players: []
        for player in @$scope.players
            payload.players.push({
                id: player.id
                role: player.role.id
                fallCount: player.fallCount
                likeCount: player.likeCount
                firstKilled: player.firstKilled.id
                bestPlayerScores: player.bestPlayerScores
            })
        @$http.post('/game', payload)

app.controller('admnController', AdminController)