package me.yapzap.api.v1.models;


public enum NotificationType {
    LIKE("LIKE"), COMMENT("COMMENT"), FRIEND_LIKE("FRIEND_LIKE"), FRIEND_REC("FRIEND_REC"), FRIEND_TAG("FRIEND_TAG");
    
    private String value;
    
    NotificationType(String value){
        this.value = value;
    }
    
    public String getValue(){
        return value;
    }
    
    public static NotificationType fromValue(String value){
        for (NotificationType pType : NotificationType.values()){
            if (pType.getValue().equals(value)){
                return pType;
            }
        }
        
        return null;
    }

}
