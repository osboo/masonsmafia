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
        @$scope.currentPlayer = {}
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
        return if not @$scope.currentPlayer.id or @$scope.currentPlayer.id.length = 0
        @$scope.players.push({id: @$scope.currentPlayer.id})

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
                likes: player.likes
                firstKilled: player.firstKilled.id
                bestPlayerScores: player.bestPlayerScores
            })
        @$http.post('/game', payload)

userTypeahead = () ->
    restrict: 'A'
    scope:
        currentPlayer: '='
    link: (scope, element, attrs) ->
        users = new Bloodhound({
            datumTokenizer: (item) -> Bloodhound.tokenizers.whitespace(item.name)
            queryTokenizer: Bloodhound.tokenizers.whitespace
            local: [
                {name: 'foo', id: 1}
                {name: 'bar', id: 2}
            ]
        })
        users.initialize()
        element.typeahead(null, {
            displayKey: 'name'
            source: users.ttAdapter()
        }).on('typeahead:selected', (element, user) ->
            scope.$apply(() ->
                console.log '111111111', scope, user
                scope.currentPlayer.id = user.id
            )
        )

app.controller('admnController', AdminController)
app.directive('userTypeahead', userTypeahead)