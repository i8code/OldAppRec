package me.yapzap.api.v1.database;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("friend_db_helper")
public class FriendDBHelper extends DBHelper {
    
    public static final String createFriendTable = "create table if not exists "+
        "FRIENDS("+
        "_id varchar(255)  NOT NULL , "+
        "friend_id varchar(255), "+
        "friend_of varchar(255), "+
        "PRIMARY KEY (_id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createFriendTable);

    }

}
