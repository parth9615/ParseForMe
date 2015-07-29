Parse.initialize("D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT", "XSZ5x97qzUWiALEbAKUq49QlcKKPxuJlhmOedEEj");

var loginApp = angular.module('AuthApp', ['ngFileUpload', 'ng'])
.run(['$rootScope', function($scope) {
  $scope.scenario = 'Sign up';
  $scope.currentUser = Parse.User.current();

  $scope.signUp = function(form) {
    var user = new Parse.User();
    user.set("email", form.email);
    user.set("username", form.username);
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
    Parse.User.logIn(form.username, form.password, {
      success: function(user) {
        $scope.currentUser = user;
        $scope.$apply();
      },
      error: function(user, error) {
        alert("Unable to log in: " + error.code + " " + error.message);
      }
    });
  };

  $scope.logOut = function(form) {
    Parse.User.logOut();
    $scope.currentUser = null;
  };
}]);

loginApp.controller('dragDropController', ['$scope', 'Upload', '$http', function ($scope, Upload, $http) {
    $scope.$watch('files', function () {
        $scope.upload($scope.files, $http);
    });

    $scope.upload = function (files) {
        if(files && files.length) {
          var file = files[0];
        $http.post("https://api.parse.com/1/files/"+file.name, file, {

               headers: {
                   'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
                   'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
                   'Content-Type': file.type
               },
               transformRequest: angular.identity

        }).then(function(data) {
          console.log(data.data.name);
        })
        };
      }

    //     if (files && files.length) {
    //         for (var i = 0; i < files.length; i++) {
    //             var file = files[i];
    //             Upload.upload({
    //                 url: 'uploads/',
    //                 fields: {'username': $scope.username},
    //                 file: file
    //             }).progress(function (evt) {
    //                 var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
    //                 console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
    //             }).success(function (data, status, headers, config) {
    //                 console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
    //             }).error(function (data, status, headers, config) {
    //                 console.log('error status: ' + status);
    //             })
    //         }
    //     }

}]);
