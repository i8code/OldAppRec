package me.yapzap.api.v1.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import me.yapzap.api.v1.database.LikeDBHelper;
import me.yapzap.api.v1.models.Like;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class LikeController {

    @Autowired
    private LikeDBHelper likeDBHelper;

    @RequestMapping(value = "recordings/{id}/likes", method = RequestMethod.GET)
    @ResponseBody
    public List<Like> getLikesForRecording(@PathVariable(value = "id") String id) {
        return likeDBHelper.getAllForRecording(id);
    }

    @RequestMapping(value = "recordings/{id}/likes/{username}", method = RequestMethod.GET)
    @ResponseBody
    public Like getLikesForRecording(@PathVariable(value = "id") String id, @PathVariable(value = "username") String username, HttpServletResponse response) throws IOException {
        Like like = likeDBHelper.getById(id, username);
        if (like == null) {
            response.sendError(404);
            return null;
        }
        return likeDBHelper.getById(id, username);
    }

    public void updateLikes(String recordingId) {

    }

    @RequestMapping(value = "recordings/{id}/likes", method = RequestMethod.POST)
    @ResponseBody
    public Like createLikeForUser(final @PathVariable(value = "id") String id, final @RequestBody String username, HttpServletResponse response) throws IOException {

        Like like = likeDBHelper.getById(id, username);

        if (like == null) {
            like = likeDBHelper.createLike(id, username);
        }

        // TODO:
        /**
         * updateLikes(Models, id, 1);
         * NotificationManager.addNotificationForLike(Models, username, id);
         * NotificationManager.notifyFriends(Models, recordings[0], "LIKE");
         */

        response.setStatus(201);
        return like;
    }

    @RequestMapping(value = "recordings/{id}/likes/{username}", method = RequestMethod.DELETE)
    @ResponseBody
    public Like deleteLike(final @PathVariable(value = "id") String id, final @RequestBody String username, HttpServletResponse response) throws IOException {

        Like like = likeDBHelper.deleteById(id, username);

        // TODO:
        /**
         * updateLikes(Models, id, 1);
         * NotificationManager.addNotificationForLike(Models, username, id);
         * NotificationManager.notifyFriends(Models, recordings[0], "LIKE");
         */

        response.setStatus(201);
        return like;
    }
}
