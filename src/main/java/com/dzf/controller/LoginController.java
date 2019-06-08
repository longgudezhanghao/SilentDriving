package com.dzf.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LoginController {

    @RequestMapping("login")
    public void login(){
        System.out.println("succes");

    }

    @RequestMapping("/web")
    public String dispatch(){
        return "websocketTest";
    }
}
