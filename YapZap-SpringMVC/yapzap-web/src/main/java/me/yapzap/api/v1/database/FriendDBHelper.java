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
import me.yapzap.api.v1.models.FriendRelation;

import org.apache.commons.lang3.exception.ExceptionUtils;
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

    public FriendRelation getFriendFromResultSet(ResultSet set) throws SQLException{
        FriendRelation friend = new FriendRelation();
        friend.set_id(set.getString("_id"));
        friend.setFriendId(set.getString("friend_id"));
        friend.setFriendOf(set.getString("friend_of"));
        
        return  friend;
    }
    
    public List<FriendRelation> getAllForUser(String userId) {
        List<FriendRelation> friends = new ArrayList<>();
        
        String selectAllStatement = "select * from FRIENDS where friend_of=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, userId);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                friends.add(getFriendFromResultSet(results));
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
        return friends;
    }
    
    public void createFriendRelation(FriendRelation friend){
        friend.set_id(UUID.randomUUID().toString());
        String insertStatement = "insert into FRIENDS(_id, friend_id, friend_of)"
                        + " values(?,?,?);";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            int i=1;
            queryStatement.setString(i++, friend.get_id());
            queryStatement.setString(i++, friend.getFriendId());
            queryStatement.setString(i++, friend.getFriendOf());
            
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
    
    public void deleteFriendRelation(String friend_id, String friend_of){
        String deleteStatement = "delete from FRIENDS where friend_id=? AND friend_of=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,friend_id);
            queryStatement.setString(2,friend_of);
            queryStatement.execute();
            return;
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
