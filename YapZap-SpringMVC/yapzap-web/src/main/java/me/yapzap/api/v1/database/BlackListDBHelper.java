package me.yapzap.api.v1.database;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("blacklist_db_helper")
public class BlackListDBHelper extends DBHelper {
    
    public static final String createBlackListTable = "create table if not exists "+
        "BLACKLIST("+
        "username varchar(255), "+
        "PRIMARY KEY (username));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createBlackListTable);

    }

}
