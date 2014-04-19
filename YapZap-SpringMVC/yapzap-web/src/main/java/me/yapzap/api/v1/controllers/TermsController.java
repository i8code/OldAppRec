package me.yapzap.api.v1.controllers;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class TermsController {
    
    private static final String TERMS_LOCATION="https://docs.google.com/file/d/0Bx2vwtV2MNvMUUtYYmQyeTV6OU0/preview";
    
    @RequestMapping(value="terms", method=RequestMethod.GET)
    public void redirectToApp(HttpServletResponse response) throws IOException{
        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
        response.setHeader("Location", TERMS_LOCATION);
        response.sendRedirect(TERMS_LOCATION);
    }
}
