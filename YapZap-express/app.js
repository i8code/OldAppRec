
/**
 * Module dependencies.
 */

var express = require('express');
var http = require('http');
var https = require('https');
var path = require('path');

http.globalAgent.maxSockets = 10000;
https.globalAgent.maxSockets = 10000;

var mtrace = require('mtrace');
var filename = mtrace.mtrace();
console.log('Saving mtrace to ' + filename);

mtrace.mtrace();

//Models

var Models = require('./schema/schema.js');
var Tag = Models.Tag;
var Recording = Models.Recording;
var Like = Models.Like;
var Notification = Models.Notification;
var Friend = Models.Friend;


var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(function(req, res, next) {
    req.start = Date.now();
    next();
});
app.use(express.favicon());
app.use(express.json());
app.use(express.urlencoded());
app.use(express.static(path.join(__dirname, 'public')));
app.use(function(req, res, next) {
  if(!req.secure) {
    return res.redirect(['https://', req.get('Host'), req.url].join(''));
  }
  next();
});

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.use(function(req, res, next) {
    var start = Date.now();

    res.on('header', function() {
        var duration = Date.now() - start;

        var time = Date.now() - req.start;
        var method = req.method;
        var pathParts = req.url.split("?")[0].split("/");
        var url = req.url;

        switch(pathParts.length){
          case 2:
          case 3:
            url = pathParts[1];
            break;
          case 4:
            url = pathParts[1]+"_"+pathParts[3];
            break;
        }

        url = "../times/"+method+"_"+url+".csv";

        fs.appendFile(url, time+"\n", function (err) {});

    });
    next();
});
app.use(app.router);


var routes = require('./routes');
var tag_routes = require('./routes/tags');
var recording_routes = require('./routes/recordings');
var like_routes = require('./routes/likes');
var notification_routes = require('./routes/notifications');
var friend_routes = require('./routes/friends');

app.get('/', express.static(__dirname + '/public'));

//Tags
app.get('/tags', tag_routes.getAll(Models));
app.get('/tags/:name', tag_routes.getById(Models));
app.get('/tag_names', tag_routes.getAllTagNames(Models));
app.get('/tag_names/:name', tag_routes.searchTagNames(Models));
app.post('/tags', tag_routes.create(Models));

//Recordings
app.get('/recordings', routes.recordings(Recording));
app.get('/tags/:name/recordings', recording_routes.getAll(Models));
app.get('/recordings/:name/recordings', recording_routes.getAll(Models));
app.get('/recordings/:id', recording_routes.getById(Models));


app.put('/recordings/:id', recording_routes.updateById(Models));
app.del('/recordings/:id', recording_routes.deleteById(Models));


app.post('/tags/:name/recordings', recording_routes.create(Models));
app.post('/recordings/:name/recordings', recording_routes.create(Models));

    //by User
app.get('/users/:username/recordings', recording_routes.recordingsForUser(Models));


//Likes

app.get('/likes', routes.likes(Like));
app.get('/recordings/:id/likes', like_routes.getAll(Models));
app.get('/recordings/:id/likes/:username', like_routes.getById(Models));
app.post('/recordings/:id/likes', like_routes.create(Models));
app.del('/recordings/:id/likes/:username', like_routes.deleteById(Models));

//Notifications
app.get("/notifications/:username", notification_routes.getByUser(Models));


//Security

app.get('/tokens', routes.tokens());

//Audio
app.get('/a/:id', routes.audio_proxy(Models));
app.get('/a/:tag_name/:id', routes.audio_proxy(Models));
app.get('/audio_maps', routes.audio_maps(Models.AudioMap));

//Friends
app.post('/friends/:name', friend_routes.submitFriends(Models));


//Time

app.get('/time', function(req, res) {
  var t = Math.round((new Date()).getTime()/1000);
  res.send(""+t);
});

//Download link
app.get('/app', function(req, res) {
  res.redirect('https://itunes.apple.com/US/app/id844625372?mt=8');
});

app.get('/terms', function(req, res) {
  res.redirect('https://docs.google.com/file/d/0Bx2vwtV2MNvMUUtYYmQyeTV6OU0/preview');
});


var fs = require('fs');
var ca  = fs.readFileSync('../certs/RapidSSL_CA_bundle.pem', 'utf8');
var privateKey  = fs.readFileSync('../certs/yapzap.me.key', 'utf8');
var certificate = fs.readFileSync('../certs/yapzap.me.crt', 'utf8');

var credentials = {ca:ca, key: privateKey, cert: certificate};


https.createServer(credentials, app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});


//Read the blacklist
var lazy = require("lazy");
var fs = require("fs");

Models.BlackList.remove({}, function(err) { 
  new lazy(fs.createReadStream('./blacklist'))
       .lines
       .forEach(function(line){
          var b = new Models.BlackList({username:line});
          b.save();
       }
   );
});



// Recording.remove({username:"FB(null)_(null)"}, function(err){

// });

// var r = new Recording({username:"JaceLightning", parent_name: "gameofthrones", parent_type:"TAG"});
// r.save();
/*
var t = new Tag({name:"gameofthrones"});
var r = new Recording({username:"mike"});
var l = new Like({tag_name:"gameofthrones", username:"mike"});
t.save();
r.save();
l.save();*/

/*
var n = new Notification({
    username_for : "jason",
    username_by : "andy",
    tag_name:"gameofthrones",
    recording_id :"",
    created_date:new Date(2012, 7, 14),
    type:"LIKE"
});
n.save();
*/

// Tag.remove({}, function(err) { 
//    console.log('collection removed');
//    console.log(err);
// });
// Recording.remove({}, function(err) { 
//    console.log('collection removed');
//    console.log(err);
// });
// Like.remove({}, function(err) { 
//    console.log('collection removed');
//    console.log(err);
// });
// Models.AudioMap.remove({}, function(err) { 
//    console.log('collection removed');
// });
// Models.Notification.remove({}, function(err) { 
//    console.log('collection removed');
// });


