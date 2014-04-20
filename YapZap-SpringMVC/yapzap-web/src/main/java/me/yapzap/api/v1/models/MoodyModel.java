package me.yapzap.api.v1.models;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

@SuppressWarnings("serial")
public class MoodyModel extends APIModel {
    
    @JsonProperty("popularity")
    private Float popularity;

    @JsonProperty("children_length")
    private Integer childrenLength;

    @JsonProperty("mood")
    private Float mood;

    @JsonProperty("intensity")
    private Float intensity;

    @JsonProperty("created_date")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.SSSZ", timezone="UTC")
    private Date createdDate;

    @JsonProperty("last_update")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.SSSZ", timezone="UTC")
    private Date lastUpdate;


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
    
    

}
