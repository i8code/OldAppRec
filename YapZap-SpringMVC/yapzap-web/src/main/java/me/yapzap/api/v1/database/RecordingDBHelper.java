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
import me.yapzap.api.v1.models.ParentType;
import me.yapzap.api.v1.models.Recording;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("recording_db_helper")
public class RecordingDBHelper extends DBHelper {

    public static final String createRecordingTable = "create table if not exists " + "RECORDINGS(" + "_id varchar(255) NOT NULL , " + "username varchar(255), " + "parent_name varchar(255), " + "parent_type varchar(255), "
                    + "tag_name varchar(255), " + "popularity FLOAT DEFAULT 0, " + "mood FLOAT DEFAULT 0 ," + "intensity FLOAT DEFAULT 0, " + "children_length INT DEFAULT 0, " + "likes INT DEFAULT 0, " + "audio_url varchar(255), "
                    + "audio_hash varchar(255), " + "waveform_data varchar(16384), " + "created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " + "last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " + "PRIMARY KEY (_id));";

    @Autowired
    private DataSourceFactory dataSourceFactory;

    @PostConstruct
    public void init() {
        execute(createRecordingTable);
    }

    public Recording getRecordingFromResultSet(ResultSet set) throws SQLException {
        Recording recording = new Recording();

        recording.set_id(set.getString("_id"));
        recording.setUsername(set.getString("username"));
        recording.setParentName(set.getString("parent_name"));
        recording.setParentType(ParentType.fromValue(set.getString("parent_type")));
        recording.setTagName(set.getString("tag_name"));
        recording.setMood(set.getFloat("mood"));
        recording.setIntensity(set.getFloat("intensity"));
        recording.setPopularity(set.getFloat("popularity"));
        recording.setChildrenLength(set.getInt("children_length"));
        recording.setLikes(set.getInt("likes"));
        recording.setAudioUrl(set.getString("audio_url"));
        recording.setAudioHash(set.getString("audio_hash"));
        recording.setWaveformData(set.getString("waveform_data"));
        recording.setCreatedDate(convertDate(set.getTimestamp("created_date")));
        recording.setLastUpdate(convertDate(set.getTimestamp("last_update")));

        return recording;
    }

    public List<Recording> getAllRecordings() {
        List<Recording> recordings = new ArrayList<>();
        String selectAllStatement = "select * from RECORDINGS;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            ResultSet results = queryStatement.executeQuery();

            while (results.next()) {
                recordings.add(getRecordingFromResultSet(results));
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
        return recordings;
    }

    public List<Recording> getAllForParentName(String name, boolean sortAsc) {
        List<Recording> recordings = new ArrayList<>();
        String selectAllStatement = sortAsc?
                            "select * from RECORDINGS where parent_name=? order by created_date asc;":
                            "select * from RECORDINGS where parent_name=? order by created_date desc;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, name);
            ResultSet results = queryStatement.executeQuery();

            while (results.next()) {
                recordings.add(getRecordingFromResultSet(results));
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
        return recordings;
    }

    public List<Recording> getAllRecordingsForUser(String username) {
        List<Recording> recordings = new ArrayList<>();
        String selectAllStatement = "select * from RECORDINGS where username=? order by created_date desc;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectAllStatement);
            queryStatement.setString(1, username);
            ResultSet results = queryStatement.executeQuery();

            while (results.next()) {
                recordings.add(getRecordingFromResultSet(results));
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
        return recordings;
    }

    public Recording getById(String id) {
        String selectByIdStatement = "select * from RECORDINGS where _id=?;";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();

            queryStatement = connection.prepareStatement(selectByIdStatement);
            queryStatement.setString(1, id);
            ResultSet results = queryStatement.executeQuery();

            while (results.next()) {
                return getRecordingFromResultSet(results);
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

    public Recording createRecording(Recording recording) {
        recording.set_id(UUID.randomUUID().toString());
        String insertStatement = "insert into RECORDINGS(_id, username, parent_name, parent_type, tag_name, mood, intensity, popularity, audio_url, audio_hash, waveform_data)" + " values(?,?,?,?,?,?,?,?,?,?,?);";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            int i = 1;
            queryStatement.setString(i++, recording.get_id());
            queryStatement.setString(i++, recording.getUsername());
            queryStatement.setString(i++, recording.getParentName());
            queryStatement.setString(i++, recording.getParentType().getValue());
            queryStatement.setString(i++, recording.getTagName());
            queryStatement.setFloat(i++, recording.getMood());
            queryStatement.setFloat(i++, recording.getIntensity());
            queryStatement.setFloat(i++, recording.getPopularity());
            queryStatement.setString(i++, recording.getAudioUrl());
            queryStatement.setString(i++, recording.getAudioHash());
            queryStatement.setString(i++, recording.getWaveformDataAsString());

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

        return getById(recording.get_id());
    }

    public Recording updateRecording(Recording recording) {

        String insertStatement = "update RECORDINGS set popularity=?,children_length=?,likes=? where _id=?";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(insertStatement);

            queryStatement.setFloat(1, recording.getPopularity());
            queryStatement.setInt(2, recording.getChildrenLength());
            queryStatement.setInt(3, recording.getLikes());
            queryStatement.setString(4, recording.get_id());

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
        return getById(recording.get_id());
    }

    public void deleteAllWithParentId(String parentId) {

        String deleteStatement = "delete from RECORDINGS where parent_id=?";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1, parentId);
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

    public Recording deleteById(String _id) {
        Recording toUpdate = getById(_id);

        if (toUpdate == null) {
            return null;
        }

        String deleteStatement = "delete from RECORDINGS where _id=?";
        Connection connection = null;
        PreparedStatement queryStatement = null;

        try {
            connection = dataSourceFactory.getMySQLDataSource().getConnection();
            queryStatement = connection.prepareStatement(deleteStatement);

            queryStatement.setString(1, _id);
            queryStatement.execute();
            

            return toUpdate;
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

}
