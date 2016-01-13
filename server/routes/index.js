var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {

    res.render('index', { title: 'ejs' });
});

router.get('/Syllabi', function(req, res, next) {
 res.render('mySyllabi', {title: 'ejs'});
});

router.get('/PrivacyPolicy', function(req, res, next) {
 res.render('privacyPolicy', {title: 'ejs'});
});

router.get('/About', function(req, res, next) {
 res.render('aboutUs', {title: 'ejs'});
});

router.get('/Events', function(req, res, next) {
 res.render('calendarView', {title: 'ejs'});
});

router.get('/manualevent', function(req, res, next) {
  res.render('manualevent', { title: 'ejs' });
});

/**
 * Create file upload
 */
exports.create = function (req, res, next) {
    var data = _.pick(req.body, 'type')
        , uploadPath = path.normalize(cfg.data + '/uploads')
        , file = req.files.file;

        console.log(file.name); //original name (ie: sunset.png)
        console.log(file.path); //tmp path (ie: /tmp/12345-xyaz.png)
    console.log(uploadPath); //uploads directory: (ie: /home/user/data/uploads)
};

module.exports = router;
