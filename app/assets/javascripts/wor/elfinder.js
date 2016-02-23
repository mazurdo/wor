//= require wor/elfinder/jquery/jquery-1.8.1.min.js
//= require wor/elfinder/jquery/jquery-ui-1.8.23.custom.min.js
//= require wor/elfinder/elfinder.min.js
//= require wor/elfinder/proxy/elFinderSupportVer1.js

// $(function() {
//   var rails_csrf = {};
//   rails_csrf[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');

//   $('#elfinder').elfinder({
//     lang: 'en',
//     height: '600',
//     url: '/wor/elfinder',
//     transport : new elFinderSupportVer1(),
//     customData: rails_csrf,
//   });
// });





      var FileBrowserDialogue = {
        init: function() {
          // Here goes your code for setting your custom things onLoad.
        },

//     mySubmit: function (URL) {

// console.log(URL);

//       // pass selected file path to TinyMCE
//       parent.tinymce.activeEditor.windowManager.getParams().setUrl(URL);

//       // force the TinyMCE dialog to refresh and fill in the image dimensions
//       var t = parent.tinymce.activeEditor.windowManager.windows[0];
//       t.find('#src').fire('change');

//       // close popup window
//       parent.tinymce.activeEditor.windowManager.close();
//     }

        mySubmit: function (file, fm) {

console.log(file);
console.log(fm);

          // pass selected file data to TinyMCE
          parent.tinymce.activeEditor.windowManager.getParams().oninsert(file, fm);
          // close popup window
          parent.tinymce.activeEditor.windowManager.close();
        }
      }
      // disable HTML quicklook plugin
      elFinder.prototype.commands.quicklook.plugins[1] = null;
      // Documentation for client options:
      // https://github.com/Studio-42/elFinder/wiki/Client-configuration-options
      $().ready(function() {
        var elfinderInstance = $('#elfinder').elfinder({
          resizable: false,
          height: $(window).height() - 20,
          ui  : ['toolbar', 'places', 'tree', 'path', 'stat'],
          url : '/wor/elfinder/',  // connector URL (REQUIRED)
          transport : new elFinderSupportVer1(),
          getFileCallback: function(file) { // editor callback
            // file.url - commandsOptions.getfile.onlyURL = false (default)
            // file     - commandsOptions.getfile.onlyURL = true (best with this alternative code)
            FileBrowserDialogue.mySubmit(file, elfinderInstance); // pass selected file path to TinyMCE 
          },
// commands : [
//   'open', 'reload', 'getfile', 'quicklook', 'download', 'rm', 'rename', 'mkdir', 'upload', 'search', 'info', 'view'
// ],
commandsOptions: {
    getfile : {
        // send only URL or URL+path if false
        onlyURL  : false,
        // allow to return multiple files info
        multiple : false,
        // allow to return folders info
        folders  : false,
        // action after callback (close/destroy)
        oncomplete : ''
    },
},

uiOptions : {
    // toolbar configuration
    toolbar : [
        // ['back', 'forward'],
        // ['reload'],
        // ['home', 'up'],
        ['mkdir', 'upload'],
        ['open', 'download', 'getfile'],
        ['info'],
        ['quicklook'],
        // ['copy', 'cut', 'paste'],
        ['rm'],
        // ['duplicate', 'rename', 'edit', 'resize'],
        // ['extract', 'archive'],
        ['search'],
        ['view'],
        // ['help']
    ],

    // directories tree options
    // tree : {
    //     // expand current root on init
    //     openRootOnLoad : true,
    //     // auto load current dir parents
    //     syncTree : true
    // },

    // navbar options
    // navbar : {
    //     minWidth : 150,
    //     maxWidth : 500
    // },

    // current working directory options
    // cwd : {
    //     // display parent directory in listing as ".."
    //     oldSchool : false
    // }
},
contextmenu : {
    // navbarfolder menu
    navbar : ['open', '|', '|', 'rm', '|', 'info'],

    // current directory menu
    cwd    : ['reload', 'back', '|', 'upload', 'mkdir', '|', 'info'],

    // current directory file menu
    files  : [
        'getfile', '|','open', 'quicklook', '|', 'download', '|',
        'rm', '|', 'edit', 'rename', 'resize', '|', 'info'
    ]
},

        }).elfinder('instance');

        // set document.title dynamically etc.
        var title = document.title;
        elfinderInstance.bind('open', function(event) {
          var data = event.data || null;
          var path = '';
          
          if (data && data.cwd) {
            path = elfinderInstance.path(data.cwd.hash) || null;
          }
          document.title =  path? path + ':' + title : title;
        });

        // fit to window.height on window.resize
        var resizeTimer = null;
        $(window).resize(function() {
          resizeTimer && clearTimeout(resizeTimer);
          resizeTimer = setTimeout(function() {
            var h = parseInt($(window).height()) - 20;
            if (h != parseInt($('#elfinder').height())) {
              elfinderInstance.resize('100%', h);
            }
          }, 200);
        });

      });

