var Base64 = require('./base64');

var hashIntMin = 1073741824;
var hashIntMax = 68719476735;
var hashIntRange = hashIntMax-hashIntMin;

var createHash = function(Models, filename, callback){
    var hashInt = Math.floor((Math.random()*hashIntRange)+hashIntMin);
    var hash = Base64.fromNumber(hashInt);

    Models.AudioMap.find({hash:hash}, function(err, maps){
        if (!maps || maps.length===0){
            //Yay not taken, creat it!
            var map = new Models.AudioMap({filename:filename, hash:hash});
            map.save();

            callback(hash);
        } else {
            createHash(Models, filename, callback);
        }
    });

}

exports.getOrCreateHash = function(Models, filename, callback){

    Models.AudioMap.find({filename:filename}, function(err, maps){

        if (!maps || maps.length===0){
             createHash(Models, filename, callback);
             return;
        }

         callback(maps[0].hash);
    });
    
}

exports.getFileName = function(Models, hash, callback){

    Models.AudioMap.find({hash:hash}, function(err, maps){

        if (!maps || maps.length===0){
            callback();
        }

         callback(maps[0].filename);

    });
    
}
