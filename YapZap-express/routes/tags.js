
var Security = require('../modules/security');

exports.getAll = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var query = Models.Tag.find({}).sort({'popularity': -1}).limit(200);
        query.exec(function(err, tags) {
            res.status(200);
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
                        res.status(200);
                        res.send(tags[0]);
                    }
                });
            } else {
                res.status(200);
                res.send(tags[0]);
            }
        });
    };
};

exports.create = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        console.log(req);
        console.log(req.body);

        var Tag = Models.Tag;

        var tag = new Tag({name : req.body.name});
        if (!tag.name){
            res.send(422);
            return;
        }

        tag.name = tag.name.replace(/\W/g, '').toLowerCase();

        Models.Tag.find({name:tag.name}).exec(function(err, tags) {
            if (!tags || tags.length===0){
                //Create the new one
                tag.save(function (err, tag, numberAffected) {
                    if (err){
                        res.send(500);
                        return;
                    }

                    res.status(201);
                    res.send(tag);
                    return;
                });

            }else {
                res.status(201);
                res.send(tags[0]);
                return;
            }
        });


    };
};


exports.getAllTagNames = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var query = Models.Tag.find({}).sort({'name': 1});
        var names = [];
        query.exec(function(err, tags) {

            for (var i=0;i<tags.length;i++){
                names.push(tags[i].name);
            }
            res.status(200);
            res.send(names);
        });
    };
};

exports.searchTagNames = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var search = req.params.name;

        var regex1 = new RegExp("^"+search);
        var regex2 = new RegExp(search, "g");
        var query = Models.Tag.find({name:regex1}).sort({'name': 1});
        var names = {};

        query.exec(function(err, tags) {

            for (var i=0;i<tags.length;i++){
                names[tags[i].name]=true;
            }

            query = Models.Tag.find({name:regex2}).sort({'name': 1});

            query.exec(function(err, tags) {    
                for (var i=0;i<tags.length;i++){
                    names[tags[i].name]=true;
                }

                var nameArray = [];
                for (name in names){
                    nameArray.push(name);
                }
                res.status(200);
                res.send(nameArray);
            });
        });
    };
};
