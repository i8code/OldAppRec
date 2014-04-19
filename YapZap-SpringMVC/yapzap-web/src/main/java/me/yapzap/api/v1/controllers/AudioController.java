package me.yapzap.api.v1.controllers;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("a")
public class AudioController {
    
    
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
        
        ModelAndView modelAndView = new ModelAndView("audio");
      //TODO: get correct filename
        modelAndView.addObject("path", "https://s3.amazonaws.com/yap-zap-audio/2014-03-16T13:51:58.099-0400_FBrachel.steinberg.773_Rachel Steinberg.mp4");
        modelAndView.addObject("title", title);
        
        return modelAndView;
    }
    
}
