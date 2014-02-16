var mongoose = require("mongoose");

exports = function(model){

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
        created_date: {
            type:Date, default:Date.now
        },
        last_update: {
            type:Date, default:Date.now
        }
    });

    var Recording = mongoose.model('Recording', recordingSchema);
    return new Recording(model);
};