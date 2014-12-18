// Generated by CoffeeScript 1.8.0
registerDirective('inventoryManager', {
  restrict: 'E',
  template: '<div class="panel panel-default panel-work" ng-repeat="inventory in inventories" ng-class="{\'panel-success\': inventory.selected}">' + '<div class="panel-heading"><a class="link-default" inventory="{{inventory}}"><p class="text-muted">' + '<small>{{inventory.inventory_values.join(", ")}}</small></p>{{inventory.element_name}}</a></div></div>',
  controller: function($scope, $rootScope, $http, $q) {
    var checkPosition, emit, inventories, setInventories, setPosition, urlBase;
    urlBase = 'https://edocu.service.dev.edocu.local';
    setInventories = (function(_this) {
      return function(inventories) {
        $scope.inventories = inventories;
        if (inventories.length) {
          _this.selectInventory(inventories[0].hash);
        }
      };
    })(this);
    checkPosition = function() {
      var defer;
      defer = $q.defer();
      $http.get(urlBase + '/service/editors/api/v1/elementtypes/' + $scope.element._type + '/isPositional').success(function(response) {
        return defer.resolve(response.positional);
      }).error(function() {
        return defer.resolve(false);
      });
      return defer.promise;
    };
    setPosition = function() {
      var defer;
      defer = $q.defer();
      $http.post(urlBase + '/service/inventory-process/position/register', {
        element: $scope.element.hash
      }).success(function(response) {
        return defer.resolve(response);
      }).error(function() {
        return defer.resolve(false);
      });
      return defer.promise;
    };
    this.selectInventory = function(hash) {
      var selectedInventory;
      selectedInventory = {};
      _.forEach($scope.inventories, function(inventory, key) {
        $scope.inventories[key].selected = inventory.hash === hash ? true : false;
        if (inventory.hash === hash) {
          selectedInventory = infentory;
        }
      });
      if (selectedInventory) {
        return emit('inventory.selected', selectedInventory);
      }
    };
    emit = function(name, attributes) {
      return $rootScope.$emit(name, attributes);
    };
    checkPosition().then(function(isPositional) {
      if (isPositional) {
        return setPosition();
      }
    });
    if ($scope.element && $scope.element.mode && $scope.element.mode.state_date) {
      inventories = $scope.element.mode.state_date.inventories;
    }
    if (inventories) {
      setInventories(inventories);
    }
  }
});

registerDirective('inventory', {
  restrict: 'A',
  require: '^inventoryManager',
  link: function(scope, element, attributes, controller) {
    var inventory;
    inventory = JSON.parse(attributes.inventory);
    if (!inventory.selected) {
      element.bind('click', function() {
        return controller.selectInventory(inventory.hash);
      });
    }
    return this;
  }
});
