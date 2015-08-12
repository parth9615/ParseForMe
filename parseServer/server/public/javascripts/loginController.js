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

            var done=function(resp){
              console.log(resp.data);
              //$scope.lists=resp.data;
            };
            var fail=function(err){

            };
              $http.post("http://localhost:5000/dates", "./uploads/"+file.name).then(done, fail);


          // $http.post("https://api.parse.com/1/files/"+file.name, file, {
          //
          //        headers: {
          //            'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
          //            'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
          //            'Content-Type': file.type
          //        },
          //        transformRequest: angular.identity
          //
          // }).then(function(data) {
          //   console.log(data.data.name);
          //   console.log($scope.currentUser);
          //   $http.post("https://api.parse.com/1/classes/Events", {
          //
          //     "username": $scope.currentUser.attributes.username,
          //     "syllabus": {
          //       "name": data.data.name,
          //       "__type": "File"
          //     }
          //   },
          //
          //   {
          //     headers: {
          //         'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
          //         'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
          //         'Content-Type': 'application/json'
          //     }
          //   })
          // })
          };
        }
      }

}]);
