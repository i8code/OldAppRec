package me.yapzap.api.v1.updaters;

import java.util.Date;
import java.util.List;

import me.yapzap.api.v1.database.NotificationDBHelper;
import me.yapzap.api.v1.database.RecordingDBHelper;
import me.yapzap.api.v1.database.TagDBHelper;
import me.yapzap.api.v1.models.MoodyModel;
import me.yapzap.api.v1.models.ParentType;
import me.yapzap.api.v1.models.Recording;
import me.yapzap.api.v1.models.Tag;

public class CollectionManager {
    
    public static class CollectionUpdater implements Runnable{
        
        private String id;
        private ParentType type;
        private TagDBHelper tagDBHelper;
        private RecordingDBHelper recordingDBHelper;
        private NotificationDBHelper notificationDBHelper;
        
        public CollectionUpdater(String id, ParentType type, TagDBHelper tagDBHelper, RecordingDBHelper recordingDBHelper, NotificationDBHelper notificationDBHelper) {
            super();
            this.id = id;
            this.type = type;
            this.tagDBHelper = tagDBHelper;
            this.recordingDBHelper = recordingDBHelper;
            this.notificationDBHelper = notificationDBHelper;
        }
        protected void updateMoodyModel(MoodyModel model){
            
            if (model==null){
                return;
            }
            
            //Find all its children
            List<Recording> recordings;
            
            if (model.getClass().equals(Tag.class)){
                recordings = recordingDBHelper.getAllForParentName(((Tag)model).getName(), true);
            }
            else {
                recordings = recordingDBHelper.getAllForParentName(((Recording)model).get_id(), true);
            }

            double popularityCount=1;
            double intensity=0.5;
            double moodSin=0;
            double moodCos=0; 
            
            for (Recording childRecording : recordings){
                popularityCount+=childRecording.getPopularity();
                popularityCount+=childRecording.getLikes();
//                intensity+=childRecording.getIntensity();
                
                double mood = childRecording.getMood()*Math.PI*2.0;
                moodSin+=Math.sin(mood)*childRecording.getIntensity();
                moodCos+=Math.cos(mood)*childRecording.getIntensity();
            }
            
            model.setChildrenLength(recordings.size());
            popularityCount/=((new Date()).getTime()-model.getCreatedDate().getTime()+1e5);
            model.setPopularity((float) (popularityCount*1e7));
            model.setLastUpdate(new Date());
            
            MoodyModel parent = null;
            
            if (model.getClass().equals(Tag.class)){
                model.setIntensity((float) intensity);
                double mood = Math.atan2(moodSin, moodCos);
                if (mood<0){
                    mood+=Math.PI*2;
                }
                model.setMood((float) (mood/Math.PI/2.0));
                
                if (model.getChildrenLength()==0){
                    //Delete the tag
                    String name = ((Tag)model).getName();
                    tagDBHelper.deleteTag(name);
                    notificationDBHelper.deleteAllForTagName(name);
                    
                }
                else {
                    tagDBHelper.updateTag((Tag)model);
                }
            }
            else {
                
                Recording recording = (Recording)model;
                recordingDBHelper.updateRecording(recording);
                
                if (recording.getParentType()==ParentType.TAG){
                    parent = tagDBHelper.getByName(recording.getParentName());
                }
                else{
                    parent = recordingDBHelper.getById(recording.getParentName());
                }
            }
            
            
            
            //Then update its parent
            updateMoodyModel(parent);
        }

        public void run() {
            if (type==ParentType.TAG){
                updateMoodyModel(tagDBHelper.getByName(id));
            }
            else{
                updateMoodyModel(recordingDBHelper.getById(id));
            }
        }
    } 

    public static class UpdateTagPopularity extends CollectionUpdater
    {
        public UpdateTagPopularity(String tagName, TagDBHelper tagDBHelper, RecordingDBHelper recordingDBHelper, NotificationDBHelper notificationDBHelper) {
            super(tagName, ParentType.TAG, tagDBHelper, recordingDBHelper, notificationDBHelper);
        }
    }
    
    public static class UpdateRecordingPopularity extends CollectionUpdater
    {
        public UpdateRecordingPopularity(String id, TagDBHelper tagDBHelper, RecordingDBHelper recordingDBHelper, NotificationDBHelper notificationDBHelper) {
            super(id, ParentType.REC, tagDBHelper, recordingDBHelper, notificationDBHelper);
        }
    }

}
