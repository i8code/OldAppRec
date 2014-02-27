
var Security = require('../modules/security');
var $ = require('jquery');
var RecordingUpdater = require('../modules/recording_update');
var AudioMapper = require('../modules/audio_mapper');
var async = require('async');

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

        var query = Models.Recording.find({parent_name:name, parent_type:type});
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

/* POST /tags/:name/recording 
 * or
 * POST /recordings/:name/recording
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
        } else {
            type = "REC";
        }

        var recording = new Models.Recording(req.body);
        recording.parent_type = type;
        recording.parent_name = name;
        recording.popularity=1;
        recording.save();

        //Update hash
        var audioCallback = function(hash){
            recording.audio_hash = hash;
            recording.save(function(err){ 

                if (type==="TAG"){
                    RecordingUpdater.updateTagPopularity(Models, name);
                } else {
                    RecordingUpdater.updateRecordingPopularity(Models, name);
                }

                res.status(201);
                res.send(recording);
            });
         };
         AudioMapper.getOrCreateHash(Models, recording.audio_url, audioCallback);

        return;

    };
};


/* UPDATE /recording/:id
 */
exports.updateById = function(Models) {
    return function(req, res) {
        console.log("here");
        if (!Security.check(req, res)) return;

        console.log("here");

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
