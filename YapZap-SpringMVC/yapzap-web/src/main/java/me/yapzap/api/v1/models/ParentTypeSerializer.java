package me.yapzap.api.v1.models;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class ParentTypeSerializer extends JsonSerializer<ParentType> {

    @Override
    public void serialize(ParentType arg0, JsonGenerator gen, SerializerProvider arg2) throws IOException, JsonProcessingException {
        gen.writeString(arg0.getValue());
    }

}
