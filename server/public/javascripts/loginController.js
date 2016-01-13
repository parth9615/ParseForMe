Parse.initialize("D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT", "XSZ5x97qzUWiALEbAKUq49QlcKKPxuJlhmOedEEj");


var loginApp = angular.module('AuthApp', ['ngFileUpload', 'ng',])

.run(['$rootScope', function($scope, $http) {
  $scope.scenario = 'Log in';
  $scope.currentUser = Parse.User.current();
  console.log(document.cookie);


}]);

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
              $("#reviewModal").modal('hide');
              $("#failModal").modal('show');
            }

            var success = function(flaskResponse){

              for(var i = 0; i<flaskResponse.data.events.length; i++){
                var data = flaskResponse.data.events[i];
                var eventCount = i+1;
                var dateArray = data.Date.split('/');
                var eventDate = (dateArray[2].length == 4 ? dateArray[2] : '20'+ dateArray[2])+'-'+ (dateArray[0].length == 2 ? dateArray[0] : '0'+dateArray[0])+'-'+(dateArray[1].length == 2 ? dateArray[1] : '0'+dateArray[1]);

                $('.modal-body').append("<div id=\""+i+"\"></div>")
                $('#'+i).append("<h3>Event "+eventCount+"</h3>");
                $('#'+i).append("Title: <input id=\"title\" class=\"reviewInput\" value=\""+data.Title+"\"></input></br>");
                $('#'+i).append("Time: <input id=\"time\" class=\"reviewInput\"  value=\""+data.Time+"\"></input></br>");
                $('#'+i).append("Date: <input id=\"date\" class=\"reviewInput\" type=\"date\" value=\""+eventDate+"\"></input></br>");
                $('#'+i).append("Type: <input id=\"type\" class=\"reviewInput\" value=\""+data.Type+"\"></input></br>");
                $('#'+i).append("Weight: <input id=\"weight\" type=\"number\" class=\"reviewInput\" value=\""+data.Weight+"\"></input></br>");
                $('#'+i).append("Description: <textarea id=\"description\" class=\"descriptionArea\" rows=\"4\">"+data.Description+"</textarea></br><hr>");
              }

              $('#reviewModal').modal('show');
              $('#reviewModal').on('hidden.bs.modal', function(){
                $('.modal-body').empty();
              });
              $('#reviewSubmit').click( function(){
                var eventsArray = flaskResponse.data.events;
                $http.post("https://api.parse.com/1/files/"+file.name, file, {

                       headers: {
                           'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
                           'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
                           'Content-Type': file.type
                       },
                       transformRequest: angular.identity

                }).then(function(data) {
                    $http.post("https://api.parse.com/1/classes/Syllabi", {
                      "syllabus": {
                        "name": data.data.name,
                        "__type": "File"
                      },
                      "username": $scope.currentUser.attributes.username,
                      "filetitle": data.data.name.split('-')[data.data.name.split('-').length-1]
                    },

                      {
                        headers: {
                            'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
                            'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
                            'Content-Type': 'application/json'
                        }
                      });

                    for(var i = 0; i < eventsArray.length; i++){
                      var syllabiEvent = {
                        "Title": $("#"+i+" > #title").val() || "",
                        "Time": $("#"+i+" > #time").val() || "",
                        "Date": $("#"+i+" > #date").val(),
                        "Weight": $("#"+i+" > #weight").val() || 0,
                        "Type": $("#"+i+" > #type").val() || "",
                        "Description": $("#"+i+" > #description").val() || ""
                      };

                      //console.log(syllabiEvent);

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
                    $("#reviewModal").modal('hide');
                    $("#successModal").modal('show');
                  })

                });
          };
          $http.post("http://localhost:5000/dates", "./uploads/"+file.name).then(success, fail);
        }
      }
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

loginApp.controller('loginUserController', ['$scope', '$http', '$timeout', function ($scope, $http, $timeout) {

  $scope.logIn = function(form) {
    Parse.User.logIn(form.username.toLowerCase(), form.password, {
      success: function(user) {
        $scope.currentUser = user;
        document.cookie ="loginCookie="+user.attributes.username;
        $scope.$apply();
      },
      error: function(user, error) {
        alert("Unable to log in: " + error.code + " " + error.message);
      }
    });
  };

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

  $scope.logOut = function() {
    Parse.User.logOut();
    $scope.currentUser = null;
    document.cookie = "loginCookie=; expires=Thu, 01 Jan 1970 00:00:01 GMT;";
    window.location.href = '/';
    console.log("in logout");
  };





}]);

loginApp.controller('findSyllabiController', ['$scope', '$http', '$timeout', function ($scope, $http, $timeout) {
  $scope.findSyllabi = function() {
    var id = document.cookie.split("=")[1];
    $scope.user_id = id;

    var qs = encodeURIComponent("where\={\"username\":\""+document.cookie.split('=')[1].toLowerCase()+"\"}");

    $http.get("https://api.parse.com/1/classes/Syllabi?"+qs,
    {
      headers: {
          'X-Parse-Application-Id': 'D66UUzuPDgCQ4Fxea73VbPxahF9xGZntWZ8mVlKT',
          'X-Parse-REST-API-Key': 'exvs87UNQZa5IVOCiJMnOuk28KzSJf47OGOwr7xF',
          'Content-Type': 'application/json'
      }
    }
    ).then(function(res){
      console.log(res);
      for(var i=0; i<res.data.results.length; i++){
        var data = res.data.results[i];

        var mydate = new Date(data.createdAt);
        var month = ["January", "February", "March", "April", "May", "June",
          "July", "August", "September", "October", "November", "December"][mydate.getMonth()];
        var str = month + ' ' + mydate.getDate() + ', ' + mydate.getFullYear() + '   '+mydate.getHours()   +':' + mydate.getMinutes();

        var appendString = "<tr><td>"+data.filetitle+"</td><td>"+str+"</td></tr>";

        $("#syllabiTable").append(appendString);
      }
    });



  }
  $scope.findSyllabi();

}])
