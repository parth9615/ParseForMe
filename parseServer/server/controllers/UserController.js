

var fs = require('fs');

UserController = function() {};

UserController.prototype.uploadFile = function(req, res) {
    // We are able to access req.files.file thanks to
    // the multiparty middleware

    var file = req.files.file;

    var fileData = fs.readFileSync(file.path);
    fs.writeFileSync('./uploads/'+file.name, fileData);

}

module.exports = new UserController();
