package me.yapzap.api.v1.controllers;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import me.yapzap.api.v1.database.FriendDBHelper;
import me.yapzap.api.v1.database.LikeDBHelper;
import me.yapzap.api.v1.database.NotificationDBHelper;
import me.yapzap.api.v1.database.RecordingDBHelper;
import me.yapzap.api.v1.database.TagDBHelper;
import me.yapzap.api.v1.models.Like;
import me.yapzap.api.v1.models.NotificationType;
import me.yapzap.api.v1.models.ParentType;
import me.yapzap.api.v1.models.Recording;
import me.yapzap.api.v1.updaters.CollectionManager;
import me.yapzap.api.v1.updaters.NotificationManager;

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


    @Autowired
    private RecordingDBHelper recordingDBHelper;
    
    @Autowired
    private FriendDBHelper friendDBHelper;

    @Autowired
    private TagDBHelper tagDBHelper;

    @Autowired
    private NotificationDBHelper notificationDBHelper;

    @RequestMapping(value = "recordings/{id}/likes", method = RequestMethod.GET)
    @ResponseBody
    public List<Like> getLikesForRecording(@PathVariable(value = "id") String id) {
        return likeDBHelper.getAllForRecording(id);
    }

    @RequestMapping(value = "recordings/{id}/likes/{username}", method = RequestMethod.GET)
    @ResponseBody
    public Like getLikesForRecording(@PathVariable(value = "id") String id, @PathVariable(value = "username") String username, HttpServletRequest request, HttpServletResponse response) throws IOException {
        
        String url = request.getRequestURI();
        int indexOfLikes = url.indexOf("/likes/");
        final String betterUsername = URLDecoder.decode(url.substring(indexOfLikes+7), "UTF-8");
        
        Like like = likeDBHelper.getById(id, betterUsername);
        if (like == null) {
            response.sendError(404);
            return null;
        }
        return likeDBHelper.getById(id, betterUsername);
    }

    public void updateLikes(final String recordingId, final int delta) {
        
        Thread t = new Thread(new Runnable(){

            @Override
            public void run() {
                Recording recording = recordingDBHelper.getById(recordingId);
                
                recording.setLikes(recording.getLikes()+delta);
                recordingDBHelper.updateRecording(recording);
                
                Thread updateLikes;
                
                if (recording.getParentType() == ParentType.TAG) {
                    updateLikes = new Thread(new CollectionManager.UpdateTagPopularity(recording.getTagName(), tagDBHelper, recordingDBHelper, notificationDBHelper));
                }
                else {
                    updateLikes = new Thread(new CollectionManager.UpdateRecordingPopularity(recording.getParentName(), tagDBHelper, recordingDBHelper, notificationDBHelper));
                }
                
                updateLikes.start();
                
            }});

        
        t.start();

    }

    @RequestMapping(value = "recordings/{id}/likes", method = RequestMethod.POST)
    @ResponseBody
    public Like createLikeForUser(final @PathVariable(value = "id") String id, final @RequestBody HashMap<String, String> usernameMap, HttpServletResponse response) throws IOException {

        String username = usernameMap.get("username");
        Like like = likeDBHelper.getById(id, username);

        if (like == null) {
            like = likeDBHelper.createLike(id, username);
        }
        
        updateLikes(id, 1);
        
        
        //Notify of likes
        Thread likeNotification = new Thread( new
                        NotificationManager.AddNotification(username, like.getRecordingId(), NotificationType.LIKE, tagDBHelper, recordingDBHelper, notificationDBHelper));

        Thread notifyFriends = new Thread(new 
                        NotificationManager.NotifyFriends(recordingDBHelper.getById(like.getRecordingId()), NotificationType.FRIEND_LIKE,  tagDBHelper, notificationDBHelper, friendDBHelper));
        
        likeNotification.start();
        notifyFriends.start();

        response.setStatus(201);
        return like;
    }

    @RequestMapping(value = "recordings/{id}/likes/{username}", method = RequestMethod.DELETE)
    @ResponseBody
    public Like deleteLike(final @PathVariable(value = "id") String id, final @RequestBody String username, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String url = request.getRequestURI();
        int indexOfLikes = url.indexOf("/likes/");
        final String betterUsername = URLDecoder.decode(url.substring(indexOfLikes+7), "UTF-8");
        
        Like like = likeDBHelper.deleteById(id, betterUsername);
        updateLikes(id, -1);
        notificationDBHelper.deleteAllForLike(like);
        
        response.setStatus(201);
        return like;
    }
}
