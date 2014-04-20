package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;

import org.apache.commons.lang3.exception.ExceptionUtils;
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
    

    public String getBlacklistedUser(ResultSet set) throws SQLException{
        return set.getString("username");
    }
    
    public Set<String> getBlackList() {
        Set<String> blackListed = new HashSet<String>();
        
        String selectAllStatement = "select * from BLACKLIST;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                blackListed.add(getBlacklistedUser(results));
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
        return blackListed;
    }
    
    public boolean blackListHasUser(String username) {
        String selectAllStatement = "select * from BLACKLIST where username=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, username);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                return true;
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
        return false;
    }
    
    public void addToBlacklist(String user){
        String _id = UUID.randomUUID().toString();
        String insertStatement = "insert into FRIENDS(_id, username)"
                        + " values(?,?);";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            int i=1;
            queryStatement.setString(i++, _id);
            queryStatement.setString(i++, user);
            
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
    
    public void removeFromBlacklist(String user){
        String deleteStatement = "delete from BLACKLIST where username=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1,user);
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
