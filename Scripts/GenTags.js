var names= ["sausage", "blubber", "pencil", "cloud", "moon", "water", "computer", "school", "network", "hammer", "walking", "violently", "mediocre", "literature", "chair", "two", "window", "cords", "musical", "zebra", "xylophone", "penguin", "home", "dog", "final", "ink", "teacher", "fun", "website", "banana", "uncle", "softly", "mega", "ten", "awesome", "attatch", "blue", "internet", "bottle", "tight", "zone", "tomato", "prison", "hydro", "cleaning", "telivision", "send", "frog", "cup", "book", "zooming", "falling", "evily", "gamer", "lid", "juice", "moniter", "captain", "bonding", "loudly", "thudding", "guitar", "shaving", "hair", "soccer", "water", "racket", "table", "late", "media", "desktop", "flipper", "club", "flying", "smooth", "monster", "purple", "guardian", "bold", "hyperlink", "presentation", "world", "national", "comment", "element", "magic", "lion", "sand", "crust", "toast", "jam", "hunter", "forest", "foraging", "silently", "tawesomated", "joshing", "pong"];


function makeid()
{
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 30; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

var tags = [];
for (var i=0;i<names.length;i++){
    tags[i]={
        _id : makeid(),
        name : names[i],
        last_update: new Date(),
        created_date: new Date(),
        intensity: 1,
        mood: Math.random()*360,
        children:0,
        popularity: Math.pow(names.length-i, 3)
    };
}

var tagsJson = JSON.stringify(tags).replace(/"/g, "\\\"");
document.write("\""+tagsJson+"\"");