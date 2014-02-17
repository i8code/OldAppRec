
/*
 * GET home page.
 */
var Security = require('../modules/security');
exports.index = function(req, res){
  res.render('index', { title: 'Express' });
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

exports.audio_proxy = function(Models) {
    return function(req, res) {

        var id = req.params.id;
        var query = Models.AudioMap.find({hash:id}, function(err, maps){

            if (!maps || maps.length==0){
                res.send(404);
                return;
            }
            var filename = maps[0].filename;
            https.get('https://s3.amazonaws.com/yap-zap-audio/'+filename+'.m4a', function(proxyRes) {
                proxyRes.pipe(res);
            });
        });

        
    };
};