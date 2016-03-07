(function () {
  var PostsIndexCtrl = function ($scope, $rootScope, $timeout, $state, $location, postsFactory, classifiersFactory, usersFactory) {
    $scope.data   = $scope.data || {};
    $scope.filter = $scope.filter || {};
    $scope.data.statuses = [{id:'published', name: 'Publicado'}, {id: 'draft', name: 'Borrador'}];


    classifiersFactory.find({classifier_type: 'tag'}).success(function(response){
      $scope.data.tags = response.data;
    });

    classifiersFactory.find({classifier_type: 'category'}).success(function(response){
      $scope.data.categories = response.data;
    });

    usersFactory.find().success(function(response){
      $scope.data.users = response.data;
    });


    $scope.filter_table = function() {
      if(!$scope.data.pagination) {
        $scope.filter.page = 1;
      } else {
        $scope.filter.page = $scope.data.pagination.current_page;
      }

      postsFactory.find($scope.filter).success(function(response){
        $scope.data.pagination = response.header.pagination;
        $scope.data.posts      = response.data;
      });
    }

    $scope.update_table = function() {
      if (typeof(timeout) !== 'undefined') {
        $timeout.cancel(timeout);
      }
      timeout = $timeout(function(){$scope.filter_table();}, 400);
    }

    $scope.page_changed = function() {
      $scope.filter_table();
    }

    $scope.create = function() {
      postsFactory.create({}).success(function(response){
        $scope.open_detail(response.data);
      });
    }

    $scope.filter_table();

    $scope.open_detail = function(post) {
      $scope.data.post = post;
      $state.go('posts.detail', {post_id: post.id});
    }

    $scope.$on('$destroy', function() {
      reload_posts();
    });       

    reload_posts =  $scope.$on('WOR-RELOAD_POSTS', function(e, data){
      $scope.filter_table();
    });

    $scope.post_date = function(post) {
      if (moment().diff(moment(post.date), 'days')<1) {
        return moment(post.date).fromNow();
      } else {
        return moment(post.date).format('DD/MM/YYYY');
      }
    }


    $(document).ready(function(){
      $('.input-daterange').datepicker({
        format: "dd/mm/yy",
        language: "es",
        orientation: "top right",
        autoclose: true,
        toggleActive: true,
        todayHighlight: true
      });
    });
  }

  angular.module('wor').controller('PostsIndexCtrl', ["$scope", "$rootScope", "$timeout", "$state", "$location", "postsFactory", "classifiersFactory", "usersFactory", PostsIndexCtrl]);
}());
