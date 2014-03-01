var n = 40, i=0, j=0;

var names = ["Jacob", "Mason", "Ethan", "Noah", "William", "Liam", "Jayden", "Michael", "Alexander", "Aiden", "Sophia", "Emma", "Isabella", "Olivia", "Ava", "Emily", "Abigail", "Mia", "Madison", "Elizabeth"];


function makeid()
{
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}


function genRecording(parentId){

    var waveform_data = [];
    //5*sin(at+b);
    var a = Math.random()*10;
    var b = Math.random()*10;

    for (var i=0;i<420;i++){
        waveform_data[i] = (Math.sin(a*i/500.0+b)*2.3).toFixed(5);
    }

    var parent_type = parentId?"REC":"TAG";
    var parent_name = parentId || "gameofthrones";
    var children_length = parentId?0:n;

    var likes = Math.floor(Math.random()*1500-500);
    if (likes<0){
        likes=0;
    }

    return {
        _id : makeid()+makeid()+makeid(),
        audio_hash:makeid(),
        parent_name: parent_name,
        username:names[Math.floor(Math.random()*names.length)],
        last_update: new Date(),
        created_date: new Date(),
        waveform_data : waveform_data,
        audio_url: "jasontest",
        popularity : (Math.random()*100).toFixed(3),
        likes: likes,
        intensity: 1,
        mood: (Math.random()*360).toFixed(0),
        parent_type: parent_type,
        children_length:0
    };
}

var recordings = [];

for (i=0;i<n;i++){
    var recording = genRecording();
    var children = [];
    var children_length = Math.floor(Math.random()*n-10);
    if (children_length<0) children_length=0;
    for (j=0;j<children_length;j++){
        children.push(genRecording(recording._id));
    }
    recording.children_length=  children_length;
    recording.children = children;
    recordings[recordings.length]=recording;
}

var recordingsStr = JSON.stringify(recordings).replace(/"/g, "\\\"");
document.write("@\""+recordingsStr+"\"");
