package me.yapzap.api.v1.database;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

@Component("data_source_factory")
public class DataSourceFactory {

    @Value("${db.url}") 
    private String url;
    
    @Value("${db.username}") 
    private String username;
    
    @Value("${db.password}") 
    private String password;

    public DataSource getMySQLDataSource() {
        MysqlDataSource mysqlDS = new MysqlDataSource();
        mysqlDS.setURL(this.url);
        mysqlDS.setUser(this.username);
        mysqlDS.setPassword(this.password);
        return mysqlDS;
    }
}
