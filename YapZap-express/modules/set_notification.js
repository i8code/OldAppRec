
exports.addNotificationForLike = function(Models, username_by, recording_id){
    //If it's a like, the the recording id is of the recording we are looking for
    //We need to its parent to find the tag name
    console.log("Adding like notification by "+username_by+" for "+recording_id);

    var query = Models.Recording.find({_id:recording_id});
    query.exec(function(err, recordings) {

        if (!recordings || recordings.length==0){
            return;
        }

        var parent_recording = recordings[0];
        var username_for = parent_recording.username;
        console.log("found target: "+username_for);

        if (parent_recording.parent_type==="TAG"){
            //We have all the information we need
            var tag_name = parent_recording.parent_name;

            var notification = new Models.Notification({
                username_for : username_for,
                username_by : username_by,
                tag_name: tag_name,
                recording_id : recording_id,
                type:"LIKE"
            });
            notification.save();
            return;
        }

        //Search for tag information
        console.log("searching for tag information");
        var parent_query = Models.Recording.find({_id:parent_recording.parent_name});
        parent_query.exec(function(err, recordings) {

            if (!recordings || recordings.length==0){
                return;
            }
            var tag_name = recordings[0].parent_name;

            var notification = new Models.Notification({
                username_for : username_for,
                username_by : username_by,
                tag_name: tag_name,
                recording_id : recording_id,
                type:"LIKE"
            });
            notification.save();

        });
    });
}


exports.addNotificationForComment = function(Models, username_by, recording_parent){
    //If it's a comment, then the parent must be a recording
    //Need to get the parent info
    console.log("Adding comment notification by "+username_by+" for "+recording_parent);

    var query = Models.Recording.find({_id:recording_parent});
    query.exec(function(err, recordings) {

        if (!recordings || recordings.length==0){
            return;
        }
        var parent =recordings[0];
        var username_for = parent.username;
        var tag_name = parent.parent_name;

        var notification = new Models.Notification({
            username_for : username_for,
            username_by : username_by,
            tag_name: tag_name,
            recording_id : recording_parent,
            type:"COMMENT"
        });
        notification.save();

    });
}

