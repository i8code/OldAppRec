package me.yapzap.api.v1.database;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("like_db_helper")
public class LikeDBHelper extends DBHelper {
    
    public static final String createLikeTable = "create table if not exists "+
        "RECORDINGS(id INT NOT NULL AUTO_INCREMENT, "+
        "_id varchar(255), "+
        "username varchar(255), "+
        "recording_id varchar(255), "+
        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
        "last_update TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "+
        "PRIMARY KEY (id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createLikeTable);
    }

}
