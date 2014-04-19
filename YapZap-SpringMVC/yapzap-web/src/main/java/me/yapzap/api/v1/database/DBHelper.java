package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Date;

import me.yapzap.api.util.Logger;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;

public class DBHelper {

    @Autowired
    protected DataSourceFactory dataSourceFactory;


    public void execute(String command) {
        Connection connection = null;
        Statement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.createStatement();
            queryStatement.execute(command);

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
    
    protected Date convertDate(Timestamp timestamp){
        return new Date(timestamp.getTime());
    }
    
    protected Timestamp convertDate(Date date){
        return new Timestamp(date.getTime());
    }

}
