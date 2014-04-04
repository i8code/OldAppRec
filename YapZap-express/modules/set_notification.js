
exports.addNotificationForLike = function(Models, username_by, recording_id){
    //If it's a like, the the recording id is of the recording we are looking for
    //We need to its parent to find the tag name
    // console.log("Adding like notification by "+username_by+" for "+recording_id);

    var query = Models.Recording.find({_id:recording_id});
    query.exec(function(err, recordings) {

        if (!recordings || recordings.length==0){
            return;
        }

        var parent_recording = recordings[0];
        var username_for = parent_recording.username;

        if (username_for===username_by){
            //Same user; no notification
            return;
        }
        // console.log("found target: "+username_for);

        if (parent_recording.parent_type==="TAG"){
            //We have all the information we need
            var tag_name = parent_recording.parent_name;
            var tag_query = Models.Tag.find({name:tag_name}).exec(function(err, tags){
                if (!tags || !tags.length){
                    return;
                }

                var notification = new Models.Notification({
                    username_for : username_for,
                    username_by : username_by,
                    tag_name: tag_name,
                    mood: tags[0].mood,
                    intensity: tags[0].intensity,
                    recording_id : recording_id,   
                    type:"LIKE"
                    });
                notification.save();
            });
            return;
        }

        //Search for tag information
        // console.log("searching for tag information");
        var parent_query = Models.Recording.find({_id:parent_recording.parent_name});
        parent_query.exec(function(err, recordings) {

            if (!recordings || recordings.length==0){
                return;
            }
            var tag_name = recordings[0].parent_name;

            var tag_query = Models.Tag.find({name:tag_name}).exec(function(err, tags){
                if (!tags || !tags.length){
                    return;
                }
                var notification = new Models.Notification({
                    username_for : username_for,
                    username_by : username_by,
                    tag_name: tag_name,
                    mood: tags[0].mood,
                    intensity: tags[0].intensity,
                    recording_id : recording_id,
                    type:"LIKE"
                });
                notification.save();

            });
        });
    });
}


exports.addNotificationForComment = function(Models, username_by, recording_parent, recording_id){
    //If it's a comment, then the parent must be a recording
    //Need to get the parent info
    // console.log("Adding comment notification by "+username_by+" for "+recording_parent);

    var query = Models.Recording.find({_id:recording_parent});
    query.exec(function(err, recordings) {

        if (!recordings || recordings.length==0){
            return;
        }
        var parent =recordings[0];
        var username_for = parent.username;

        if (username_for===username_by){
            //Same user; no notification
            return;
        }
        var tag_name = parent.parent_name;

        var tag_query = Models.Tag.find({name:tag_name}).exec(function(err, tags){
            if (!tags || !tags.length){
                return;
            }
            var notification = new Models.Notification({
                username_for : username_for,
                username_by : username_by,
                tag_name: tag_name,
                mood: tags[0].mood,
                intensity: tags[0].intensity,
                recording_id : recording_id,
                type:"COMMENT"
            });
            notification.save();
        });
    });
}

exports.notifyFriends = function(Models, newRecording, type){
    // console.log("Notifying friends...");

    var query = Models.Friend.find({friend_of:newRecording.username});
    query.exec(function(err, friends) {

        if (!friends || friends.length===0){
            return;
        }
        friends.forEach(function(friend){

            setTimeout(function(){
                // console.log("notifying friend: "+friend.friend_id);
                Models.Notification.find({
                    username_for: friend.friend_id,
                    username_by : newRecording.username,
                    recording_id : newRecording._id
                }).exec(function(err, notifications){
                    // console.log("found these notifications: "+notifications);
                    if (!notifications || notifications.length===0){
                        // console.log("found no notifications for this recording and friend id");
                        // console.log("Looking for tag with name "+newRecording.tag_name);

                        //get tag information
                        Models.Tag.find({
                            name:newRecording.tag_name
                        }).exec(function(err, tags){

                            if (!tags || tags.length===0){
                                return;
                            }
                            var tag = tags[0];
                            // console.log("found tag with name "+tag.name);

                            var notification = new Models.Notification({
                                username_for : friend.friend_id,
                                username_by : newRecording.username,
                                tag_name: tag.name,
                                mood: tag.mood,
                                intensity: tag.intensity,
                                recording_id : newRecording._id,
                                type:"FRIEND_"+type
                            });

                            notification.save();
                        });
                    }
                },1);
            });
        });
    });
}
