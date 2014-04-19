package me.yapzap.api.v1.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TagController {
    
    @RequestMapping(value="tags", method=RequestMethod.GET)
    @ResponseBody
    public String getTime(){
        return Long.toString(System.currentTimeMillis());
    }

}
