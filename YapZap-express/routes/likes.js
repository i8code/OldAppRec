
var Security = require('../modules/security');
var $ = require('jquery');
var RecordingUpdater = require('../modules/recording_update');
var NotificationManager = require('../modules/set_notification');

/*
 * GET /recordings/:id/likes
 */
exports.getAll = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var id = req.params.id;

        if (!id){
            res.send(422);
            return;
        }

        var query = Models.Like.find({recording_id:id});
        query.exec(function(err, likes){
            if (likes){
                res.status(200);
                res.send(likes);
                return;
            }

            res.send(404);
        })
    };
};

/*
 * GET /recordings/:id/likes/:username
 */
exports.getById = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var id = req.params.id;
        var username = req.params.username;

        if (!id || !username){
            res.send(422);
            return;
        }

        var query = Models.Like.find({recording_id:id, username:username});
        query.exec(function(err, likes){
            if (likes && likes.length>0){
                res.status(200);
                res.send(likes[0]);
                return;
            }

            res.send(404);
        })
    };
};


var updateLikes = function(Models, recording_id, delta){

    var query = Models.Recording.find({_id:recording_id});
    query.exec(function(err, recordings){
        if (!recordings || recordings.length==0){
            return;
        }

        var recording = recordings[0];
        recording.likes+=delta;
        recording.save();
    });

    setTimeout(function(){
        RecordingUpdater.updateRecordingPopularity(Models, recording_id);
    },1);
}

/*
 * POST /recordings/:id/likes
 */
exports.create = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var id = req.params.id;
        var username = req.body.username;

        if (!id || !username){
            res.send(422);
            return;
        }

        var query = Models.Like.find({recording_id:id, username:username});
        query.exec(function(err, likes){
            var like;
            if (likes && likes.length>0){
                like = likes[0];
            } else {
                like = new Models.Like({recording_id:id, username:username});
                like.save();
                updateLikes(Models, id, 1);
            }

            res.status(201);
            res.send(like);

            setTimeout(function(){
                NotificationManager.addNotificationForLike(Models, username, id);
            },1);

            Models.Recording.find({_id:id}).exec(function(err, recordings){

                if (!recordings || recordings.length===0){
                    return;
                }

                recordings[0].username = username;
                setTimeout(function(){
                    NotificationManager.notifyFriends(Models, recordings[0], "LIKE");
                },1);
            });
            
        });
    };
};


/*
 * DELETE /recordings/:id/likes/:username
 */
exports.deleteById = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var id = req.params.id;
        var username = req.params.username;

        if (!id || !username){
            res.send(422);
            return;
        }

        var query = Models.Like.find({recording_id:id, username:username});
        query.exec(function(err, likes){
            if (likes && likes.length>0){
                Models.Like.remove({recording_id:id, username:username}, function(err){
                    res.send(200);
                    updateLikes(Models, id, -1);
                    return;
                });

            } else {
               res.send(200);
               return;
            }
        });

        
    };
};