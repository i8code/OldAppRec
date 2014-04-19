package me.yapzap.api.v1.database;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("audio_map_db_helper")
public class AudioMapDBHelper extends DBHelper{
    
    public static final String createAudioMapTable = "create table if not exists "+
        "AUDIO_MAP("+
        "_id varchar(255), "+
        "filename varchar(4096), "+
        "hash varchar(255), "+
        "PRIMARY KEY (hash));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createAudioMapTable);

    }

}
