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
        "last_update TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "+
        "PRIMARY KEY (name));";

    @PostConstruct
    public void init() {
        execute(createTagTableSQL);
    }
    
    public Tag getTagFromResultsSet(ResultSet set){
        return null;
    }
    
    
    public List<Tag> getMostPopularTags() {
        return null;
    }
    
    public Tag getById(int id){
        return null;
    }
    
    public Tag getByName(String name){
        
        
        return null;
    }
    
    public void createTag(Tag tag){
        
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
