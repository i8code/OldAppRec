var mongoose = require("mongoose");

exports = function(model){

    var likeSchema = new mongoose.Schema({
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

    var Like = mongoose.model('Like', likeSchema);
    return new Like(model);
};