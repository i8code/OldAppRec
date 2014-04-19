package me.yapzap.api.v1.database;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("friend_db_helper")
public class FriendDBHelper extends DBHelper {
    
    public static final String createFriendTable = "create table if not exists "+
        "FRIENDS(id INT NOT NULL AUTO_INCREMENT, "+
        "_id varchar(255), "+
        "friend_id varchar(255), "+
        "friend_of varchar(255), "+
        "PRIMARY KEY (id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createFriendTable);

    }

}
