package me.yapzap.api.v1.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("notifications")
public class NotificationController {
    
    @RequestMapping(method=RequestMethod.GET)
    @ResponseBody
    public String getTime(){
        return Long.toString(System.currentTimeMillis());
    }

}