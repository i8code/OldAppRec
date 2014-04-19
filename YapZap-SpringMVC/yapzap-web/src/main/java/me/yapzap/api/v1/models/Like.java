package me.yapzap.api.v1.models;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

@SuppressWarnings("serial")
public class Like extends APIModel {

    @JsonProperty("username")
    private String username;

    @JsonProperty("recording_id")
    private String recordingId;

    @JsonProperty("created_date")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.Z", timezone="UTC")
    private Date createdDate;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.Z", timezone="UTC")
    @JsonProperty("last_update")
    private Date lastUpdate;

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username
     *            the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the recordingId
     */
    public String getRecordingId() {
        return recordingId;
    }

    /**
     * @param recordingId
     *            the recordingId to set
     */
    public void setRecordingId(String recordingId) {
        this.recordingId = recordingId;
    }

    /**
     * @return the createdDate
     */
    public Date getCreatedDate() {
        return createdDate;
    }

    /**
     * @param createdDate
     *            the createdDate to set
     */
    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    /**
     * @return the lastUpdate
     */
    public Date getLastUpdate() {
        return lastUpdate;
    }

    /**
     * @param lastUpdate
     *            the lastUpdate to set
     */
    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

}
