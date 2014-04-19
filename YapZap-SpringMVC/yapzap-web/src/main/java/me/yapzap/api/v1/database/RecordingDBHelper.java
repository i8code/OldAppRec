package me.yapzap.api.v1.database;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("recording_db_helper")
public class RecordingDBHelper extends DBHelper {
    
    public static final String createRecordingTable = "create table if not exists "+
        "RECORDINGS(id INT NOT NULL AUTO_INCREMENT, "+
        "_id varchar(255), "+
        "username varchar(255), "+
        "parent_name varchar(255), "+
        "parent_type varchar(255), "+
        "tag_name varchar(255), "+
        "popularity FLOAT DEFAULT 0, "+
        "mood FLOAT DEFAULT 0 ,"+
        "intensity FLOAT DEFAULT 0, "+
        "children_length INT DEFAULT 0, "+
        "likes INT DEFAULT 0, "+
        "audio_url varchar(255), "+
        "audio_hash varchar(255), "+
        "waveform_data varchar(16384), "+
        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
        "last_update TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "+
        "PRIMARY KEY (id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createRecordingTable);
    }

}
