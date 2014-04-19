package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;
import me.yapzap.api.v1.models.Like;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("like_db_helper")
public class LikeDBHelper extends DBHelper {
    
    public static final String createLikeTable = "create table if not exists "+
        "RECORDINGS("+
        "_id varchar(255) NOT NULL, "+
        "username varchar(255), "+
        "recording_id varchar(255), "+
        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
        "last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "+
        "PRIMARY KEY (_id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createLikeTable);
    }
    

    public Like getLikeFromResultSet(ResultSet set) throws SQLException{
        Like like = new Like();
        like.set_id(set.getString("_id"));
        like.setUsername(set.getString("username"));
        like.setRecordingId(set.getString("recording_id"));
        like.setCreatedDate(convertDate(set.getTimestamp("created_date")));
        like.setLastUpdate(convertDate(set.getTimestamp("last_update")));
        
        return  like;
    }
    
    public List<Like> getAllForRecording(String recordingId) {
        List<Like> likes = new ArrayList<>();
        
        String selectAllStatement = "select * from LIKES where recording_id=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, recordingId);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                likes.add(getLikeFromResultSet(results));
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
        return likes;
    }
    
    public Like getById(String recordingId, String username) {
        String selectAllStatement = "select * from LIKES where recording_id=? AND username=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, recordingId);
            queryStatement.setString(2, username);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                return getLikeFromResultSet(results);
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
    
    public Like createLike(Like like){
        like.set_id(UUID.randomUUID().toString());
        String insertStatement = "insert into LIKES(_id, username, recording_id)"
                        + " values(?,?,?);";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            int i=1;
            queryStatement.setString(i++, like.get_id());
            queryStatement.setString(i++, like.getUsername());
            queryStatement.setString(i++, like.getRecordingId());
            
            queryStatement.execute();
            
            return getById(like.getRecordingId(), like.getUsername());
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
    
    public Like deleteById(String recordingId, String username){
        
        Like deleting = getById(recordingId, username);
        
        if (deleting==null){
            return null;
        }
        
        String deleteStatement = "delete from LIKES where recording_id=? AND username=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,recordingId);
            queryStatement.setString(2,username);
            queryStatement.execute();
            
            return deleting;
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

}
