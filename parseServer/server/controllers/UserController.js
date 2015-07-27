var fs = require('fs');

UserController = function() {};

UserController.prototype.uploadFile = function(req, res) {
    // We are able to access req.files.file thanks to
    // the multiparty middleware
    var file = req.files.file;
    console.log(file.name);
    console.log(file.type);
    fs.writeFile(file.name, file, function(err) {
      if (err) throw err;
      console.log('It\'s saved');
    })
}

module.exports = new UserController();
