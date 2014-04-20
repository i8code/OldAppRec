package me.yapzap.api.v1.database;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;

import me.yapzap.api.v1.models.Like;
import me.yapzap.api.v1.models.Recording;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;


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
    
    private static String getURL(String url) throws IOException{
        StringBuffer sb = new StringBuffer();
        URL oracle = new URL(url);
        BufferedReader in = new BufferedReader(
        new InputStreamReader(oracle.openStream()));

        String inputLine;
        while ((inputLine = in.readLine()) != null)
            sb.append(inputLine);
        in.close();
        
        return sb.toString();
    }
    
    public static void insertIntoTable(Like like, Connection connection) throws SQLException{
        
        String insertStatement = "insert into LIKES(_id, username, recording_id, created_date, last_update) values(?,?,?,?,?);";
        PreparedStatement statement = connection.prepareStatement(insertStatement);
        int i=1;
        statement.setString(i++, like.get_id());
        statement.setString(i++, like.getUsername());
        statement.setString(i++, like.getRecordingId());
        statement.setTimestamp(i++, new Timestamp(like.getCreatedDate().getTime()));
        statement.setTimestamp(i++, new Timestamp(like.getLastUpdate().getTime()));
        
        statement.execute();
        statement.closeOnCompletion();
    }
    

    public static void insertIntoTable(Recording recording, Connection connection) throws SQLException{
        String insertStatement = "insert into RECORDINGS(_id, username, parent_name, parent_type, tag_name, mood, intensity, popularity, children_length, likes, audio_url, audio_hash, waveform_data, created_date, last_update) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
        PreparedStatement statement = connection.prepareStatement(insertStatement);
        int i=1;
        statement.setString(i++, recording.get_id());
        statement.setString(i++, recording.getUsername());
        statement.setString(i++, recording.getParentName());
        statement.setString(i++, recording.getParentType().getValue());
        statement.setString(i++, recording.getTagName());
        statement.setFloat(i++, recording.getMood());
        statement.setFloat(i++, recording.getIntensity());
        statement.setFloat(i++, recording.getPopularity());
        statement.setInt(i++, recording.getChildrenLength());
        statement.setInt(i++, recording.getLikes());
        statement.setString(i++, recording.getAudioUrl());
        statement.setString(i++, recording.getAudioHash());
        statement.setString(i++, recording.getWaveformDataAsString());
        statement.setTimestamp(i++, new Timestamp(recording.getCreatedDate().getTime()));
        statement.setTimestamp(i++, new Timestamp(recording.getLastUpdate().getTime()));
        
        statement.execute();
        statement.closeOnCompletion();
    }
    
    public static void downloadData(Connection connection) throws IOException, SQLException, NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
        ObjectMapper mapper = new ObjectMapper();
        
        ///RECORDINGS
        
        String recordingsJson = getURL("https://yapzap.me/recordings");
        
        JavaType recordingsType = mapper.getTypeFactory().constructCollectionType(List.class, Recording.class);
        
        List<Recording> recordings = mapper.readValue(recordingsJson, recordingsType);
        
        for (Recording recording : recordings){
            insertIntoTable(recording, connection);
        }

        ///LIKES
        
        String likesJson = getURL("https://yapzap.me/likes");
        
        JavaType likeListType = mapper.getTypeFactory().constructCollectionType(List.class, Like.class);
        
        List<Like> likes = mapper.readValue(likesJson, likeListType);
        
        for (Like like : likes){
            insertIntoTable(like, connection);
        }
        
        
        
    }
    
    public static void main(String[] args) throws ClassNotFoundException, SQLException, NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, IOException{
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager
            .getConnection("jdbc:mysql://localhost/yapzap?"
                + "user=sqluser&password=sqluserpw");
        
        clearTables(connection);
        createTables(connection);
        downloadData(connection);
    }

}
