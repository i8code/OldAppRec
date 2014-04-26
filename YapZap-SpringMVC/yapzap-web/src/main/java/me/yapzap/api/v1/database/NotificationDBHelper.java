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
import me.yapzap.api.v1.models.Notification;
import me.yapzap.api.v1.models.NotificationType;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("notifications_db_helper")
public class NotificationDBHelper extends DBHelper {
    
    public static final String createNotificationsTable = "create table if not exists "+
        "NOTIFICATIONS("+
        "_id varchar(255) NOT NULL , "+
        "username_for varchar(255), "+
        "username_by varchar(255), "+
        "tag_name varchar(255), "+
        "recording_id varchar(255), "+
        "type varchar(255), "+
        "mood FLOAT DEFAULT 0 ,"+
        "intensity FLOAT DEFAULT 0, "+
        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
        "PRIMARY KEY (_id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createNotificationsTable);
    }
    
    public Notification getNotificationFrom(ResultSet set) throws SQLException{
        Notification notification = new Notification();
        notification.set_id(set.getString("_id"));
        notification.setUsernameFor(set.getString("username_for"));
        notification.setUsernameBy(set.getString("username_by"));
        notification.setTagName(set.getString("tag_name"));
        notification.setRecordingId(set.getString("recording_id"));
        notification.setType(NotificationType.fromValue(set.getString("type")));
        notification.setMood(set.getFloat("mood"));
        notification.setIntensity(set.getFloat("intensity"));
        notification.setCreatedDate(convertDate(set.getTimestamp("created_date")));
        
        return notification;
    }
    
    public List<Notification> getAllForUser(String username) {
        List<Notification> notifications = new ArrayList<>();
        String selectAllStatement = "select * from NOTIFICATIONS where username_for=? order by created_date desc;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, username);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                notifications.add(getNotificationFrom(results));
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
        return notifications;
    }
    

    public List<Notification> getAllBy(String usernameBy, String usernameFor, String recordingId) {
        List<Notification> notifications = new ArrayList<>();
        String selectAllStatement = "select * from NOTIFICATIONS where username_for=? AND username_by=? AND recording_id=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, usernameFor);
            queryStatement.setString(2, usernameBy);
            queryStatement.setString(3, recordingId);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                notifications.add(getNotificationFrom(results));
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
        return notifications;
    }
    
    public List<Notification> getAllByUser(String username) {
        List<Notification> notifications = new ArrayList<>();
        String selectAllStatement = "select * from NOTIFCATIONS where username_by=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, username);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                notifications.add(getNotificationFrom(results));
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
        return notifications;
    }
    
    public Notification getById(String id){
        String selectByIdStatement = "select * from NOTIFICATIONS where _id=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectByIdStatement);
            queryStatement.setString(1, id);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                return getNotificationFrom(results);
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
    
    public Notification createNotification(Notification notification){
        notification.set_id(UUID.randomUUID().toString());
        String insertStatement = "insert into NOTIFICATIONS(_id, username_for, username_by, mood, intensity, tag_name, recording_id, type)"
                        + " values(?,?,?,?,?,?,?,?);";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            int i=1;
            queryStatement.setString(i++, notification.get_id());
            queryStatement.setString(i++, notification.getUsernameFor());
            queryStatement.setString(i++, notification.getUsernameBy());
            queryStatement.setFloat(i++, notification.getMood());
            queryStatement.setFloat(i++, notification.getIntensity());
            queryStatement.setString(i++, notification.getTagName());
            queryStatement.setString(i++, notification.getRecordingId());
            queryStatement.setString(i++, notification.getType().toString());
            
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
        return getById(notification.get_id());
    }
    
    public Notification deleteById(String _id){
        
        Notification deleting = getById(_id);
        
        if (deleting==null){
            return null;
        }
        
        String deleteStatement = "delete from NOTIFICATIONS where _id=?";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,_id);
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
    

    public Notification deleteAllForRecordingId(String _id){
        
        Notification deleting = getById(_id);
        
        if (deleting==null){
            return null;
        }
        
        String deleteStatement = "delete from NOTIFICATIONS where recording_id=?";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,_id);
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
    

    public void deleteAllForTagName(String name){
        
        String deleteStatement = "delete from NOTIFICATIONS where tag_name=?";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,name);
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
    

    public void deleteAllForLike(Like like){
        String deleteStatement = "delete from NOTIFICATIONS where username_by=? AND recording_id=? AND type='LIKE';";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,like.getUsername());
            queryStatement.setString(2,like.getRecordingId());
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
