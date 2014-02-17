
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var tag_routes = require('./routes/tags');
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

app.get('/', routes.index);

//Tags
app.get('/tags', tag_routes.getAll(Models));
app.get('/tags/:name', tag_routes.getById(Models));
app.get('/tag_names', tag_routes.getAllTagNames(Models));
app.get('/tag_names/:name', tag_routes.searchTagNames(Models));
app.post('/tags', tag_routes.create(Models));

app.get('/recordings', routes.recordings(Recording));
app.get('/likes', routes.likes(Like));
/*
var t = new Tag({name:"gameofthrones"});
var r = new Recording({username:"mike"});
var l = new Like({tag_name:"gameofthrones", username:"mike"});
t.save();
r.save();
l.save();
Tag.remove({}, function(err) { 
   // console.log('collection removed');
   // console.log(err);
});*/

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
