package me.yapzap.api.v1.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class RootController {
    
    @RequestMapping(value="", method=RequestMethod.GET)
    public ModelAndView homepage(){
        return new ModelAndView("index");
    }
    
}
