
var Security = require('../modules/security');

exports.getAll = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var query = Models.Tag.find({}).sort({'date': -1}).limit(200);
        query.exec(function(err, tags) {
            res.status(201);
            res.send(tags);
        });
    };
};


exports.getById = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var name = req.params.name;
        var query;

        if (!name){
            //Check for id
            res.send(400);
            return;
        }
        
        query = Models.Tag.find({name:name});

        query.exec(function(err, tags) {
            if (!tags || tags.length===0){
                //Check to see if they meant id
                query = Models.Tag.find({_id:name});
                query.exec(function(err, tags) {
                    if (!tags || tags.length==0){
                        res.send(404);
                        return;
                    }
                    else {
                        res.status(201);
                        res.send(tags[0]);
                    }
                });
            } else {
                res.status(201);
                res.send(tags[0]);
            }
        });
    };
};