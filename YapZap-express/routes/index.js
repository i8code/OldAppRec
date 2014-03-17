
/*
 * GET home page.
 */
var Security = require('../modules/security');
exports.index = function(req, res){
  res.render('index', { title: 'YapZap' });
};

exports.tags = function(Tag) {
    return function(req, res) {
        if (!Security.check(req, res)) return;
        Tag.find({}, function(err, tags){
            res.send(tags);
        });
    };
};

exports.recordings = function(Recordings) {
    return function(req, res) {
        if (!Security.check(req, res)) return;
        Recordings.find({}, function(err, Recordings){
            res.send(Recordings);
        });
    };
};

exports.likes = function(Likes) {
    return function(req, res) {
        if (!Security.check(req, res)) return;
        Likes.find({}, function(err, likes){
            res.send(likes);
        });
    };
};

exports.audio_maps = function(AudioMap) {
    return function(req, res) {
        if (!Security.check(req, res)) return;
        AudioMap.find({}, function(err, likes){
            res.send(likes);
        });
    };
};

exports.tokens = function() {
    return function(req, res) {
        var user = Security.getUsers()[0];
        var t = (new Date()).getTime();
        var hash = Security.getHash(user.secret, user.key, t.toString());
        var query = "?key="+user.key+"&token="+hash+"&t="+t.toString();

        res.send(query);
    };
};

var https = require('https');
/*
var AWS = require('aws-sdk');
var s3 = new AWS.S3();
AWS.config.region = 'us-east-1';

exports.audio_proxy = function(Models) {
    return function(req, res) {

        var id = req.params.id;
        var query = Models.AudioMap.find({hash:id}, function(err, maps){

            if (!maps || maps.length==0){
                res.send(404);
                return;
            }
            var filename = maps[0].filename;
            var params = {Bucket: 'yap-zap-audio', Key: filename};
            res.setHeader('content-type', 'video/mp4');
            s3.getObject(params).createReadStream().pipe(res);
        });
    };
};

exports.audio_proxy = function(Models) {
    return function(req, res) {

        var id = req.params.id;
        var query = Models.AudioMap.find({hash:id}, function(err, maps){

            if (!maps || maps.length==0){
                res.send(404);
                return;
            }
            var filename = maps[0].filename;

            res.redirect('https://s3.amazonaws.com/yap-zap-audio/'+filename);
        });
    };
};
*/

exports.audio_proxy = function(Models) {
    return function(req, res) {

        var id = req.params.id;
        var tag_name = req.params.tag_name;
        var query = Models.AudioMap.find({hash:id}, function(err, maps){

            /*if (!maps || maps.length==0){
                res.send(404);
                return;
            }
            var filename = maps[0].filename;*/
            filename = '2014-03-09T16:44:43.364-0400_FBrachel.steinberg.773_Rachel Steinberg.mp4';
            var path = 'https://s3.amazonaws.com/yap-zap-audio/'+filename;
            var title = tag_name || 'YapZap';
            console.log(path);
            console.log(title);
            res.render('audio', {
                title: title,
                src:path
            });
        });
    };
};