
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  var query = new Parse.Query('Events');
  query.equalTo('username', 'joelwass');
  Parse.Push.send({
    where: query, //set to our installation query
    data: {
       alert: "Quit Your Jibba Jabba"
    }
  }, {
    success: function() {
    // success!
    },
    error: function(err) {
      console.log(err);
    }
  });
  response.success("Hello world!");
});
