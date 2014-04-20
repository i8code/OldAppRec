package me.yapzap.api.v1.controllers;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import me.yapzap.api.v1.database.BlackListDBHelper;
import me.yapzap.api.v1.database.FriendDBHelper;
import me.yapzap.api.v1.models.FriendRelation;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("friends")
public class FriendController {

    @Autowired
    private FriendDBHelper friendDBHelper;
    
    @Autowired
    private BlackListDBHelper blackListDBHelper;
    
    
    @RequestMapping(value={"/{username}"}, method=RequestMethod.POST)
    @ResponseBody
    public String submitFriends(@PathVariable("username") String username, final @RequestBody List<String> friends, HttpServletRequest request, HttpServletResponse response) throws IOException{
        
        String url = request.getRequestURI();
        final String betterUsername = URLDecoder.decode(url.substring(9), "UTF-8");
        
        if (blackListDBHelper.blackListHasUser(username.split("_")[0])){
            response.sendError(403);
            return null;
        }
        
        if (StringUtils.isBlank(username)){
            response.sendError(404);
            return null;
        }
        else {
            Thread t = new Thread(new Runnable(){

                @Override
                public void run() {

                    String id = betterUsername;
                    List<FriendRelation> existingFriends = friendDBHelper.getAllForUser(id);
                    
                    Set<String> friendsToAdd = new HashSet<>();
                    
                    friendsToAdd.addAll(friends);
                    
                    //Remove the existing ones
                    for (FriendRelation existingFriend: existingFriends){
                        friendsToAdd.remove(existingFriend.getFriendId());
                    }
                    
                    //Create the new ones
                    for (String friend : friendsToAdd){
                        FriendRelation newFriend = new FriendRelation();
                        newFriend.setFriendId(friend);
                        newFriend.setFriendOf(id);
                        
                        friendDBHelper.createFriendRelation(newFriend);
                    }
                    
                }
            
            });
            t.start();
            return "Submitted";
        }
       
        
        
        
        
        
        
        
        
    }
}
