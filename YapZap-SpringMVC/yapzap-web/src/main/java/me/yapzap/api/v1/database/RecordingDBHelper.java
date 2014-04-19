package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("recording_db_helper")
public class RecordingDBHelper {
    
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
        "waveform_data varchar(21845), "+
        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
        "last_update TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "+
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
            createTableStatement.execute(createRecordingTable);

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
