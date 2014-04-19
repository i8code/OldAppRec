package me.yapzap.api.v1.models;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;

@SuppressWarnings("serial")
public abstract class APIModel implements Serializable {
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperty(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((additionalProperties == null) ? 0 : additionalProperties.hashCode());
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
        APIModel other = (APIModel) obj;
        if (additionalProperties == null) {
            if (other.additionalProperties != null)
                return false;
        }
        else if (!additionalProperties.equals(other.additionalProperties))
            return false;
        return true;
    }

    @Override
    public String toString() {
        return "APIModel [additionalProperties=" + additionalProperties + "]";
    }

}
