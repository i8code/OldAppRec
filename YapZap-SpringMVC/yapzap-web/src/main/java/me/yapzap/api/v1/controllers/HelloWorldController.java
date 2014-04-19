package me.yapzap.api.v1.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("hello")
public class HelloWorldController {
	
	public HelloWorldController(){
		System.out.println("hello");
	}
	
	@RequestMapping(value="", method=RequestMethod.GET)
	@ResponseBody
	public String getHello(){
		return "hello";
	}

}
