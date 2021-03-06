package me.yapzap.api.v1.models;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@SuppressWarnings("serial")
public class Recording extends MoodyModel {

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
    
    @JsonProperty("likes")
    private Integer likes;

    @JsonProperty("audio_url")
    private String audioUrl;
    
    @JsonProperty("audio_hash")
    private String audioHash;
    
    @JsonProperty("waveform_data")
    private List<Float> waveformData;

    @JsonProperty("created_date")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timezone="UTC")
    private Date createdDate;

    @JsonProperty("last_update")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timezone="UTC")
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
        setChildrenLength(children.size());
        this.children = children;
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
    @JsonIgnore
    public void setWaveformData(String string) {
        this.waveformData = new ArrayList<Float>();
        
        ByteBuffer buffer;
        buffer = ByteBuffer.wrap(stringToByteArray(string));

        while(buffer.hasRemaining()){
            Float f = buffer.getFloat();
            this.waveformData.add(f);
        }
    }

    public static String byteArrayToString(byte[] bytes){
        int n = bytes.length;
        char[] chars = new char[n];
        
        for (int i=0;i<n;i+=1){
            chars[i] = (char)bytes[i];
        }
        
        return new String(chars);
    }
    
    public static byte[] stringToByteArray(String string){
        
        char[] chars = string.toCharArray();
        int n = chars.length;
        byte[] bytes = new byte[n];
        
        for (int i=0;i<n;i+=1){
            bytes[i] = (byte) (chars[i] & 0xFF);
        }
        
        return bytes;
    }
    
    @JsonIgnore
    public String getWaveformDataAsString() {
        ByteBuffer buffer = ByteBuffer.allocate(this.waveformData.size()*4);
        
        for (Float f : waveformData){
            buffer.putFloat(f);
        }
        
        String waveformString = byteArrayToString(buffer.array());
        
        assert(waveformString.length()==this.waveformData.size()*4);
        
        return waveformString;
        /*
        
        try {
            String waveformDataStr = new String(buffer.array(), "UTF-16");
            System.out.println("A: "+(this.waveformData.size()*4));
            System.out.println("B: "+waveformDataStr.length());
            System.out.println();
            
            int length = this.waveformData.size();
            setWaveformData(waveformDataStr);
            assert(this.waveformData.size()==length);
            return waveformDataStr;
        }
        catch (UnsupportedEncodingException e) {
            return null;
        }*/
    }
    
    
    

}
