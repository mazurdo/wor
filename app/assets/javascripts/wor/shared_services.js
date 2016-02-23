wor.config(['$httpProvider', function ($httpProvider) {
  $httpProvider.interceptors.push('httpInterceptor');
}]);

wor.factory('httpInterceptor', ['$q', '$rootScope', '$location', '$timeout',
  function ($q, $rootScope, $location, $timeout) {

    var pendingRequests = 0;
    return {
      request: function(config) {
      pendingRequests++;
      $('#loading').show();
      return config || $q.when(config);
    },
    response: function(response) {
      $timeout(function(){
        if ((--pendingRequests) === 0) $('#loading').hide();
      }, 200);

      return response || $q.when(response);
    },
    responseError: function(response) {
      $timeout(function(){
        if ((--pendingRequests) === 0) $('#loading').hide();
      }, 200);

      return $q.reject(response);
    }
  }
}]);
