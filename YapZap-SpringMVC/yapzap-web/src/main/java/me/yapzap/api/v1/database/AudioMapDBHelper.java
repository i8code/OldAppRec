package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("audio_map_db_helper")
public class AudioMapDBHelper {
    
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
        Connection connection = null;
        Statement createTableStatement = null;
        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            
            createTableStatement = connection.createStatement();
            createTableStatement.execute(createAudioMapTable);

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
