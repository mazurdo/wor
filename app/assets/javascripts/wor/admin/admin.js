//= require wor/commons

//= require wor/ng-file-upload/ng-file-upload-shim
//= require wor/ng-file-upload/ng-file-upload

//= require_self
//= require wor/moment
//= require wor/shared_services
//= require wor/factories
//= require wor/admin/posts/posts_index_ctrl
//= require wor/admin/posts/post_edit_ctrl
//= require wor/admin/versions/versions_index_ctrl
//= require wor/admin/versions/version_detail_ctrl
//= require tinymce
//= require wor/angular-tinymce/tinymce
//= require wor/directives/api_messages
//= require wor/angular-rich-text-diff/google-diff-match-patch
//= require wor/angular-rich-text-diff/angular-rich-text-diff

var factories= angular.module('wor.factories',[]).config(['$httpProvider', function ($httpProvider) {
  $httpProvider.interceptors.push('authInterceptor');
}]);


var wor = angular.module('wor', 
  [ 
    'ui.router',
    'ngSanitize',
    'ngCookies',
    'ngResource',
    'wor.factories',
    'ui.select',
    'ui.bootstrap',
    'ngFileUpload',
    'ui.tinymce',
    'ui.directives.apiMessages',
    'angular-rich-text-diff'
  ])
.constant('_', window._)
.run(['$rootScope', '$location', 'configDataFactory', function($rootScope, $location, configDataFactory) {
  // $rootScope.I18n = window.I18n;
  moment.locale("es");

  $rootScope.urlBase = $location.protocol()+'://'+$location.host()+':'+$location.port();

  configDataFactory.get().success(function(response){
    $rootScope.configData = response;
  });
}]);

wor.config(['$locationProvider', '$stateProvider', '$urlRouterProvider', function($locationProvider, $stateProvider, $urlRouterProvider) {
  // $locationProvider.html5Mode(true);
  $locationProvider.html5Mode({
    enabled: true,
    requireBase: false
  });

  $urlRouterProvider.otherwise('/wor');

  $stateProvider
    .state('posts', {
      url:'/wor/admin/posts/',
      templateUrl: '/templates/wor/admin/posts/index.html',
      controller: 'PostsIndexCtrl',
      reloadOnSearch : false
    })
    .state('posts.detail', {
      url: ':post_id/',
      templateUrl: '/templates/wor/admin/posts/edit.html',
      controller: 'PostDetailCtrl',
      reloadOnSearch : false
    })
    .state('posts.detail.versions', {
      url: 'versions/',
      templateUrl: '/templates/wor/admin/versions/index.html',
      controller: 'VersionsIndexCtrl',
      reloadOnSearch : false
    })
    .state('posts.detail.versions.detail', {
      url: ':version_id/',
      templateUrl: '/templates/wor/admin/versions/detail.html',
      controller: 'VersionDetailCtrl',
      reloadOnSearch : false
    })
    ;
}]);
