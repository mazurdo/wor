/* angular-secondsToHuman
 */
(function(){
  var app = angular.module("secondsToHuman", []);

  app
  .filter("secondsToHuman", ["$filter", function ($filter) {
    return function(seconds) {
      var seconds = parseInt(seconds, 10); // don't forget the second param
      var hours   = Math.floor(seconds / 3600);
      var minutes = Math.floor((seconds - (hours * 3600)) / 60);
      var seconds = seconds - (hours * 3600) - (minutes * 60);
      var time = "";

      if (hours !== 0) {
        time = hours+"h ";
      }
      if (minutes !== 0) { //|| time !== "") {
        time += String(minutes)+"m ";
      }
      if (seconds !== 0 && (minutes<=0)) { //|| time !== "") {
        time += String(seconds)+"s";
      }

      return time;
    }
  }]);

}).call(this);