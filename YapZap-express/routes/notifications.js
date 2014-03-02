
var Security = require('../modules/security');


/* GET /notifications/:username
 */
exports.getByUser = function(Models) {
    return function(req, res) {
        if (!Security.check(req, res)) return;

        var username = req.params.username;

        if (!username){
            res.send(422);
            return;
        }

        // console.log("Notifications");
        // console.log(username);
        // console.log(req.query.after);

        var after, query;
        if (req.query.after){
            after = new Date(req.query.after);
            query = Models.Notification.find({
                username_for: username,
                created_date:{"$gte": after}
            });
        }
        else {
            query = Models.Notification.find({
                username_for: username
            });
        }

        query.limit(50).sort({created_date: -1}).exec(function(err, notifications) {

            if (!notifications || notifications.length==0){
                res.status(404);
                res.send([]);
                return;
            }
            res.status(200);
            res.send(notifications);
        });
    };
};
