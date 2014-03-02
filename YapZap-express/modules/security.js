var Crypto = require('crypto');

var users = [{
    secret : "67989553EDCBD09B03942AB728CEC8FE5C7951F6",
    key    : "B64E4F862CC37A8116783A02770E91CC08F08E42",
}];

exports.getHash = function(secret, key, t){
    var shasum = Crypto.createHash('sha512');
    shasum.update(secret+key+t.toString());
    return shasum.digest('hex');
}

exports.check = function(req, res){

    //return true; //for now

    var t_in = req.query.t;
    var key = req.query.key;
    var token = req.query.token;

    // console.log("security check");

    // console.log(t_in);
    // console.log(key);
    // console.log(token);

    if (!t_in || !key || !token){
        res.send(401);
        return false;
    }

    for (var i=0;i<users.length;i++){
        var user = users[i];
        var hash = exports.getHash(user.secret, user.key, t_in);

        var t = (new Date()).getTime()/1000;
        var t_in_int = +t_in;

        // console.log("computed hash");
        // console.log(hash);
        // console.log(t);
        // console.log(t_in);
        // console.log("time "+(t_in_int<t && t_in_int+30000>t));

        if (hash===token && key===user.key && t_in_int<t && t_in_int+30000>t){
            return true;
        }
        
    }
    console.log("unauthorized");
    res.send(401);
    return false;
};

exports.getUsers = function(){
    return users;
}