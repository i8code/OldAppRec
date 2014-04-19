package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("friend_db_helper")
public class FriendDBHelper {
    
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
        Connection connection = null;
        Statement createTableStatement = null;
        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            
            createTableStatement = connection.createStatement();
            createTableStatement.execute(createFriendTable);

        }
        catch (SQLException e) {
            Logger.log(ExceptionUtils.getStackTrace(e)); 
        }
        finally {
            try {

                if (createTableStatement != null) {
                    createTableStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            }
            catch (Exception e) {
            }
        }

    }

}
