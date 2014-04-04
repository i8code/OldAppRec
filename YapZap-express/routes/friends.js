var Security = require('../modules/security');
var $ = require('jquery');
var RecordingUpdater = require('../modules/recording_update');
var AudioMapper = require('../modules/audio_mapper');
var async = require('async');
var NotificationManager = require('../modules/set_notification');

/* POST /friends/:name
 */
exports.submitFriends = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var name = req.params.name;

        if (!name){
            res.send(404);
            return;
        }

        var id = name.split('_')[0];

        Models.BlackList.find({username:id}, function(err, blacklist){

            if (blacklist && blacklist.length){
                //User on the blacklist
                res.send(403);
                return;
            }

            res.send(201);

            //remove existing friends list
            Models.Friend.remove({friend_of:name}, function(err){
                if (err){
                    // console.log(err);
                    return;
                }
                var friends = req.body;
                var i=0;
                var friend;
                friends.forEach(function(friend){
                    setTimeout(function(){
                        var friend = new Models.Friend(
                            {
                                friend_id:friend,
                                friend_of:name
                            }
                        );
                        friend.save();
                    },1);
                });

            });

        });

    };
};