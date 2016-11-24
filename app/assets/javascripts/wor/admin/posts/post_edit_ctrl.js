(function () {
  var PostDetailCtrl = function ($scope, $rootScope, $timeout, $state, $stateParams, $location, $filter, Upload, postsFactory, classifiersFactory, usersFactory) {

    $scope.data = $scope.data || {};
    $scope.data.cover_image_url = '/assets/wor/no-photo-grey.png';

    var load_post = function(post_id) {
      if (post_id) {
        postsFactory.get(post_id).success(function(response){
          $scope.data.post = response.data;

          if ($scope.data.post.cover_image_url!='') {
            $scope.data.cover_image_url = $scope.data.post.cover_image_url+'?' + new Date().getTime();
          }

          if ($scope.data.post.publication_date) {
            $scope.data.post.publication_date_formated = moment($scope.data.post.publication_date).format('YYYY-MM-DD');
            $scope.data.post.publication_hour_formated = moment($scope.data.post.publication_date).format('HH:mm');
          }

          classifiersFactory.find({classifier_type: 'tag'}).success(function(response){
            $scope.data.post.tags = _.intersectionBy(response.data, $scope.data.post.classifiers, 'id');
            $scope.data.tags = _.uniq(_.map(response.data, 'name'));
            $scope.data.post.tags = _.uniq(_.map($scope.data.post.tags, 'name'));
          });
        });
      }
    }

    load_post($stateParams.post_id);

    $scope.tinymceOptions = {
      setup: function(editor) {
        editor.on("init", function() {});
        editor.on("click", function() {});
      },
      plugins : 'advlist autolink link image media lists charmap print code table fullscreen visualblocks',
      skin: 'wor',
      theme : 'modern',
      toolbar1: 'bold italic strikethrough bullist numlist blockquote| styleselect | alignleft aligncenter alignright alignjustify | outdent indent | link unlink | image media | table | removeformat visualblocks | fullpage | code fullscreen',
      toolbar2: 'styleselect shorcodes_button read_more',
      menubar: false,
      visualblocks_default_state: true,
      end_container_on_empty_block: true,
      entity_encoding : 'raw',
      relative_urls: false,
      height: 600,
      style_formats: [
        { title: 'h1', block: 'h1' },
        { title: 'h2', block: 'h2' },
        { title: 'h3', block: 'h3' },
        { title: 'h4', block: 'h4' },
        { title: 'h5', block: 'h5' },
        { title: 'h6', block: 'h6' }
      ]
      ,
      setup: function(editor) {
        editor.addButton('shorcodes_button', {
          type: 'menubutton',
          text: 'Shortcodes',
          icon: false,
          menu: [
            {text: 'Widget modelo', onclick: function() {editor.insertContent('[qm_widget_modelo modelo=SLUGMODELO flotar=derecha]');}},
            {text: 'Enlace grande para ofertas de un modelo', onclick: function() {editor.insertContent('[qm_widget_offerprice_link modelo=SLUGMODELO mensaje_con_precio=no]');}},
            {text: 'Enlace pequeño para ofertas de modelo', onclick: function() {editor.insertContent('[qm_widget_popup_offer_link modelo=SLUGMODELO texto="TEXTO"]');}},
            {text: 'Widget comparativa', onclick: function() {editor.insertContent('[qm_widget_comparativa_modelos slug1=SLUGMODELO1 slug2=SLUGMODELO2 slug3=SLUGMODELO3 ]');}},
          ]
        });

        editor.addButton( 'read_more', {
          text: 'Insertar etiqueta "Leer más"',
          icon: false,
          onclick: function() {
            editor.insertContent('<!--more-->');
          }
        });

        editor.on('BeforeSetcontent', function(event){
          if (event.content) {
            event.content = event.content.replace(/<!--more(.*?)-->/g, '<img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" class="tinymce_more"/>');
          }
        });

        editor.on('PostProcess', function(event){
          if (event.content) {
            event.content = event.content.replace(/<img[^>]+>/g, function(im) {
              if (im.indexOf('class="tinymce_more') !== -1) {
                im = '<!--more-->';
              }
              return im;
            });
          }
        });
      },

      file_picker_callback : function (callback, value, meta) {
        tinymce.activeEditor.windowManager.open({
          file: '/wor/elfinder_manager/',// use an absolute path!
          title: 'Images explorer',
          width: 900,
          height: 450,
          resizable: 'yes'
        }, {
          oninsert: function (file, elf) {
            var url, reg, info;

            // URL normalization
            url = file.url;
            reg = /\/[^/]+?\/\.\.\//;
            while(url.match(reg)) {
              url = url.replace(reg, '/');
            }

            url = $rootScope.urlBase+url;

            // Provide file and text for the link dialog
            if (meta.filetype == 'file') {
              callback(url, {text: info, title: info});
            }

            // Provide image and alt text for the image dialog
            if (meta.filetype == 'image') {
              callback(url, {alt: info});
            }

            // Provide alternative source and posted for the media dialog
            if (meta.filetype == 'media') {
              callback(url);
            }
          }
        }
        );
        return false;
      }
    }

    classifiersFactory.find({classifier_type: 'category'}).success(function(response){
      $scope.data.categories = response.data;
    });

    usersFactory.find().success(function(response){
      $scope.data.users = response.data;
    });

    $scope.save = function(status) {
      var _post = _.clone($scope.data.post, true);

      _post.status = status;
      _post.publication_date = _post.publication_date_formated+' '+_post.publication_hour_formated;

      postsFactory.update(_post).success(function(response){
        $scope.$emit('WOR-RELOAD_POSTS');
        load_post($scope.data.post.id);
      });
    }

    $scope.close = function() {
      $('.post-view').addClass('animated slideOutDown');
      timeout = $timeout(function(){
        $state.go($state.$current.parent);
        $scope.data.post = {};
      }, 200);
    }

    $scope.upload = function (file) {
      if (file) {
        $scope.data.progress_upload_file = 0;
        $scope.data.is_upload_file = true;

        Upload.upload({
          url: $rootScope.urlBase+'/wor/api/v1/posts/'+$scope.data.post.id+'/upload_cover_image.json',
          fields: $scope.data.post,
          file: file

        }).progress(function (evt) {
          $scope.data.progress_upload_file = parseInt(100.0 * evt.loaded / evt.total);

        }).success(function (response, status, headers, config) {
          $scope.data.progress_upload_file = 100;
          $scope.data.is_upload_file = false;
          $scope.data.post.cover_image_url = response.data.cover_image_url;

          if ($scope.data.post.cover_image_url!='') {
            $scope.data.cover_image_url = $scope.data.post.cover_image_url+'?' + new Date().getTime();
          }

        }).error(function (data, status, headers, config) {
            console.log('error status: ' + status);
            $scope.data.is_upload_file = false;
        });
      }
    };

    $scope.delete = function() {
      if (confirm("¿Estás seguro de eliminar este post?")) {
        postsFactory.delete($scope.data.post.id).success(function(response){
          $scope.$emit('WOR-RELOAD_POSTS');
          $scope.close();
        });
      }
    }

    $scope.preview = function() {
      window.open($scope.data.post.draft_path)
    }

    $scope.force_show_slug = false;
    $scope.set_show_slug = function(force) {
      $scope.force_show_slug = force;
    }

    $scope.is_show_slug = function() {
      if ($scope.force_show_slug) { return $scope.force_show_slug }
      if ($scope.data.post && $scope.data.post.status=='published') {return false;}

      return true;
    }

    $scope.is_published = function() {
      if ($scope.data.post)
        return $scope.data.post.status == 'published';
    }

    $(document).ready(function(){
      $('.input-date').datepicker({
        format: "yyyy-mm-dd",
        language: "es",
        orientation: "top right",
        autoclose: true,
        toggleActive: true,
        todayHighlight: true
      });
    });
  }

  angular.module('wor').controller('PostDetailCtrl', ["$scope", "$rootScope", "$timeout", "$state", "$stateParams", "$location", "$filter", "Upload", "postsFactory", "classifiersFactory", "usersFactory", PostDetailCtrl]);
}());
