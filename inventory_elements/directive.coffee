
registerDirective 'inventoryElements',

    restrict: 'E'
    template: '<div ng-if="elements.length">' +
        '<h4>{{inventory.name}}</h4>' +

        '<span>Sort by: </span>' +
        '<div class="btn-group">' +
            '<button class="btn btn-default btn-sm navbar-btn" ng-click="sort(\'type\')" ng-class="{\'active\': sorting === \'type\'}"><span class="fa fa-send-o"> Element type</span></button>' +
            '<button class="btn btn-default btn-sm navbar-btn" ng-click="sort(\'status\')" ng-class="{\'active\': sorting === \'status\'}"><span class="fa fa-list"> Inventory state</span></button>' +
        '</div>' +

        '<div class="list-group">' +
            '<a href="{{URLconfig.element}}/{{element.hash}}" ng-repeat="element in elements | orderBy:sorting:true" class="list-group-item">' +
            '<span ng-if="element.status" class="badge" ng-class="{\'badge-info\': !element.status, \'badge-danger\': (element.status === \'notfound\'), \'badge-warning\': (element.status === \'misplaced\'), \'badge-success\': (element.status === \'placed\')}">{{element.status}}</span>' +
                '{{element.element_name}}' +
            '</a>' +
        '</div>' +
    '</div>'



    controller: ($scope, $rootScope, $http, $q) ->

        urlBase = 'https://edocu.service.dev.edocu.local'

        # default sorting
        $scope.sorting = 'status'
        $scope.sortingOrder = true

        getElements = (hash) ->
            defer = $q.defer()

            $http.get urlBase + '/service/inventory-process/inventory/' + hash + '/elements?element=' + $scope.element.hash

            .success (response) ->
                defer.resolve response
            .error ->
                defer.resolve false

            defer.promise;

        setElements = (elements) ->
            $scope.elements = elements
            return

        $rootScope.$on 'inventory.selected', (event, inventory) ->

            $scope.$apply ->
                $scope.inventory = inventory
                return

            getElements inventory.hash
            .then (elements) ->
                setElements(elements)

            return

        $scope.sort = (sortBy) ->
            if $scope.sorting is sortBy
                $scope.sortingOrder = !$scope.sortingOrder
            else
                $scope.sorting = sortBy

        return

