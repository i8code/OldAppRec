package me.yapzap.api.v1.models;

import com.fasterxml.jackson.annotation.JsonProperty;

@SuppressWarnings("serial")
public class FriendRelation extends APIModel {

    @JsonProperty("friend_id")
    private String friendId;

    @JsonProperty("friend_of")
    private String friendOf;

    /**
     * @return the friendId
     */
    public String getFriendId() {
        return friendId;
    }

    /**
     * @param friendId
     *            the friendId to set
     */
    public void setFriendId(String friendId) {
        this.friendId = friendId;
    }

    /**
     * @return the friendOf
     */
    public String getFriendOf() {
        return friendOf;
    }

    /**
     * @param friendOf
     *            the friendOf to set
     */
    public void setFriendOf(String friendOf) {
        this.friendOf = friendOf;
    }

}
