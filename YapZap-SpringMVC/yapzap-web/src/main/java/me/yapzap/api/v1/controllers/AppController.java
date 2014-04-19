package me.yapzap.api.v1.controllers;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class AppController {
    
    private static final String APP_LOCATION="https://itunes.apple.com/US/app/id844625372";
    
    @RequestMapping(value="app", method=RequestMethod.GET)
    public void redirectToApp(HttpServletResponse response) throws IOException{
        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
        response.setHeader("Location", APP_LOCATION);
        response.sendRedirect(APP_LOCATION);
    }

}
