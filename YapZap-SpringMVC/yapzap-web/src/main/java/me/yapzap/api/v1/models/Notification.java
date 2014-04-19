package me.yapzap.api.v1.models;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Notification {

    @JsonProperty("username_for")
    private String usernameFor;

    @JsonProperty("username_by")
    private String usernameBy;

    @JsonProperty("mood")
    private Float mood;

    @JsonProperty("intensity")
    private Float intensity;

    @JsonProperty("tag_name")
    private String tagName;

    @JsonProperty("recording_id")
    private String recordingId;

    @JsonProperty("type")
    private String type;

    @JsonProperty("created_date")
    private Date createdDate;

    /**
     * @return the usernameFor
     */
    public String getUsernameFor() {
        return usernameFor;
    }

    /**
     * @param usernameFor
     *            the usernameFor to set
     */
    public void setUsernameFor(String usernameFor) {
        this.usernameFor = usernameFor;
    }

    /**
     * @return the usernameBy
     */
    public String getUsernameBy() {
        return usernameBy;
    }

    /**
     * @param usernameBy
     *            the usernameBy to set
     */
    public void setUsernameBy(String usernameBy) {
        this.usernameBy = usernameBy;
    }

    /**
     * @return the mood
     */
    public Float getMood() {
        return mood;
    }

    /**
     * @param mood
     *            the mood to set
     */
    public void setMood(Float mood) {
        this.mood = mood;
    }

    /**
     * @return the intensity
     */
    public Float getIntensity() {
        return intensity;
    }

    /**
     * @param intensity
     *            the intensity to set
     */
    public void setIntensity(Float intensity) {
        this.intensity = intensity;
    }

    /**
     * @return the tagName
     */
    public String getTagName() {
        return tagName;
    }

    /**
     * @param tagName
     *            the tagName to set
     */
    public void setTagName(String tagName) {
        this.tagName = tagName;
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
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type
     *            the type to set
     */
    public void setType(String type) {
        this.type = type;
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

}
