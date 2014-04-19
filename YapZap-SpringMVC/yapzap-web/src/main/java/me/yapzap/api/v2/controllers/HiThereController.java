package me.yapzap.api.v2.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("hi_there")
public class HiThereController {
	
	
	@RequestMapping(value="", method=RequestMethod.GET)
	@ResponseBody
	public String getHello(){
		return "hi there";
	}
}
