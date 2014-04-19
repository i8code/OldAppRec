package me.yapzap.api.v1.controllers;

import java.util.List;

import me.yapzap.api.v1.database.NotificationDBHelper;
import me.yapzap.api.v1.models.Notification;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("notifications")
public class NotificationController {
    
    @Autowired
    private NotificationDBHelper notificationDBHelper;
    
    @RequestMapping(value="/{username}", method=RequestMethod.GET)
    @ResponseBody
    public List<Notification> getAllForUser(@PathVariable("username") String username){
        return notificationDBHelper.getAllForUser(username);
    }

}
