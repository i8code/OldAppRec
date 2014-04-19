package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import javax.annotation.PostConstruct;

import me.yapzap.api.util.Logger;
import me.yapzap.api.v1.models.Tag;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("tag_db_helper")
public class TagDBHelper {
    
    public static final String createTagTableSQL = "create table if not exists "+
        "TAGS(id INT NOT NULL AUTO_INCREMENT, "+
        "_id varchar(255), "+
        "name varchar(255), "+
        "popularity FLOAT DEFAULT 0, "+
        "mood FLOAT DEFAULT 0 ,"+
        "intensity FLOAT DEFAULT 0, "+
        "children_length INT DEFAULT 0, "+
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
            createTableStatement.execute(createTagTableSQL);

        }
        catch (SQLException e) {
            Logger.log(ExceptionUtils.getStackTrace(e)); 
        }
        finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            }
            catch (Exception e) {
            }
        }

    }

    public List<Tag> getMostPopularTags() {
        return null;
    }

}
