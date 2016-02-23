(function () {
  var VersionDetailCtrl = function ($scope, $rootScope, $timeout, $state, $stateParams, $location, versionsFactory) {
    $scope.data = $scope.data || {};

    $scope.close = function() {
      $('#version-view').addClass('animated bounceOutRight');
      timeout = $timeout(function(){
        $state.go($state.$current.parent);
      }, 200);
    }
  }

  angular.module('wor').controller('VersionDetailCtrl', ["$scope", "$rootScope", "$timeout", "$state", "$stateParams", "$location", "versionsFactory", VersionDetailCtrl]);
}());
