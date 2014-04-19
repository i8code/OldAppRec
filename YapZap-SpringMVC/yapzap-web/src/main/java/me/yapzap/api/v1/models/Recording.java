package me.yapzap.api.v1.models;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@SuppressWarnings("serial")
public class Recording extends APIModel {

    @JsonProperty("username")
    private String username;

    @JsonProperty("parent_name")
    private String parentName;

    @JsonProperty("parent_type")
    @JsonSerialize(using=ParentTypeSerializer.class)
    @JsonDeserialize(using=ParentTypeDeserializer.class)
    private ParentType parentType;

    @JsonProperty("tag_name")
    private String tagName;

    @JsonProperty("children")
    private List<Recording> children;
    
    @JsonProperty("popularity")
    private Float popularity;

    @JsonProperty("children_length")
    private Integer childrenLength;

    @JsonProperty("mood")
    private Float mood;

    @JsonProperty("intensity")
    private Float intensity;
    
    @JsonProperty("likes")
    private Integer likes;
    

    @JsonProperty("audio_url")
    private String audioUrl;
    
    @JsonProperty("audio_hash")
    private String audioHash;
    
    @JsonProperty("waveform_data")
    private List<Float> waveformData;

    @JsonProperty("created_date")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.Z", timezone="UTC")
    private Date createdDate;

    @JsonProperty("last_update")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.Z", timezone="UTC")
    private Date lastUpdate;

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the parentName
     */
    public String getParentName() {
        return parentName;
    }

    /**
     * @param parentName the parentName to set
     */
    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    /**
     * @return the parentType
     */
    public ParentType getParentType() {
        return parentType;
    }

    /**
     * @param parentType the parentType to set
     */
    public void setParentType(ParentType parentType) {
        this.parentType = parentType;
    }

    /**
     * @return the tag_name
     */
    public String getTagName() {
        return tagName;
    }

    /**
     * @param tag_name the tag_name to set
     */
    public void setTagName(String tag_name) {
        this.tagName = tag_name;
    }

    /**
     * @return the children
     */
    public List<Recording> getChildren() {
        return children;
    }

    /**
     * @param children the children to set
     */
    public void setChildren(List<Recording> children) {
        this.children = children;
    }

    /**
     * @return the popularity
     */
    public Float getPopularity() {
        return popularity;
    }

    /**
     * @param popularity the popularity to set
     */
    public void setPopularity(Float popularity) {
        this.popularity = popularity;
    }

    /**
     * @return the childrenLength
     */
    public Integer getChildrenLength() {
        return childrenLength;
    }

    /**
     * @param childrenLength the childrenLength to set
     */
    public void setChildrenLength(Integer childrenLength) {
        this.childrenLength = childrenLength;
    }

    /**
     * @return the mood
     */
    public Float getMood() {
        return mood;
    }

    /**
     * @param mood the mood to set
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
     * @param intensity the intensity to set
     */
    public void setIntensity(Float intensity) {
        this.intensity = intensity;
    }

    /**
     * @return the likes
     */
    public Integer getLikes() {
        return likes;
    }

    /**
     * @param likes the likes to set
     */
    public void setLikes(Integer likes) {
        this.likes = likes;
    }

    /**
     * @return the audioUrl
     */
    public String getAudioUrl() {
        return audioUrl;
    }

    /**
     * @param audioUrl the audioUrl to set
     */
    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }

    /**
     * @return the audioHash
     */
    public String getAudioHash() {
        return audioHash;
    }

    /**
     * @param audioHash the audioHash to set
     */
    public void setAudioHash(String audioHash) {
        this.audioHash = audioHash;
    }

    /**
     * @return the waveformData
     */
    public List<Float> getWaveformData() {
        return waveformData;
    }

    /**
     * @param waveformData the waveformData to set
     */
    public void setWaveformData(List<Float> waveformData) {
        this.waveformData = waveformData;
    }

    /**
     * @return the createdDate
     */
    public Date getCreatedDate() {
        return createdDate;
    }

    /**
     * @param createdDate the createdDate to set
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
     * @param lastUpdate the lastUpdate to set
     */
    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public void setWaveformData(String string) {
        ByteBuffer buffer = ByteBuffer.wrap(string.getBytes());
        
        this.waveformData = new ArrayList<Float>();
        
        while(buffer.hasRemaining()){
            this.waveformData.add(buffer.getFloat());
        }
    }
    
    public String getWaveformDataAsString() {
        ByteBuffer buffer = ByteBuffer.allocate(this.waveformData.size()*4);
        
        for (Float f : waveformData){
            buffer.putFloat(f);
        }
        
        return new String(buffer.array());
    }
    
    
    

}
