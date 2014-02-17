
/**
 * Module dependencies.
 */

var express = require('express');
var http = require('http');
var path = require('path');

//Models

var Models = require('./schema/schema.js');
var Tag = Models.Tag;
var Recording = Models.Recording;
var Like = Models.Like;

var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(express.cookieParser('your secret here'));
app.use(express.session());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}



var routes = require('./routes');
var tag_routes = require('./routes/tags');
var recording_routes = require('./routes/recordings');
var like_routes = require('./routes/likes');

app.get('/', routes.index);

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


//Likes

app.get('/likes', routes.likes(Like));
app.get('/recordings/:id/likes', like_routes.getAll(Models));
app.get('/recordings/:id/likes/:username', like_routes.getById(Models));
app.post('/recordings/:id/likes', like_routes.create(Models));
app.del('/recordings/:id/likes/:username', like_routes.deleteById(Models));


//Security

app.get('/tokens', routes.tokens());

// var r = new Recording({username:"JaceLightning", parent_name: "gameofthrones", parent_type:"TAG"});
// r.save();
/*
var t = new Tag({name:"gameofthrones"});
var r = new Recording({username:"mike"});
var l = new Like({tag_name:"gameofthrones", username:"mike"});
t.save();
r.save();
l.save();*/


// Tag.remove({}, function(err) { 
   // console.log('collection removed');
   // console.log(err);
// });
// Recording.remove({}, function(err) { 
//    console.log('collection removed');
//    console.log(err);
// });
//Like.remove({}, function(err) { 
   // console.log('collection removed');
   // console.log(err);
// });

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
