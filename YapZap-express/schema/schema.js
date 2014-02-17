var mongoose = require("mongoose");
mongoose.connect('localhost:27017/yapzap');

var tagSchema = new mongoose.Schema({
    name : {
        type: String,
        trim: true
    },
    popularity :{
        type:Number, default:0
    },
    mood :{
        type: Number
    },
    intensity :{
        type: Number
    },
    created_date: {
        type:Date, default:Date.now
    },
    last_update: {
        type:Date, default:Date.now
    }
});

var recordingSchema = new mongoose.Schema({
    username : {
        type: String,
        trim: true
    },
    tag_id :{
        type:String
    },
    mood :{
        type: Number
    },
    intensity :{
        type: Number
    },
    audio_url:{
        type:String
    },
    waveform_data: [Number],
    created_date: {
        type:Date, default:Date.now
    },
    last_update: {
        type:Date, default:Date.now
    }
});

var likeSchema = new mongoose.Schema({
    tag_name : {
        type: String,
        trim: true
    },
    username : {
        type: String,
        trim: true
    },
    created_date: {
        type:Date, default:Date.now
    },
    last_update: {
        type:Date, default:Date.now
    }
});

module.exports.Recording = mongoose.model('Recordings', recordingSchema);
module.exports.Tag = mongoose.model('Tags', tagSchema);
module.exports.Like = mongoose.model('Likes', likeSchema);

module.exports.mongoose = mongoose;