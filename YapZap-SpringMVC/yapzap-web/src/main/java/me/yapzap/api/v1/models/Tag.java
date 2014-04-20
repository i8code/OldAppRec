package me.yapzap.api.v1.models;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

@SuppressWarnings("serial")
public class Tag extends APIModel{
    
    @JsonProperty("name")
    private String name;
    
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Float getPopularity() {
        return popularity;
    }

    public void setPopularity(Float popularity) {
        this.popularity = popularity;
    }

    public Integer getChildrenLength() {
        return childrenLength;
    }

    public void setChildrenLength(Integer childrenLength) {
        this.childrenLength = childrenLength;
    }

    public Float getMood() {
        return mood;
    }

    public void setMood(Float mood) {
        this.mood = mood;
    }

    public Float getIntensity() {
        return intensity;
    }

    public void setIntensity(Float intensity) {
        this.intensity = intensity;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((childrenLength == null) ? 0 : childrenLength.hashCode());
        result = prime * result + ((createdDate == null) ? 0 : createdDate.hashCode());
        result = prime * result + ((intensity == null) ? 0 : intensity.hashCode());
        result = prime * result + ((lastUpdate == null) ? 0 : lastUpdate.hashCode());
        result = prime * result + ((mood == null) ? 0 : mood.hashCode());
        result = prime * result + ((name == null) ? 0 : name.hashCode());
        result = prime * result + ((popularity == null) ? 0 : popularity.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Tag other = (Tag) obj;
        if (childrenLength == null) {
            if (other.childrenLength != null)
                return false;
        }
        else if (!childrenLength.equals(other.childrenLength))
            return false;
        if (createdDate == null) {
            if (other.createdDate != null)
                return false;
        }
        else if (!createdDate.equals(other.createdDate))
            return false;
        if (intensity == null) {
            if (other.intensity != null)
                return false;
        }
        else if (!intensity.equals(other.intensity))
            return false;
        if (lastUpdate == null) {
            if (other.lastUpdate != null)
                return false;
        }
        else if (!lastUpdate.equals(other.lastUpdate))
            return false;
        if (mood == null) {
            if (other.mood != null)
                return false;
        }
        else if (!mood.equals(other.mood))
            return false;
        if (name == null) {
            if (other.name != null)
                return false;
        }
        else if (!name.equals(other.name))
            return false;
        if (popularity == null) {
            if (other.popularity != null)
                return false;
        }
        else if (!popularity.equals(other.popularity))
            return false;
        return true;
    }
    
    

}
