package com.yttrium.controller;


import com.alibaba.druid.util.StringUtils;
import com.yttrium.domain.DefaultResult;
import com.yttrium.domain.User;
import com.yttrium.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * User控制器
 * @author 杨振宇
 *
 */
@Controller
@RequestMapping("/user")
public class UserController {

	@Resource
	private UserService userService;
	
	@RequestMapping(value="/doLogin",method=RequestMethod.POST)
	@ResponseBody
	public DefaultResult doLogin(User user,HttpSession session) {
		DefaultResult result = new DefaultResult();

		if (!StringUtils.isEmpty(user.getLoginName())&&!StringUtils.isEmpty(user.getPassword())) {
			User dbUser = userService.findUser(user.getLoginName());
			if (dbUser != null){
				if (dbUser.getPassword().equals(user.getPassword())){
					session.setAttribute("loginUser",dbUser);
					result.setSuccess(true);
					result.setMessage("恭喜,猜对密码登录成功!");
					result.setUrl("home.html");
					return result;
				}else {
					result.setMessage("密码cuo误!");
				}
			}else {
				result.setMessage("用hu不存zai!");
			}
		}else {
			result.setMessage("用户名or密码bu能为空!");
		}

		result.setSuccess(false);
		result.setUrl("");
		return result;
	}

	@RequestMapping(value="/doSign",method=RequestMethod.POST)
	@ResponseBody
	public DefaultResult doSign(User user) {
		DefaultResult result = new DefaultResult();

		if (!StringUtils.isEmpty(user.getRepassword())&&!StringUtils.isEmpty(user.getLoginName())&&!StringUtils.isEmpty(user.getPassword())) {
			if (user.getPassword().equals(user.getRepassword())) {
				boolean isSign = userService.checkLoginName(user.getLoginName());
				if (isSign) {
					int res = userService.addUser(user);
					if (res > 0) {
						result.setSuccess(true);
						result.setUrl("login.html");
						result.setMessage("ok,注册hai行!");
						return result;
					} else {
						result.setMessage("注册失败!");
					}
				}else {
					result.setMessage("用hu名yi有了亲!");
				}
			}else {
				result.setMessage("密码or确认mi码bu一样哦!");
			}

		}else {
			result.setMessage("用户名or密码or确认mi码bu能为空!");
		}

		result.setSuccess(false);
		result.setUrl("");
		return result;
	}

	@RequestMapping(value="/doOut",method=RequestMethod.POST)
	@ResponseBody
	public DefaultResult doOut(HttpSession session) {
		DefaultResult result = new DefaultResult();
		session.removeAttribute("loginUser");
		result.setSuccess(true);
		result.setUrl("login.html");
		return result;
	}
}
