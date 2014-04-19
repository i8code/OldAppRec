package me.yapzap.api.v1.controllers;

import java.util.List;

import me.yapzap.api.v1.database.TagDBHelper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
    
    

}
