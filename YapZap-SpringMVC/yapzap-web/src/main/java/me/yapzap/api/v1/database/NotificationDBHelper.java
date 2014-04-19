package me.yapzap.api.v1.database;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("notifications_db_helper")
public class NotificationDBHelper extends DBHelper {
    
    public static final String createNotificationsTable = "create table if not exists "+
        "NOTIFICATIONS(id INT NOT NULL AUTO_INCREMENT, "+
        "_id varchar(255), "+
        "username_for varchar(255), "+
        "username_by varchar(255), "+
        "tag_name varchar(255), "+
        "recording_id varchar(255), "+
        "type varchar(255), "+
        "mood FLOAT DEFAULT 0 ,"+
        "intensity FLOAT DEFAULT 0, "+
        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
        "last_update TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "+
        "PRIMARY KEY (id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createNotificationsTable);
    }

}
