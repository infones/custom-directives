
registerDirective 'inventoryManager',

    restrict: 'E'
    template: '<div class="panel panel-default panel-work" ng-repeat="inventory in inventories" ng-class="{\'panel-success\': inventory.selected}">' +
        '<div class="panel-heading"><a class="link-default" inventory="{{inventory}}"><p class="text-muted">' +
        '<small>{{inventory.type}}</small></p>{{inventory.name}}</a></div></div>'

    controller: ($scope, $rootScope, $http, $q) ->
        urlBase = 'https://edocu.service.dev.edocu.local'

        setInventories = (inventories) ->
            $scope.inventories = inventories
            @selectInventory inventories[0].hash if inventories.length is 1
            return

        checkPosition = () ->
            defer = $q.defer()

            $http.get urlBase + '/service/editors/api/v1/elementtypes/' + $scope.element._type + '/isPositional'

            .success (response) ->
                defer.resolve response.positional
            .error ->
                defer.resolve false

            defer.promise;

        setPosition = () ->
            defer = $q.defer()

            $http.post urlBase + '/service/inventory-process/position/register',
                element: $scope.element.hash

            .success (response) ->
                defer.resolve response
            .error ->
                defer.resolve false

            defer.promise;

        @selectInventory = (hash) ->
            $scope.$apply ->
                _.forEach $scope.inventories, (inventory, key) ->
                    $scope.inventories[key].selected = if inventory.hash is hash then true else false
                    return
                return


        @emit = (name, attributes) ->
            $rootScope.$emit name, attributes

        checkPosition().then (isPositional) ->
            setPosition() if isPositional

        setInventories $scope.element.mode.state_date.inventories


registerDirective 'inventory',

    restrict: 'A'
    require: '^inventoryManager'

    link: (scope, element, attributes, controller) ->

        inventory = JSON.parse attributes.inventory

        if not inventory.selected
            element.bind 'click', () ->

                controller.selectInventory inventory.id;
                controller.emit 'inventory.selected', inventory

        @
