angular.module('ui.directives.apiMessages', ['template/directives/api_messages.html'])
  .directive('apiMessages', ["$compile", "$templateCache", function ($compile, $templateCache) {
    return {
      restrict: 'E',
      replace: true,
      scope: {},
      templateUrl: 'template/directives/api_messages.html',

      link: function(el, attrs, scope){
      },

      controller: ['$scope', '$rootScope', '$element', '$attrs',
        function ($scope, $rootScope, $element, $attrs) {
          $scope.response_header = [];

          $scope.close = function() {
            $scope.response_header = [];
          }

          $rootScope.$on('API-MESSAGES', function(e, data){
            $scope.response_header.push(data);
          });

          $scope.show_error_messages = function() {
            for (var i = $scope.response_header.length - 1; i >= 0; i--) {
              if(($scope.response_header[i].code == 'error' || $scope.response_header[i].code == 'info' || 
                  $scope.response_header[i].code == 'success' || $scope.response_header[i].code == 'model_error') &&
                  $scope.response_header[i].messages.length>0) {
                return true;
              }
            }

            return false;
          }
        }]
    };
  }]);


  angular.module("template/directives/api_messages.html", []).run(["$templateCache", function($templateCache) {
    $templateCache.put(
      "template/directives/api_messages.html",

      '<div class="container-error-messages" ng-show="show_error_messages()">'+
        '<button type="button" class="close" ng-click="close()"><span aria-hidden="true">&times;</span></button>'+

        '<div ng-repeat="container_messages in response_header">'+
          '<div ng-show="container_messages.messages.length>0">'+
            '<div ng-show="container_messages.code==\'error\'" class="alert alert-danger">'+
              '<div ng-repeat="msg in container_messages.messages">{{msg}}</div>'+
            '</div>'+

            '<div ng-show="container_messages.code==\'info\'" class="alert alert-info">'+
              '<div ng-repeat="msg in container_messages.messages">{{msg}}</div>'+
            '</div>'+

            '<div ng-show="container_messages.code==\'success\'" class="alert alert-success">'+
              '<div ng-repeat="msg in container_messages.messages">{{msg}}</div>'+
            '</div>'+

            '<div ng-show="container_messages.code==\'model_error\'" class="model-errors alert alert-danger">'+
              '<strong>Se han producido los siguientes errores:</strong>'+
              '<ul>'+
                '<li ng-repeat="error in container_messages.messages"><strong>{{error.id}}</strong> {{error.title}}</li>'+
              '</ul>'+
            '</div>'+
          '</div>'+
        '</div>'+
      '</div>'
    );
  }]);
