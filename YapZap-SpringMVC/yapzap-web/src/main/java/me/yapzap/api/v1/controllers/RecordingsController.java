package me.yapzap.api.v1.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import me.yapzap.api.v1.database.AudioMapDBHelper;
import me.yapzap.api.v1.database.RecordingDBHelper;
import me.yapzap.api.v1.database.TagDBHelper;
import me.yapzap.api.v1.models.ParentType;
import me.yapzap.api.v1.models.Recording;
import me.yapzap.api.v1.models.Tag;

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
    private AudioMapDBHelper audioMapDBHelper;

    @RequestMapping(value = { "recordings/{name}/recordings", "tags/{name}/recordings" }, method = RequestMethod.GET)
    @ResponseBody
    public List<Recording> getRecordings(HttpServletRequest request, @PathVariable("name") String name) {
        String path = request.getRequestURI();
        boolean sortAsc = !path.subSequence(0, 5).equals("/tags");
        return recordingDBHelper.getAllForParentName(name, sortAsc);
    }

    @RequestMapping(value = { "recordings/{id}" }, method = RequestMethod.GET)
    @ResponseBody
    public Recording getById(@PathVariable("id") String id, HttpServletResponse response) throws IOException {
        Recording recording = recordingDBHelper.getById(id);
        if (recording==null){
            response.sendError(404);
            return null;
        }
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
        
        /*
         *  RecordingUpdater.updateTagPopularity(Models, name);
                    }, 1);
                } else {
                    setTimeout(function(){
                        RecordingUpdater.updateRecordingPopularity(Models, name);
                    }, 1);
                    setTimeout(function(){
                        NotificationManager.addNotificationForComment(Models, recording.username, recording.parent_name, recording._id);
                    }, 1);
                }

                setTimeout(function(){
                    NotificationManager.notifyFriends(Models, recording, type);
         */
        
        return recording;
    }
    

    @RequestMapping(value = { "recordings/{id}" }, method = RequestMethod.PUT)
    @ResponseBody
    public Recording updateRecording(@PathVariable("id") String id, @RequestBody Recording recording, HttpServletRequest request, HttpServletResponse response) throws IOException {
        recording.set_id(id);
        recording = recordingDBHelper.updateRecording(recording);
        
        /*
         *   RecordingUpdater.updateTagPopularity(Models, recording.parent_name);
                },1);
            } else {
                setTimeout(function(){
                    RecordingUpdater.updateRecordingPopularity(Models, recording.parent_name);
         */
        
        return recording;
    }
    
    @RequestMapping(value = { "recordings/{id}" }, method = RequestMethod.DELETE)
    @ResponseBody
    public Recording deleteRecording(@PathVariable("id") String id, HttpServletRequest request, HttpServletResponse response) throws IOException {
        final Recording recording = recordingDBHelper.deleteById(id);
        
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                recordingDBHelper.deleteAllWithParentId(recording.getParentName());
                
                /*if (recording.parent_type==="TAG"){
                    setTimeout(function(){
                        RecordingUpdater.updateTagPopularity(Models, recording.parent_name);
                    },1);
                } else {
                    setTimeout(function(){
                        RecordingUpdater.updateRecordingPopularity(Models, recording.parent_name);
                    },1);
                }*/
            }
        });
        t.start();
        
        return recording;
    }
    
    
    @RequestMapping(value = { "users/{username}/recordings" }, method = RequestMethod.DELETE)
    @ResponseBody
    public List<Recording> recordingsForUser(@PathVariable("username") String username, HttpServletRequest request, HttpServletResponse response) throws IOException {
        return recordingDBHelper.getAllRecordingsForUser(username);
    }

}
