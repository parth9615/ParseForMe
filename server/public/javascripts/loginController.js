Parse.initialize("D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT", "XSZ5x97qzUWiALEbAKUq49QlcKKPxuJlhmOedEEj");


var loginApp = angular.module('AuthApp', ['ngFileUpload', 'ng'])

.run(['$rootScope', function($scope, $httpProvider) {
  $scope.scenario = 'Sign up';
  $scope.currentUser = Parse.User.current();

  $scope.signUp = function(form) {
    var user = new Parse.User();
    user.set("email", form.email);
    user.set("username", form.email);
    user.set("password", form.password);

    user.signUp(null, {
      success: function(user) {
        $scope.currentUser = user;
        $scope.$apply();
      },
      error: function(user, error) {
        alert("Unable to sign up:  " + error.code + " " + error.message);
      }
    });
  };

  $scope.logIn = function(form) {
    Parse.User.logIn(form.username.toLowerCase(), form.password, {
      success: function(user) {
        $scope.currentUser = user;
        $scope.$apply();
      },
      error: function(user, error) {
        alert("Unable to log in: " + error.code + " " + error.message);
      }
    });

    var params = encodeURI({ "where": JSON.stringify({"username": "flerp@flerp.com"}) })
    console.log(params);
    var existingSyllabi = $.ajax({
        type: 'GET',
        url: "https://api.parse.com/1/classes/Events?"+"where=%7B%22username%22%3A+%22flerp%40flerp.com%22%7D",

        headers: {
             'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
             'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF'
        },
        success: function(data){
          console.log(data);
        }

      } );

  }
  $scope.logOut = function(form) {
    Parse.User.logOut();
    $scope.currentUser = null;
  };
}]);

loginApp.config(['$httpProvider', function($httpProvider) {
        $httpProvider.defaults.useXDomain = true;
        delete $httpProvider.defaults.headers.common['X-Requested-With'];
    }
]);

loginApp.controller('dragDropController', ['$scope', 'Upload', '$http', function ($scope, Upload, $http) {
    $scope.$watch('files', function () {
        $scope.upload($scope.files, $http);
    });

    $scope.upload = function (files) {
        if(files && files.length) {
          for(var i = 0; i < files.length; i++){
            var file = files[i];
            Upload.upload({
              url: 'uploads',
              fields: {'username': $scope.username},
              file: file
            })


            var fail = function(err){
              console.log('got an error in date algo')
              throw err;
            }

            var success = function(flaskResponse){
              console.log(flaskResponse);
              var eventsArray = flaskResponse.data.events;
              $http.post("https://api.parse.com/1/files/"+file.name, file, {

                     headers: {
                         'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
                         'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
                         'Content-Type': file.type
                     },
                     transformRequest: angular.identity

              }).then(function(data) {

                  for(var i = 0; i < eventsArray.length; i++){
                    var syllabiEvent = eventsArray[i];

                    $http.post("https://api.parse.com/1/classes/Events", {

                      "username": $scope.currentUser.attributes.username,
                      "events": syllabiEvent,
                      "syllabus": {
                        "name": data.data.name,
                        "__type": "File"
                      }
                    },

                    {
                      headers: {
                          'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
                          'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
                          'Content-Type': 'application/json'
                      }
                    })
                  }
                }).then(function(){
                  alert("Syllabus successfully uploaded");
                })
                 }
              }

          $http.post("http://localhost:5000/dates", "./uploads/"+file.name).then(success, fail)
          };
        }


}]);


loginApp.controller('uploadEventController', ['$scope', '$http', function ($scope, $http) {
  $scope.submit = function(form){
    var manualEvent = {"Date": form.date, "Time": form.time, "Title": form.title,
                        "Type": form.type || "Unspecified", "Weight": form.weight || 0, "Classname": form.classname}


    $http.post("https://api.parse.com/1/classes/Events", {

      "username": $scope.currentUser.attributes.username,
      "events": manualEvent
    },

    {
      headers: {
          'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
          'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
          'Content-Type': 'application/json'
      }
    }).then(function(){
      alert("Event successfully uploaded.")
    })

    $scope.manualEvent = {};
    $scope.manualForm.$setPristine();
  }




}]);
