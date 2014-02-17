
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