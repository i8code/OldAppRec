package me.yapzap.api.v1.controllers;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import me.yapzap.api.v1.database.AudioMapDBHelper;
import me.yapzap.api.v1.database.FriendDBHelper;
import me.yapzap.api.v1.database.NotificationDBHelper;
import me.yapzap.api.v1.database.RecordingDBHelper;
import me.yapzap.api.v1.database.TagDBHelper;
import me.yapzap.api.v1.models.NotificationType;
import me.yapzap.api.v1.models.ParentType;
import me.yapzap.api.v1.models.Recording;
import me.yapzap.api.v1.models.Tag;
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
public class RecordingsController {

    @Autowired
    private RecordingDBHelper recordingDBHelper;

    @Autowired
    private TagDBHelper tagDBHelper;

    @Autowired
    private NotificationDBHelper notificationDBHelper;
    
    @Autowired
    private FriendDBHelper friendDBHelper;
    
    @Autowired
    private AudioMapDBHelper audioMapDBHelper;
    
    @ResponseBody
    @RequestMapping(value = { "recordings/{name}/recordings", "tags/{name}/recordings" }, method = RequestMethod.GET)
    public List<Recording> getRecordings(HttpServletRequest request, @PathVariable("name") String name) {
        String path = request.getRequestURI();
        boolean sortAsc = !path.subSequence(0, 5).equals("/tags");
        List<Recording> recordings = recordingDBHelper.getAllForParentName(name, sortAsc);
        for (Recording recording : recordings){
            recording.setChildren(recordingDBHelper.getAllForParentName(recording.get_id(), !sortAsc));
        }

        return recordings;
    }

    @RequestMapping(value = { "recordings/{id}" }, method = RequestMethod.GET)
    @ResponseBody
    public Recording getById(@PathVariable("id") String id, HttpServletResponse response) throws IOException {
        Recording recording = recordingDBHelper.getById(id);
        if (recording==null){
            response.sendError(404);
            return null;
        }

        recording.setChildren(recordingDBHelper.getAllForParentName(recording.getParentName(), recording.getParentType()==ParentType.TAG?false:true));
        return recording;
    }
    
    @RequestMapping(value = { "recordings/{name}/recordings", "tags/{name}/recordings" }, method = RequestMethod.POST)
    @ResponseBody
    public Recording createRecording(@PathVariable("name") String name, @RequestBody Recording recording, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String path = request.getRequestURI();
        boolean tag = path.subSequence(0, 5).equals("/tags");
        
        if (tag){
            recording.setParentType(ParentType.TAG);
            recording.setTagName(name);
            Tag parentTag = tagDBHelper.getByName(name);
            if (parentTag==null){
                Tag parent = new Tag();
                parent.setName(name);
                tagDBHelper.createTag(parent);
            }
        }
        else{
            recording.setParentType(ParentType.REC);
            
            if (recording.getTagName()==null){
                Recording parent = recordingDBHelper.getById(name);
                recording.setTagName(parent.getTagName());
            }
        }
        
        recording.setParentName(name);
        recording.setPopularity(1f);
        recording.setAudioHash(audioMapDBHelper.getOrCreateHash(recording.getAudioUrl()));
        
        recording = recordingDBHelper.createRecording(recording);
        recording.setChildren(new ArrayList<Recording>());
                
        Thread updatePopularity = null;
        
        NotificationType notificationType;
        if (recording.getParentType()==ParentType.TAG){
            notificationType = NotificationType.FRIEND_TAG;
            updatePopularity =  new Thread(new CollectionManager.UpdateTagPopularity(recording.getTagName(), tagDBHelper, recordingDBHelper, notificationDBHelper));
        }
        else {
            notificationType = NotificationType.FRIEND_REC;
            updatePopularity =  new Thread(new CollectionManager.UpdateRecordingPopularity(name, tagDBHelper, recordingDBHelper, notificationDBHelper));
            
            //This must be a comment
            Thread commentNotification = new Thread( new
                            NotificationManager.AddNotification(recording.getUsername(), recording.getParentName(), recording.get_id(), NotificationType.COMMENT, tagDBHelper, recordingDBHelper, notificationDBHelper));
            
            commentNotification.start();
        }
        
        Thread notifyFriends = new Thread(new 
                        NotificationManager.NotifyFriends(
                        		recording.getUsername(),
                        		recording.getTagName(),
                        		recording.get_id(),
                        		notificationType,
                        		tagDBHelper,
                        		recordingDBHelper,
                        		notificationDBHelper,
                        		friendDBHelper));
        
        updatePopularity.start();
        notifyFriends.start();
        
        return recording;
    }
    

    @RequestMapping(value = { "recordings/{id}" }, method = RequestMethod.PUT)
    @ResponseBody
    public Recording updateRecording(@PathVariable("id") String id, @RequestBody Recording recording, HttpServletRequest request, HttpServletResponse response) throws IOException {
        recording.set_id(id);
        recording = recordingDBHelper.updateRecording(recording);
        recording.setChildren(recordingDBHelper.getAllForParentName(recording.getParentName(), recording.getParentType() == ParentType.TAG ? false : true));

        Thread updatePopularity = null;

        if (recording.getParentType() == ParentType.TAG) {
            updatePopularity = new Thread(new CollectionManager.UpdateTagPopularity(recording.getTagName(), tagDBHelper, recordingDBHelper, notificationDBHelper));
        }
        else {
            updatePopularity = new Thread(new CollectionManager.UpdateRecordingPopularity(recording.getParentName(), tagDBHelper, recordingDBHelper, notificationDBHelper));
        }
        
        updatePopularity.start();

        return recording;
    }
    
    @RequestMapping(value = { "recordings/{id}" }, method = RequestMethod.DELETE)
    @ResponseBody
    public Recording deleteRecording(@PathVariable("id") String id) throws IOException {
        final Recording recording = recordingDBHelper.deleteById(id);
        
        Thread t = new Thread(new Runnable() {
            
            private void deleteRecording(Recording recording){
                List<Recording> children = recordingDBHelper.getAllForParentName(recording.get_id(), true);
                recordingDBHelper.deleteById(recording.get_id());
                
                for(Recording child : children){
                    deleteRecording(child);
                }
            }
            
            @Override
            public void run() {
                
                deleteRecording(recording);
                
                notificationDBHelper.deleteAllForRecordingId(recording.get_id());
                
                Thread updatePopularity = null;

                if (recording.getParentType() == ParentType.TAG) {
                    updatePopularity = new Thread(new CollectionManager.UpdateTagPopularity(recording.getTagName(), tagDBHelper, recordingDBHelper, notificationDBHelper));
                }
                else {
                    updatePopularity = new Thread(new CollectionManager.UpdateRecordingPopularity(recording.getParentName(), tagDBHelper, recordingDBHelper, notificationDBHelper));
                }
                
                updatePopularity.start();
            }
        });
        t.start();
        
        return recording;
    }
    
    
    @RequestMapping(value = { "users/{username}/recordings" }, method = RequestMethod.GET)
    @ResponseBody
    public List<Recording> recordingsForUser(@PathVariable("username") String username, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = request.getRequestURI();
        String betterUsername = url.substring(7).split("/")[0];
        betterUsername = URLDecoder.decode(betterUsername, "UTF-8");
        
        List<Recording> recordings = recordingDBHelper.getAllRecordingsForUser(betterUsername);
        for (Recording recording : recordings){
            recording.setChildren(recordingDBHelper.getAllForParentName(recording.get_id(), true));
        }
        return recordings;
    }

}
