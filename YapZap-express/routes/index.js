
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

exports.tags = function(Tag) {
    return function(req, res) {
        Tag.find({}, function(err, tags){
            res.send(tags);
        });
    };
};

exports.recordings = function(Recordings) {
    return function(req, res) {
        Recordings.find({}, function(err, Recordings){
            res.send(Recordings);
        });
    };
};

exports.likes = function(Likes) {
    return function(req, res) {
        Likes.find({}, function(err, likes){
            res.send(likes);
        });
    };
};

exports.model = function(Tags, Recordings, Likes) {
    return function(req, res) {


        Likes.find({}, function(err, likes){
            res.send(likes);
        });
    };
};