var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var routes = require('./routes/index');
var users = require('./routes/users');
var cors = require('cors');


// upload dependencies
var multipart = require('connect-multiparty');
var multipartMiddleware = multipart();
var UserController = require('./controllers/UserController');
var fs = require('fs');

var app = express();
app.use(cors());


app.options('*', cors());
//database dependencies
var orm = require('orm');

var database = orm.connect('mysql://lgirard:CH@ngemenow99Please!lgirard@classroom.cs.unc.edu/lgirarddb', function(err, db) {
  if (err) return console.error('Connection error: ' + err);

  // connected
  User = db.define("finalUser", {
        login: { type: 'text', unique: true },
        first: String,
        last: String,
        password: String
    }, {
        methods: {
            getLogin: function () {
                return this.login;
            }
        },
        validations: {

        }
    });

    User.sync( function () {

    });

  Syllabus = db.define("finalSyllabus", {
        filetitle: String,
        dateuploaded: Date
    }, {
        methods: {
            getSyllabus: function () {
                return this.syllabusId;
            }
        },
        validations: {

        }
    });



    Syllabus.hasOne("owner", User);

    Syllabus.sync( function () {

    });

    Event = db.define("finalEvent", {
        eventDate: String,
        description: String,
        title: String,
        time: String,
        eventtype: String,
        weight: Number
        } , {
        methods: {
            getTitle: function () {
                return this.title;
            }
        },
        validations: {

        }
      });

    Event.hasOne("owner", User);
    Event.hasOne("syllabus", Syllabus);

    Event.sync( function() {} );
});

// view engine setup
app.use(express.static(__dirname + '/public'));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// uncomment after placing your favicon in /public
app.use(favicon(path.join(__dirname, 'public', 'parseFavicon.png')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// route uploads from the drag drop
app.post('/uploads', multipartMiddleware, UserController.uploadFile);

var router = express.Router();

app.use('/', routes);
app.use('/users', users);

// ROUTES FOR OUR API
// =============================================================================
             // get an instance of the express Router

router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to our api!' });
});

router.route('/events')

  .post(function(req, res){
    var body = req.body;

    var newEvent = {};
    newEvent.eventDate = body.eventDate;
    newEvent.description = body.description;
    newEvent.title = body.title;
    newEvent.time = body.time
    newEvent.eventtype = body.eventtype;
    newEvent.weight = body.weight;
    newEvent.owner_id = body.owner_id;
    newEvent.syllabus_id = body.syllabus_id;

    Event.create(newEvent, function(err, results){
      if(err) { console.log(err); }
    });

  });


router.get('/:user_id/events', function(req, res){
  Event.find({owner_id: req.params.user_id}, function(err, results){
    res.json(results);
  });
});


router.route('/syllabi')

    .post(function(req, res){
    var body = req.body;

    var result;
    var newSyllabus = {};
    newSyllabus.filetitle = body.filetitle;
    newSyllabus.dateuploaded = '2015-12-11';

    Syllabus.create(newSyllabus, function(err, results){
      if(err) { console.log(err)};
      User.find({id: body.user_id}).first(function(err, userFound){
        Syllabus.find({id: results.id}).first(function(err, syll){
          syll.setOwner(userFound, function(err) {

          });
         });
       });
       res.json(results);
     });
  });

router.get('/users/:user_id/syllabi', function(req, res){
    Syllabus.find({owner_id: req.params.user_id}, function(err, results){
      res.json(results);
    });
  });

router.post('/users', function(req, res) {
  var body = req.body;

  var newUser = {};
  newUser.login = body.login;
  newUser.first = body.first;
  newUser.last = body.last;
  newUser.password = body.password;

  User.create(newUser, function(err, results) {
    if(err) { console.log(err)};
    res.json({message: 'success', id: results.id});
  });

});

router.get('/users/:login', function(req, res){
  User.exists({login: req.params.login}, function(err, doesExist){
    if(doesExist){
      User.find ({login: req.params.login}).first(function(err, resultUser){
        res.cookie('loginCookie', resultUser.id);
        res.json({exists: doesExist, id: resultUser.id});
      })
    } else {
      res.json({exists: doesExist});
    }
  })
});

router.delete('/syllabi/:syllabus_id', function(req, res){
  Syllabus.find({id: req.params.syllabus_id}).remove(function(err){
    if(err){
      res.json(err)
    } else{
      res.json("Successfully deleted.");
    }
  });
});

// more routes for our API will happen here

// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router);

//END ROUTES API

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});






module.exports = app;
