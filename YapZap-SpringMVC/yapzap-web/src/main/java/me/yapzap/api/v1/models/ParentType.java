package me.yapzap.api.v1.models;


public enum ParentType {
    TAG("TAG"), REC("REC");
    
    private String value;
    
    ParentType(String value){
        this.value = value;
    }
    
    public String getValue(){
        return value;
    }
    
    public static ParentType fromValue(String value){
        for (ParentType pType : ParentType.values()){
            if (pType.getValue().equals(value)){
                return pType;
            }
        }
        
        return null;
    }

}
