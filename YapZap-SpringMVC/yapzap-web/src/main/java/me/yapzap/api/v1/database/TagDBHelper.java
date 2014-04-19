package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;
import me.yapzap.api.v1.models.Tag;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.stereotype.Component;

@Component("tag_db_helper")
public class TagDBHelper extends DBHelper {
    
    public static final String createTagTableSQL = "create table if not exists "+
        "TAGS(_id varchar(255), "+
        "name varchar(255), "+
        "popularity FLOAT DEFAULT 0, "+
        "mood FLOAT DEFAULT 0 ,"+
        "intensity FLOAT DEFAULT 0, "+
        "children_length INT DEFAULT 0, "+
        "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
        "last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "+
        "PRIMARY KEY (name));";

    @PostConstruct
    public void init() {
        execute(createTagTableSQL);
    }
    
    public Tag getTagFromResultsSet(ResultSet set) throws SQLException{
        Tag tag = new Tag();
        
        tag.setName(set.getString("name"));
        tag.set_id(set.getString("_id"));
        tag.setPopularity(set.getFloat("popularity"));
        tag.setMood(set.getFloat("mood"));
        tag.setIntensity(set.getFloat("intensity"));
        tag.setChildrenLength(set.getInt("children_length"));
        tag.setCreatedDate(convertDate(set.getTimestamp("created_date")));
        tag.setLastUpdate(convertDate(set.getTimestamp("last_update")));
        
        return tag;
    }
    
    public List<Tag> getMostPopularTags() {
        List<Tag> tags = new ArrayList<>();
        String selectAllNamesStatement = "select * from TAGS order by popularity desc limit 200;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllNamesStatement);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                tags.add(getTagFromResultsSet(results));
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
        return tags;
    }
    
    public Tag getById(String id){
        String selectByIdStatement = "select * from TAGS where _id=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectByIdStatement);
            queryStatement.setString(1, id);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                return getTagFromResultsSet(results);
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
    
    public Tag getByName(String name){
        String selectAllNamesStatement = "select * from TAGS where name='"+name+"';";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllNamesStatement);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                return getTagFromResultsSet(results);
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
    
    public Tag createTag(Tag tag){
        
        String insertStatement = "insert into TAGS(_id, name, popularity, mood, intensity, children_length) values(?,?,?,?,?,?);";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            queryStatement.setString(1, tag.get_id());
            queryStatement.setString(2, tag.getName());
            queryStatement.setFloat(3, tag.getPopularity());
            queryStatement.setFloat(4, tag.getMood());
            queryStatement.setFloat(5, tag.getIntensity());
            queryStatement.setInt(6, tag.getChildrenLength());
            
            queryStatement.execute();
            
            return getByName(tag.getName());
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
    
    public Tag updateTag(Tag tag){
        
        String insertStatement = "update TAGS set popularity=?, mood=?, intensity=?, children_length=? where name=?";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            queryStatement.setFloat(1, tag.getPopularity());
            queryStatement.setFloat(2, tag.getMood());
            queryStatement.setFloat(3, tag.getIntensity());
            queryStatement.setInt(4, tag.getChildrenLength());
            queryStatement.setString(5, tag.getName());
            
            queryStatement.execute();
            
            return getByName(tag.getName());
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
    
    public List<String> getAllTagNames(){
        List<String> tagNames = new ArrayList<>();
        String selectAllNamesStatement = "select name from TAGS;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllNamesStatement);
            ResultSet results = queryStatement.executeQuery();
            
            while(results.next()){
                String name = results.getString("name");
                tagNames.add(name);
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
        return tagNames;
        
    }

}
