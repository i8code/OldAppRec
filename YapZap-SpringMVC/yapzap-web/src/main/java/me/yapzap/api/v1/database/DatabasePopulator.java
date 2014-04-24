package me.yapzap.api.v1.database;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import me.yapzap.api.v1.models.AudioMap;
import me.yapzap.api.v1.models.Like;
import me.yapzap.api.v1.models.Notification;
import me.yapzap.api.v1.models.NotificationType;
import me.yapzap.api.v1.models.Recording;
import me.yapzap.api.v1.models.Tag;

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
    


    private static Set<String> usernames = new HashSet<String>();
    public static void insertIntoTable(Recording recording, Connection connection) throws SQLException{
        usernames.add(recording.getUsername());
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
    
    public static void insertIntoTable(Notification notification, Connection connection) throws SQLException{

        String insertStatement = "insert into NOTIFICATIONS(_id, username_for, username_by, tag_name, recording_id, type, mood, intensity, created_date) values(?,?,?,?,?,?,?,?,?);";
        PreparedStatement statement = connection.prepareStatement(insertStatement);
        int i=1;
        statement.setString(i++, notification.get_id());
        statement.setString(i++, notification.getUsernameFor());
        statement.setString(i++, notification.getUsernameBy());
        statement.setString(i++, notification.getTagName());
        statement.setString(i++, notification.getRecordingId());
        statement.setString(i++, notification.getType().getValue());
        statement.setFloat(i++, notification.getMood());
        statement.setFloat(i++, notification.getIntensity());
        statement.setTimestamp(i++, new Timestamp(notification.getCreatedDate().getTime()));
        
        statement.execute();
        statement.closeOnCompletion();
    }
    
    
    
    private static Set<String> tagNames = new HashSet<String>();

    public static void insertIntoTable(Tag tag, Connection connection) throws SQLException{
        
        if (tagNames.contains(tag.getName())){
            return;
        }
        tagNames.add(tag.getName());
        String insertStatement = "insert into TAGS(_id, name, mood, intensity, popularity, children_length, created_date, last_update) values(?,?,?,?,?,?,?,?);";
        PreparedStatement statement = connection.prepareStatement(insertStatement);
        int i=1;
        statement.setString(i++, tag.get_id());
        statement.setString(i++, tag.getName());
        statement.setFloat(i++, tag.getMood());
        statement.setFloat(i++, tag.getIntensity());
        statement.setFloat(i++, tag.getPopularity());
        statement.setInt(i++, tag.getChildrenLength());
        statement.setTimestamp(i++, new Timestamp(tag.getCreatedDate().getTime()));
        statement.setTimestamp(i++, new Timestamp(tag.getLastUpdate().getTime()));
        
        statement.execute();
        statement.closeOnCompletion();
    }
    
    public static void insertIntoTable(AudioMap map, Connection connection) throws SQLException{

        String insertStatement = "insert into AUDIO_MAP(hash, filename) values(?,?);";
        PreparedStatement statement = connection.prepareStatement(insertStatement);
        int i=1;
        statement.setString(i++, map.getHash());
        statement.setString(i++, map.getFilename());
        
        statement.execute();
        statement.closeOnCompletion();
    }
    
    public static void downloadData(Connection connection) throws IOException, SQLException, NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
        ObjectMapper mapper = new ObjectMapper();
        
        ///TAGS
        
        String tagsJson = getURL("https://yapzap.me/tags");
        
        JavaType tagsType = mapper.getTypeFactory().constructCollectionType(List.class, Tag.class);
        
        List<Tag> tags = mapper.readValue(tagsJson, tagsType);
        
        for (Tag tag : tags){
            insertIntoTable(tag, connection);
        }
        
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
        


        ///AUDIO_MAPS
        
        String audioMapsJson = getURL("https://yapzap.me/audio_maps");
        
        JavaType audioMapType = mapper.getTypeFactory().constructCollectionType(List.class, AudioMap.class);
        
        List<AudioMap> maps = mapper.readValue(audioMapsJson, audioMapType);
        
        for (AudioMap map : maps){
            insertIntoTable(map, connection);
        }
        

        ///NOTIFICATIONS
        
        for (String username : usernames){
            username = username.replace(" ", "%20");
            String notificationJson = getURL("https://yapzap.me/notifications/"+username);
            
            JavaType notificationsType = mapper.getTypeFactory().constructCollectionType(List.class, Notification.class);
            
            List<Notification> notifictaions = mapper.readValue(notificationJson, notificationsType);
            
            for (Notification notifictaion : notifictaions){
                insertIntoTable(notifictaion, connection);
            }
            
        }
    }
    
    protected static Date convertDate(Timestamp timestamp){
        return new Date(timestamp.getTime());
    }
    
    public static Like getLikeFromResultSet(ResultSet set) throws SQLException{
        Like like = new Like();
        like.set_id(set.getString("_id"));
        like.setUsername(set.getString("username"));
        like.setRecordingId(set.getString("recording_id"));
        like.setCreatedDate(convertDate(set.getTimestamp("created_date")));
        like.setLastUpdate(convertDate(set.getTimestamp("last_update")));
        
        return  like;
    }
    
    
    public static void fixLikes(Connection connection) throws SQLException{
        String insertStatement = "select * from LIKES order by created_date desc limit 85;";
        PreparedStatement statement = connection.prepareStatement(insertStatement);
        
        ResultSet results = statement.executeQuery();
        
        ArrayList<Like> likes = new ArrayList<>();
        while(results.next()){
            likes.add(getLikeFromResultSet(results));
        }
        
        for (Like like : likes){
            String username = like.getUsername();
            if (username.contains("username")){
                like.setUsername(username.substring(13, username.length()-2));
                String delete = "delete from LIKES where _id='"+like.get_id()+"';";
                PreparedStatement deleteStatement = connection.prepareStatement(delete);
                deleteStatement.execute();
                
                insertIntoTable(like, connection);
            }
        }
    }
        

    public static Notification getNotificationFrom(ResultSet set) throws SQLException{
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
        
        public static void fixNotifications(Connection connection) throws SQLException{
            String insertStatement = "select * from NOTIFICATIONS where type='LIKE' OR type='FRIEND_LIKE' order by created_date desc limit 850000;";
            PreparedStatement statement = connection.prepareStatement(insertStatement);
            
            ResultSet results = statement.executeQuery();
            
            ArrayList<Notification> notifications = new ArrayList<>();
            while(results.next()){
                notifications.add(getNotificationFrom(results));
            }
            
            for (Notification notification : notifications){
                String username = notification.getUsernameBy();
                if (username.contains("username")){
                    notification.setUsernameBy(username.substring(13, username.length()-2));
                    String delete = "delete from NOTIFICATIONS where _id='"+notification.get_id()+"';";
                    PreparedStatement deleteStatement = connection.prepareStatement(delete);
                    deleteStatement.execute();
                    
                    insertIntoTable(notification, connection);
                }
            }
        
        
    }
    
    public static void main(String[] args) throws ClassNotFoundException, SQLException, NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, IOException{
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager
            //.getConnection("jdbc:mysql://localhost/yapzap?user=sqluser&password=sqluserpw");
                        .getConnection("jdbc:mysql://yapzap-production.cg4lhdbq8fnd.us-east-1.rds.amazonaws.com/yapzap?user=yapzapapp&password=sNM4I8oCDYCK6El");
        
//        clearTables(connection);
//        createTables(connection);
//        downloadData(connection);
//        fixLikes(connection);
        fixNotifications(connection);
    }

}
