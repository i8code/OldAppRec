package me.yapzap.api.v1.controllers;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
    public List<Notification> getAllForUser(HttpServletRequest request, @PathVariable("username") String username) throws UnsupportedEncodingException{
        String url = request.getRequestURI();
        final String betterUsername = URLDecoder.decode(url.substring(15), "UTF-8");
        
        return notificationDBHelper.getAllForUser(betterUsername);
    }

}
