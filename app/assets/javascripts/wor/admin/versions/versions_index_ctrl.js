(function () {
  var VersionsIndexCtrl = function ($scope, $rootScope, $timeout, $state, $stateParams, $location, versionsFactory) {
    $scope.data   = $scope.data || {};

    versionsFactory.find({post_id: $stateParams.post_id}).success(function(response){
      $scope.data.versions = response.data;
    });

    $scope.open_detail = function(version) {
      $scope.data.version = version;
      $state.go('posts.detail.versions.detail', {version_id: version.id});
    }

    $scope.close = function() {
      $('#versions-view').addClass('animated bounceOutRight');
      timeout = $timeout(function(){
        $state.go($state.$current.parent);
      }, 200);
    }
  }

  angular.module('wor').controller('VersionsIndexCtrl', ["$scope", "$rootScope", "$timeout", "$state", "$stateParams", "$location", "versionsFactory", VersionsIndexCtrl]);
}());
