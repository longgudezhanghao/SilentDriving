package com.dzf.controller;

import com.dzf.pojo.Person;
import com.dzf.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class LoginController {

    @Autowired
    private PersonService personService;

    //这个login只是一个辅助注册时跳转的功能
    @RequestMapping("/login")
    public String login(){

        return "login";
    }

    @RequestMapping("/reallogin")
    public String reallogin(Person person, HttpServletResponse httpServletResponse, Model model,HttpServletRequest request){

        Integer userID = personService.selectPerson(person.getName(),person.getPassword());

        request.getSession().setAttribute("USER_CD",""+userID);

        if(userID != null){
            model.addAttribute("userID",""+userID);
            return "location";
        }else {
            return "login";
        }

    }
}
