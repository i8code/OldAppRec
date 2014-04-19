package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;
import me.yapzap.api.v1.models.AudioMap;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("audio_map_db_helper")
public class AudioMapDBHelper extends DBHelper{
    
    public static final String createAudioMapTable = "create table if not exists "+
        "AUDIO_MAP("+
        "filename varchar(4096), "+
        "hash varchar(255), "+
        "PRIMARY KEY (hash));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createAudioMapTable);
    }
    


    public AudioMap getAudioMapFromSet(ResultSet set) throws SQLException{
        AudioMap audioMap = new AudioMap();
        audioMap.set_id(set.getString("_id"));
        audioMap.setFilename(set.getString("filename"));
        audioMap.setHash(set.getString("hash"));
        
        return  audioMap;
    }
    
    public String getFilenameForHash(String hash) {
        String selectAllStatement = "select filename from AUDIO_MAP where hash=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, hash);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                return results.getString("filename");
            }

        }
        catch (SQLException e) {
            Logger.log(ExceptionUtils.getStackTrace(e));
        }
        finally {
            try {
                if (queryStatement != null) {
                    queryStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            }
            catch (Exception e) {
            }
        }
        return null;
    }
    
    public void createMapping(String hash, String filename){
        String insertStatement = "insert into AUDIO_MAP(hash, filename)"
                        + " values(?,?);";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            int i=1;
            queryStatement.setString(i++, hash);
            queryStatement.setString(i++, filename);
            
            queryStatement.execute();
        }
        catch (SQLException e) {
            Logger.log(ExceptionUtils.getStackTrace(e));
        }
        finally {
            try {
                if (queryStatement != null) {
                    queryStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            }
            catch (Exception e) {
            }
        }
    }
    
    public void deleteMapping(String hash){
        String deleteStatement = "delete from AUDIO_MAP where hash=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,hash);
            queryStatement.execute();
        }
        catch (SQLException e) {
            Logger.log(ExceptionUtils.getStackTrace(e));
        }
        finally {
            try {
                if (queryStatement != null) {
                    queryStatement.close();
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