
registerDirective 'inventoryElements',

    restrict: 'E'
    template: '<div ng-if="elements.length">' +
        '<h4>{{inventory.name}}</h4>' +
        '<small class="text-muted">Sort by: </small>' +
        '<div class="btn-group" ng-model="filter">' +
            '<button class="btn btn-default btn-sm navbar-btn" value="et"><span class="fa fa-send-o" ng-class="{active: filter === \'et\'"> Element type</span></button>' +
            '<button class="btn btn-default btn-sm navbar-btn" value="it"><span class="fa fa-cubes" ng-class="{active: filter === \'it\'"> Inventory type</span></button>' +
            '<button class="btn btn-default btn-sm navbar-btn" value="is"><span class="fa fa-list" ng-class="{active: filter === \'is\'"> Inventory state</span></button>' +
        '</div>' +
        '<div class="list-group">' +
            '<a href="{{URLconfig.element}}/{{element.id}}" ng-repeat="element in elements | orderBy:sorting:true" class="list-group-item">' +
            '<span ng-if="element.status" class="badge" ng-class="{\'badge-info\': !element.status, \'badge-danger\': (element.status === \'notfound\'), \'badge-warning\': (element.status === \'missplaced\'), \'badge-success\': (element.status === \'placed\')}">{{element.status}}</span>' +
                '{{element.name}}' +
            '</a>' +
        '</div>' +
        '</div>'


    controller: ($scope, $rootScope, $http, $q) ->

        urlBase = 'https://edocu.service.dev.edocu.local'

        mockElements = (id) ->
            one = [
                id: 1
                name: 'biela stolicka'
                type: 'Chair'
                status: 'placed'
                IA: 'Furniture'
            ,
                id: 2
                name: 'stolicka otocneho druhu'
                type: 'Chair'
                status: 'placed'
                IA: 'Furniture'
            ,
                id: 3
                name: 'stol velky'
                type: 'Table'
                IA: 'Furniture'
            ,
                id: 4
                name: 'zelena stolicka'
                type: 'Chair'
                status: 'placed'
                IA: 'Furniture'
            ,
                id: 5
                name: 'biela stolicka'
                type: 'Chair'
                IA: 'Furniture'
            ,
                id: 6
                name: 'vitrina'
                type: 'Cabinet'
                IA: 'Furniture'
            ,
                id: 7
                name: 'modra stolicka'
                type: 'Chair'
                IA: 'Furniture'
            ,
                id: 8
                name: 'skrina'
                type: 'Cabinet'
                status: 'placed'
                IA: 'Furniture'
            ,
                id: 9
                name: 'stolicka otocneho druhu'
                type: 'Chair'
                IA: 'Furniture'
            ]

            another = [
                id: 10
                name: 'tablet 9'
                type: 'Tablet'
                status: 'placed'
                IA: 'Computing technology'
            ,
                id: 11
                name: 'Lenovo IdeaPad 123'
                type: 'Notebook'
                status: 'missplaced'
                IA: 'Computing technology'
            ,
                id: 12
                name: 'vedecky kalkulator 3000'
                type: 'Calculator'
                status: 'notfound'
                IA: 'Computing technology'
            ,
                id: 13
                name: 'Charger'
                type: 'Electronics'
                status: 'notfound'
                IA: 'Other Electronics'
            ,
                id: 14
                name: 'Headphones'
                type: 'Speakers'
                status: 'missplaced'
                IA: 'Other Electronics'
            ,
                id: 15
                name: 'tablet Nexus 9'
                type: 'Tablet'
                status: 'missplaced'
                IA: 'Computing technology'
            ,
                id: 16
                name: 'TV 32'
                type: 'Television'
                status: 'placed'
                IA: 'Other Electronics'
            ,
                id: 17
                name: 'Lenovo IdeaPad 124'
                type: 'Notebook'
                status: 'placed'
                IA: 'Computing technology'
            ,
                id: 18
                name: 'Desktop lamp'
                type: 'Electronics'
                status: 'placed'
                IA: 'Other Electronics'
            ]

            if id %% 2 is 0 then one else another

        getElements = () ->
            defer = $q.defer()

            $http.get urlBase + '/service/inventory/getElements/', options

            .success (response) ->
                defer.resolve response
            .error ->
                defer.resolve false

            defer.promise;

        setElements = (elements) ->
            $scope.$apply ->
                $scope.elements = elements
                return
            return

        $rootScope.$on 'inventory.selected', (event, inventory) ->

            $scope.$apply ->
                $scope.inventory = inventory
                return

            setElements mockElements inventory.id

            return

        # default sorting
        $scope.filter = 'is'
        $scope.sorting = 'status'
        return

