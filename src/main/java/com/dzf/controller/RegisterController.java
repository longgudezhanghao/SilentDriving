package com.dzf.controller;

import com.dzf.pojo.Person;
import com.dzf.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class RegisterController {

    @Autowired
    private PersonService personService;

    @RequestMapping(value = "/register",method = RequestMethod.POST)
    public String register(@RequestBody Person person){

        personService.registerPeopleo(person);

        return "redirect:login";

    }
}
