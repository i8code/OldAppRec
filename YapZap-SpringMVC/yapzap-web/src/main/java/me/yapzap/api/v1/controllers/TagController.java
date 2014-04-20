package me.yapzap.api.v1.controllers;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import me.yapzap.api.v1.database.TagDBHelper;
import me.yapzap.api.v1.models.Tag;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TagController {
    
    @Autowired
    private TagDBHelper tagDBHelper;
    
    @RequestMapping(value="tag_names", method=RequestMethod.GET)
    @ResponseBody
    public List<String> getTagNames(){
        return tagDBHelper.getAllTagNames();
    }
    
    @RequestMapping(value="tags", method=RequestMethod.GET)
    @ResponseBody
    public List<Tag> getAll(){
        return tagDBHelper.getMostPopularTags();
    }
    
    @RequestMapping(value="tags/{name}", method=RequestMethod.GET)
    @ResponseBody
    public Tag getByName(@PathVariable("name") String name, HttpServletResponse response) throws IOException{
        Tag tag = tagDBHelper.getByName(name);
        if (tag==null){
            response.sendError(404);
            return null;
        }
        return tag;
    }
    

    @RequestMapping(value="tags", method=RequestMethod.POST)
    @ResponseBody
    public Tag create(@RequestBody Tag tag, HttpServletResponse response) throws IOException{
        tag.setName(tag.getName().replaceAll("\\W", "").toLowerCase());
        Tag tagCreated = tagDBHelper.createTag(tag);
        if (tagCreated==null){
            response.sendError(422);
            
            return null;
        }
        return tagCreated;
    }
    

    @RequestMapping(value="tags", method=RequestMethod.PUT)
    @ResponseBody
    public Tag update(@RequestBody Tag tag, HttpServletResponse response) throws IOException{
        Tag tagUpdated = tagDBHelper.updateTag(tag);
        return tagUpdated;
    }
    
    

}
