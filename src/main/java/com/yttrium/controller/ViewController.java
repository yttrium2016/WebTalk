package com.yttrium.controller;


import com.yttrium.domain.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpSession;

/**
 * 控制页面的显示
 * @author 杨振宇
 *
 */
@Controller
public class ViewController {
    @RequestMapping(value="login",method= RequestMethod.GET)
    public String goLogin() {
        return "login";
    }

    @RequestMapping(value="home",method= RequestMethod.GET)
    public String goHome(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null){
            return "login";
        }
        return "home";
    }

}
