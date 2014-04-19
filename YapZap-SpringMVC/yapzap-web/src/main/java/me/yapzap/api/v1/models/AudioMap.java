package me.yapzap.api.v1.models;

import com.fasterxml.jackson.annotation.JsonProperty;

@SuppressWarnings("serial")
public class AudioMap extends APIModel {

    @JsonProperty("filename")
    private String filename;

    @JsonProperty("hash")
    private String hash;

    /**
     * @return the filename
     */
    public String getFilename() {
        return filename;
    }

    /**
     * @param filename the filename to set
     */
    public void setFilename(String filename) {
        this.filename = filename;
    }

    /**
     * @return the hash
     */
    public String getHash() {
        return hash;
    }

    /**
     * @param hash the hash to set
     */
    public void setHash(String hash) {
        this.hash = hash;
    }
    
    

}
