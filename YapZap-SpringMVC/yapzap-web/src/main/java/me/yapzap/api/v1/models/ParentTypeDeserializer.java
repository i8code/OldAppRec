package me.yapzap.api.v1.models;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

public class ParentTypeDeserializer extends JsonDeserializer<ParentType> {

    @Override
    public ParentType deserialize(JsonParser parser, DeserializationContext arg1) throws IOException, JsonProcessingException {
        return ParentType.fromValue(parser.getText());
    }

}
