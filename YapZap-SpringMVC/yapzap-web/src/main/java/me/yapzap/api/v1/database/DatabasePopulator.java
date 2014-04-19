package me.yapzap.api.v1.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;


public class DatabasePopulator {
    
    
    public static void createTables(Connection connection) throws SQLException{

        String[] createStatements = {
                        TagDBHelper.createTagTableSQL,
                        RecordingDBHelper.createRecordingTable,
                        NotificationDBHelper.createNotificationsTable,
                        FriendDBHelper.createFriendTable,
                        LikeDBHelper.createLikeTable,
                        BlackListDBHelper.createBlackListTable,
                        AudioMapDBHelper.createAudioMapTable
        };

        for (String createStatement : createStatements){

            Statement statement = connection.createStatement();
            statement.execute(createStatement);
            statement.closeOnCompletion();
        }
    }
    
    
    public static void clearTables(Connection connection) throws SQLException{

        String dropFormat = "drop table if exists %s;";
        String[] tableNames = {
                        "TAGS",
                        "RECORDINGS",
                        "NOTIFICATIONS",
                        "FRIENDS",
                        "LIKES",
                        "BLACKLIST",
                        "AUDIO_MAP"
        };

        for (String name : tableNames){
            String sql = String.format(dropFormat, name);
            Statement statement = connection.createStatement();
            statement.execute(sql);
            statement.closeOnCompletion();
        }
        
    }
    
    public static void main(String[] args) throws ClassNotFoundException, SQLException{
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager
            .getConnection("jdbc:mysql://localhost/yapzap?"
                + "user=sqluser&password=sqluserpw");
        
        clearTables(connection);
        
    }

}
