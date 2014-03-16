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
    children_length :{
        type: Number, default:0
    },
    mood :{
        type: Number, default:0
    },
    intensity :{
        type: Number, default:0
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
    parent_name :{
        type:String
    },
    parent_type :{
        type:String, default: "TAG"
    },
    tag_name:{
        type:String
    },
    children:{
        type:Array, default:[]
    },
    children_length :{
        type: Number, default:0
    },
    mood :{
        type: Number, default:0
    },
    intensity :{
        type: Number, default:0
    },
    likes : {
        type:Number, default:0
    },
    popularity :{
        type:Number, default:1
    },
    audio_url:{
        type:String,
        default: "jasontest"
    },
    audio_hash:{
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
    username : {
        type: String,
        trim: true
    },
    recording_id :{
        type:String
    },
    created_date: {
        type:Date, default:Date.now
    },
    last_update: {
        type:Date, default:Date.now
    }
});

var notificationSchema = new mongoose.Schema({
    username_for : {
        type: String,
        trim: true
    },
    username_by : {
        type: String,
        trim: true
    },
    mood :{
        type: Number, default:0
    },
    intensity :{
        type: Number, default:0
    },
    tag_name:{
        type:String
    },
    recording_id :{
        type:String
    },
    created_date: {
        type:Date, default:Date.now
    },
    type:{
        type:String
    }
});

var audioMapSchema = new mongoose.Schema({
    filename : {
        type: String,
    },
    hash :{
        type:String
    }
});

var friendSchema = new mongoose.Schema({
    friend_id : {
        type: String,
    },
    friend_of :{
        type:String
    }
});

module.exports.Recording = mongoose.model('Recordings', recordingSchema);
module.exports.Tag = mongoose.model('Tags', tagSchema);
module.exports.Like = mongoose.model('Likes', likeSchema);
module.exports.Notification = mongoose.model('Notification', notificationSchema);
module.exports.AudioMap = mongoose.model('AudioMap', audioMapSchema);
module.exports.Friend = mongoose.model('Friend', friendSchema);

module.exports.mongoose = mongoose;