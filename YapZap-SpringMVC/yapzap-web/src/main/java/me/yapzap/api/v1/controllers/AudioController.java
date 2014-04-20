package me.yapzap.api.v1.controllers;

import javax.servlet.http.HttpServletRequest;

import me.yapzap.api.v1.database.AudioMapDBHelper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("a")
public class AudioController {
    
    
    @Autowired
    private AudioMapDBHelper audioMapDBHelper;
    
    @RequestMapping(value={"/**"}, method=RequestMethod.GET)
    public ModelAndView getAudioPage(HttpServletRequest request){
        
        String path = request.getServletPath().substring(3); //gets rid of the "/a/"

        String title = "YapZap";
        String hash = null;
        
        String[] parts = path.split("/");
        switch(parts.length){
            case 0:
                return null;
            case 1:
                hash = parts[0];
                break;
            default:
                title = parts[0];
                hash = parts[1];
                break;
        }
        
        String filename = audioMapDBHelper.getFilenameForHash(hash);
        
        ModelAndView modelAndView = new ModelAndView("audio");
        modelAndView.addObject("path", "https://s3.amazonaws.com/yap-zap-audio/"+filename);
        modelAndView.addObject("title", title);
        
        return modelAndView;
    }
    
}
