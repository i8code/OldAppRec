
var Security = require('../modules/security');
var $ = require('jquery');
var RecordingUpdater = require('../modules/recording_update');
var AudioMapper = require('../modules/audio_mapper');
var async = require('async');
var NotificationManager = require('../modules/set_notification');

/* GET /tags/:name/recording 
 * or
 * GET /recordings/:name/recording
 */
exports.getAll = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var name = req.params.name;

        if (!name){
            res.send(422);
            return;
        }

        var type;

        if (req.url.substring(0,5)==="/tags"){
            type = "TAG";
        } else {
            type = "REC";
        }

        var query = Models.Recording.find({parent_name:name, parent_type:type}).sort({created_date: 1});
        query.exec(function(err, recordings) {

            if (!recordings || recordings.length==0){
                res.status(200);
                res.send([]);
                return;
            }

            res.status(200);
            res.send(recordings);
        });
    };
};


/* GET /recording/:id
 */
exports.getById = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var id = req.params.id;

        if (!id){
            res.send(422);
            return;
        }

        var query = Models.Recording.find({_id:id});
        query.exec(function(err, recordings) {

            if (!recordings || recordings.length==0){
                res.send(404);
                return;
            }
            res.status(200);
            res.send(recordings[0]);
        });
    };
};

/* POST /tags/:name/recordings
 * or
 * POST /recordings/:name/recordings
 */
exports.create = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var name = req.params.name;

        var audio_url = req.body.audio_url;
        var waveform = req.body.waveform_data;
        var username = req.body.username;

        if (!name || !audio_url || !waveform || !username){
            res.send(422);
            return;
        }

        var type;

        if (req.url.substring(0,5)==="/tags"){
            type = "TAG";

            Models.Tag.find({name:name}).exec(function(err, tags) {
                if (!tags || tags.length===0){
                    //Create the tag
                    console.log("creating new tag");
                    var tag = new Models.Tag({name:name});
                    tag.save();
                }
            });

        } else {
            type = "REC";
        }


        var recording = new Models.Recording(req.body);
        recording.parent_type = type;
        recording.parent_name = name;
        recording.tag_name = name;
        recording.popularity=1;
        recording.save();

        //update tag name
        if (type==="REC"){
            Models.Recording.find({_id:name}).exec(function(err, recordings) {
                if (!recordings || recordings.length===0){
                    //Create the tag
                    return;
                }
                recording.tag_name = recordings[0].tag_name;
                recording.save();
            });
        }

        //Update hash
        var audioCallback = function(hash){
            recording.audio_hash = hash;
            recording.save(function(err){ 

                if (type==="TAG"){
                    RecordingUpdater.updateTagPopularity(Models, name);
                } else {
                    RecordingUpdater.updateRecordingPopularity(Models, name);
                    NotificationManager.addNotificationForComment(Models, recording.username, recording.parent_name, recording._id);
                }

                res.status(201);
                res.send(recording);
            });
         };
         AudioMapper.getOrCreateHash(Models, recording.audio_url, audioCallback);

    };
};


/* UPDATE /recording/:id
 */
exports.updateById = function(Models) {
    return function(req, res) {
        console.log("here");
        if (!Security.check(req, res)) return;

        var id = req.params.id;

        if (!id){
            res.send(404);
            return;
        }

        var query = Models.Recording.find({_id:id});
        query.exec(function(err, recordings) {

            if (!recordings || recordings.length==0){
                res.send(404);
                return;
            }

            $.extend(recording[0], req.body);
            recording[0]._id = id;
            recording[0].save();

            if (recording.parent_type==="TAG"){
                RecordingUpdater.updateTagPopularity(Models, recording.parent_name);
            } else {
                RecordingUpdater.updateRecordingPopularity(Models, recording.parent_name);
            }

            res.status(200);
            res.send(recordings[0]);
        });
    };
};

var deleteAllChildren = function(Models, recording_name){
    var query = Models.Recording.find({parent_name:recording_name, parent_type:"REC"});
    query.exec(function(err, recordings){
        if (!recordings || recordings.length==0){
            return;
        }
        for (var i=0;i<recordings.length;i++){
            var recording = recordings[i];

            Models.Recording.remove({_id:recording._id}, function(err){
                deleteAllChildren(Models, recording._id);
            });
        }

    });
}

 /* DELETE /recording/:id
 */
exports.deleteById = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var id = req.params.id;

        if (!id){
            res.send(404);
            return;
        }

        var query = Models.Recording.find({_id:id});
        query.exec(function(err, recordings) {

            if (!recordings || recordings.length==0){
                res.send(404);
                return;
            }

            var recording = recordings[0];

            Models.Recording.remove({_id:id}, function(err){
                deleteAllChildren(Models, recording._id);

                if (recording.parent_type==="TAG"){
                    RecordingUpdater.updateTagPopularity(Models, recording.parent_name);
                } else {
                    RecordingUpdater.updateRecordingPopularity(Models, recording.parent_name);
                }

                res.status(200);
                res.send(recording);

            });

        });
    };
};

/* GET /users/:username/recorings
* Gets all recordings for a certain user
*/
exports.recordingsForUser = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var username = req.params.username;

        if (!username){
            res.send(404);
            return;
        }

        var query = Models.Recording.find({username:username}).sort({created_date: -1});
        query.exec(function(err, recordings) {

            if (!recordings || recordings.length==0){
                res.status(200);
                res.send([]);
                return;
            }

            res.status(200);
            res.send(recordings);
        });
    };
};



