angular.module('wor.factories')
  .factory('authInterceptor', ['$rootScope', '$q', '$window', '$injector', function ($rootScope, $q, $window, $injector) {

    return {
      request: function (config) {
        // config.headers = config.headers || {};
        // if ($window.sessionStorage.token) {
        //   config.headers.Authorization = $window.sessionStorage.token;
        // }

        return config;
      },

      response: function(response) {
        if (response.data.header && response.data.header.code!=null) {
          $rootScope.$emit('API-MESSAGES', response.data.header);
        }

        return response;
      },

      responseError: function(response) {
        if (response.status === 401) {
          // handle the case where the user is not authenticated
          // console.log('401 -> Unauthorized');

          $window.location = login_path;
        } else {
          if (response.data.header && response.data.header.code!=null) {
            $rootScope.$emit('API-MESSAGES', response.data.header);
          }
        }

        // // do something on error
        // if (canRecover(rejection)) {
        //   return responseOrNewPromise
        // }
        return $q.reject(response);
      }

    };
  }])
  .factory('postsFactory', ['$http', '$rootScope', function ($http, $rootScope){
    var factory = {};

    factory.find = function (params) {
      return $http.get($rootScope.urlBase + '/wor/api/v1/posts.json', {params: params});
    }

    factory.update = function (post) {
      return $http.put($rootScope.urlBase + '/wor/api/v1/posts/'+post.id+'.json', post); 
    }

    factory.create = function (post) {
      return $http.post($rootScope.urlBase + '/wor/api/v1/posts.json', post);
    }

    factory.get = function (id) {
      return $http.get($rootScope.urlBase + '/wor/api/v1/posts/'+id+'.json');
    }

    factory.delete = function (post_id) {
      return $http.delete($rootScope.urlBase + '/wor/api/v1/posts/'+post_id+'.json');
    }

    return factory;    
  }])
  .factory('classifiersFactory', ['$http', '$rootScope', function ($http, $rootScope){
    var factory = {};

    factory.find = function (params) {
      return $http.get($rootScope.urlBase + '/wor/api/v1/classifiers.json', {params: params});
    }

    return factory;    
  }])
  .factory('usersFactory', ['$http', '$rootScope', function ($http, $rootScope){
    var factory = {};

    factory.find = function (params) {
      return $http.get($rootScope.urlBase + '/wor/api/v1/users.json', {params: params});
    }

    return factory;    
  }])
  .factory('versionsFactory', ['$http', '$rootScope', function ($http, $rootScope){
    var factory = {};

    factory.find = function (params) {
      return $http.get($rootScope.urlBase + '/wor/api/v1/versions.json', {params: params});
    }

    return factory;    
  }])
;