package com.dzf.controller;

import com.dzf.pojo.Person;
import com.dzf.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.http.HttpServletResponse;

@Controller
public class RegisterController {

    @Autowired
    private PersonService personService;

    @RequestMapping(value = "/register",method = RequestMethod.POST)
    public void register(@RequestBody Person person, HttpServletResponse httpServletResponse){

        personService.registerPeopleo(person);

        //添加请求头信息
        httpServletResponse.addHeader("REDIRECT", "REDIRECT");
        httpServletResponse.addHeader("CONTEXTPATH", "/s/login");

        return;

    }
}
