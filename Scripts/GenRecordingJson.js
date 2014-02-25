var n = 100, i=0, j=0;


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
        waveform_data[i] = Math.sin(a*i+b)*5;
    }

    var parent_type = parentId?"REC":"TAG";
    var parent_name = parentId || "gameofthrones";
    var children_length = parentId?0:n;

    return {
        _id : makeid()+makeid()+makeid(),
        audio_hash:makeid(),
        parent_name: parent_name,
        username:"jason",
        last_update: new Date(),
        created_date: new Date(),
        waveform_data : waveform_data,
        audio_url: "jasontest",
        popularity : Math.random()*100,
        likes: Math.floor(Math.random()*1000),
        intensity: 1,
        mood: Math.random()*360,
        parent_type: parent_type,
        children_length:children_length
    };
}

var recordings = [];

for (i=0;i<n;i++){
    var recording = genRecording();
    var children = [];
    for (j=0;j<n;j++){
        children.push(genRecording(recording._id));
    }
    recording.children = children;
    recordings[recordings.length]=recording;
}

var recordingsStr = JSON.stringify(recordings).replace(/"/g, "\\\"");
document.write("\""+recordingsStr+"\"");
