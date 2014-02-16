var mongoose = require("mongoose");

exports = function(model){

    var tagSchema = new mongoose.Schema({
        name : {
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

    var Tag = mongoose.model('Tag', tagSchema);
    return new Tag(model);
};