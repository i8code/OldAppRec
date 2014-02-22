var updateCollection = function(Models, id, type){
    var query;
    if (type==="TAG"){
        query = Models.Tag.find({name:id});
    } else {
        query = Models.Recording.find({_id:id});
    }

    query.exec(function(err, parents) {
        if (!parents || parents.length===0){
            return;
        }

        var parent = parents[0]; //there should only be one at most

        var popularityCount = 1;
        var intensity = 0;
        var moodSin = 0;
        var moodCos = 0;

        var childrenQuery = Models.Recording.find({parent_name:id, parent_type:type});
        childrenQuery.exec(function(err, recordings) {
            if (recordings){
                for (var i=0;i<recordings.length;i++){
                    popularityCount+=recordings[i].popularity || 0;
                    popularityCount+=recordings[i].likes || 0;
                    intensity+=recordings[i].intensity || 0;

                    var mood = recordings[i].mood*Math.PI*2;
                    moodSin+= Math.sin(mood)*recordings[i].intensity;
                    moodCos+= Math.cos(mood)*recordings[i].intensity;
                }
                parent.children = recordings;
                parent.children_length=recordings.length||0;
                moodSin/=intensity||1;
                moodCos/=intensity||1;
                intensity=Math.sqrt(moodSin*moodSin+moodCos*moodCos);
            }

            var created_date = new Date(parent.created_date);
            var now = new Date();

            popularityCount/=(now.getTime()-created_date.getTime());
            parent.popularity = popularityCount*1000000;

            if (type==="TAG"){
                parent.intensity = intensity;
                var mood = Math.atan2(moodSin, moodCos);
                if (mood<0){
                    mood+=Math.PI*2;
                }
                parent.mood = mood/Math.PI/2.0;
            }
            parent.last_update = new Date();

            parent.save();

            if (parent.parent_name){
                //Recurse
                updateCollection(Models, parent.parent_name, parent.parent_type);
            }
        });

    });
}


exports.updateTagPopularity = function(Models, tagname){
    return updateCollection(Models, tagname, "TAG");

}

exports.updateRecordingPopularity = function(Models, recording_name){
    return updateCollection(Models, recording_name, "REC");
}