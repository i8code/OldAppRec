package me.yapzap.api.admin.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("")
public class AdminController {

    @RequestMapping(value={"metrics"}, method=RequestMethod.GET)
    public ModelAndView getAdminPage(){
        return new ModelAndView("admin");
    }
}
